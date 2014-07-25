//
//  MMMTweetModel.h
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface MMMTweetModel : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *tweetId;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *screenName;
@property (nonatomic) NSURL *iconURL;
@property (nonatomic) NSString *body;
@property (nonatomic) NSDate *createdAt;

@end
