//
//  MMMTweetViewModel.h
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MMMTweetModel.h"

@interface MMMTweetViewModel : NSObject

@property (nonatomic) NSString *tweetId;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *screenName;
@property (nonatomic) NSURL *iconURL;
@property (nonatomic) NSString *body;
@property (nonatomic, readonly) NSString *createdAtAgo;

- (id)initWithTweet:(MMMTweetModel *)tweet;

@end
