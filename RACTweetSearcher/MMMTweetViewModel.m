//
//  MMMTweetViewModel.m
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import "MMMTweetViewModel.h"
#import <NSDate+TimeAgo.h>

@interface MMMTweetViewModel ()

@property (nonatomic) NSDate *createdAt;

@end

@implementation MMMTweetViewModel

- (id)initWithTweet:(MMMTweetModel *)tweet
{
    self = [super init];
    if(self){
        self.tweetId = tweet.tweetId;
        self.iconURL = tweet.iconURL;
        self.fullName = tweet.fullName;
        self.screenName = [@"@" stringByAppendingString:tweet.screenName];
        self.body = tweet.body;
        self.createdAt = tweet.createdAt;
    }
    return self;
}

- (NSString *)createdAtAgo
{
    return [_createdAt timeAgoSimple];
}
@end
