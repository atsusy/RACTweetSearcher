//
//  MMMSearchTweetViewModel.m
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "MMMTwitterClient+RACSignalSupport.h"
#import "MMMSearchTweetViewModel.h"
#import "MMMTweetViewModel.h"
#import "MMMTweetModel.h"

@interface MMMSearchTweetViewModel ()

@property (nonatomic) MMMTwitterClient *client;
@property (nonatomic, readwrite) RACCommand *searchTweets;
@property (nonatomic, readwrite) RACCommand *refreshTweets;

@end

@implementation MMMSearchTweetViewModel

- (id)init
{
    self = [super init];
    if(self){
        self.client = [MMMTwitterClient new];
        
        RACSignal *searchable = [RACObserve(self, keyword) map:^(NSString *keyword){
            return @(keyword.length > 0);
        }];
        
        @weakify(self);
        self.searchTweets = [[RACCommand alloc] initWithEnabled:searchable signalBlock:^(id _){
            @strongify(self);
            return [[self searchTweetsSignal] doNext:^(NSArray *tweets){
                @strongify(self);
                self.tweets = tweets;
            }];
        }];

        RACSignal *refreshable = [RACObserve(self, tweets) map:^(NSArray *tweets){
            return @(tweets.count > 0);
        }];
        
        self.refreshTweets = [[RACCommand alloc] initWithEnabled:refreshable signalBlock:^(id _){
            @strongify(self);
            NSString *sinceId = nil;
            if(self.tweets.count > 0){
                sinceId = ((MMMTweetViewModel *)self.tweets[0]).tweetId;
            }
            return [[self searchTweetsSignalSince:sinceId] doNext:^(NSArray *tweets){
                @strongify(self);
                self.tweets = [tweets arrayByAddingObjectsFromArray:self.tweets];
            }];
        }];
    }
    return self;
}

- (NSDictionary *)buildQuery:(NSString *)sinceId
{
    NSMutableDictionary *queryDict = [NSMutableDictionary new];

    NSArray *emotions = @[@"", @":(", @":)"];
    [queryDict setObject:[@[self.keyword, emotions[self.emotion]] componentsJoinedByString:@" "]
                  forKey:@"q"];
    
    NSArray *languages = @[@"", [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
    [queryDict setObject:languages[self.language] forKey:@"lang"];
 
    if(sinceId){
        [queryDict setObject:sinceId forKey:@"since_id"];
    }
    
    return [queryDict copy];
}

- (RACSignal *)searchTweetsSignal
{
    return [self searchTweetsSignalSince:nil];
}

- (RACSignal *)searchTweetsSignalSince:(NSString *)sinceId
{
    RACSignal *signal = [self.client rac_signalForSearchTweets:[self buildQuery:sinceId]];
    
    signal = [signal map:^(NSArray *tweets){
        NSArray *tweetViewModels = [[tweets.rac_sequence map:^(MMMTweetModel *tweetModel){
            MMMTweetViewModel *tweetViewModel = [[MMMTweetViewModel alloc] initWithTweet:tweetModel];
            return tweetViewModel;
        }] array];
        
        return tweetViewModels;
    }];
    
    return [signal deliverOn:RACScheduler.mainThreadScheduler];
}
@end
