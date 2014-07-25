//
//  MMMTwitterClient.h
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMTwitterClient : NSObject

- (void)searchTweets:(NSDictionary *)parameters
                    completion:(void (^)(NSArray *tweets, NSError *error))completion;

@end
