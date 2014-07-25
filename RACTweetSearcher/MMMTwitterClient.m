//
//  MMMTwitterClient.m
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import "MMMTwitterClient.h"
#import "MMMTweetModel.h"
@import Accounts;
@import Social;

@interface MMMTwitterClient ()

@property (nonatomic) ACAccountStore *accountStore;

@end

@implementation MMMTwitterClient

- (id)init
{
    self = [super init];
    if(self) {
        self.accountStore = [ACAccountStore new];
    }
    return self;
}

- (void)searchTweets:(NSDictionary *)parameters
                    completion:(void (^)(NSArray *, NSError *))completion;
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        // TODO:NSError generation
        completion(nil, nil);
        return;
    }
    
    ACAccountType *accountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error) {
                                                if(!granted || error){
                                                    completion(nil, error);
                                                    return;
                                                }
                                                NSArray *accounts =
                                                    [self.accountStore accountsWithAccountType:accountType];
                                                [self performSearchTweets:parameters
                                                              withAccount:[accounts lastObject]
                                                               completion:completion];
                                            }];
}

- (void)performSearchTweets:(NSDictionary *)parameters
                withAccount:(id)account
                 completion:(void (^)(NSArray *, NSError *))completion
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:parameters];
    
    [request setAccount:account];
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse,
                                         NSError *error) {
        NSArray *tweets = nil;
        NSError *_error = nil;
        if(error) {
            _error = error.copy;
        }
        else {
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError = nil;
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                               options:NSJSONReadingAllowFragments
                                                                                 error:&jsonError];
                NSArray *statuses = jsonDictionary[@"statuses"];
                if(!jsonError){
                    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:MMMTweetModel.class
                                                          fromJSONArray:statuses
                                                                  error:&jsonError];
                    if(!jsonError){
                        tweets = modelArray;
                    }
                    else{
                        _error = jsonError.copy;
                    }
                }
                else {
                    _error = jsonError.copy;
                }
            }else{
                // TODO:NSError generation
                NSLog(@"statusCode:%d", urlResponse.statusCode);
            }
        }
        completion(tweets, _error);
    }];
}

@end
