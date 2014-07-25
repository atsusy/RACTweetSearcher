//
//  MMMTwitterClient+RACSignalSupport.m
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import "MMMTwitterClient+RACSignalSupport.h"

@implementation MMMTwitterClient (RACSignalSupport)

- (RACSignal *)rac_signalForSearchTweets:(NSDictionary *)parameters
{
    return [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
        [self searchTweets:parameters completion:^(NSArray *tweets, NSError *error){
            if(error){
                [subscriber sendError:error];
            }else{
                [subscriber sendNext:tweets];
                [subscriber sendCompleted];
            }
        }];        
        return nil;
    }];
}

@end
