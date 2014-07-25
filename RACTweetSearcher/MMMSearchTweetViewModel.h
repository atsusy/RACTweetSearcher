//
//  MMMSearchTweetViewModel.h
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MMMSearchTweetViewModel : NSObject

@property (nonatomic) NSString *keyword;
@property (nonatomic) NSInteger emotion;
@property (nonatomic) NSInteger language;
@property (nonatomic, copy) NSArray *tweets;

@property (nonatomic, readonly) RACCommand *searchTweets;
@property (nonatomic, readonly) RACCommand *refreshTweets;

@end
