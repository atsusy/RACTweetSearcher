//
//  MMMTwitterClient+RACSignalSupport.h
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MMMTwitterClient.h"

@interface MMMTwitterClient (RACSignalSupport)

- (RACSignal *)rac_signalForSearchTweets:(NSDictionary *)parameters;

@end
