//
//  MMMTweetModel.m
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import "MMMTweetModel.h"

@implementation MMMTweetModel

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"tweetId" : @"id_str",
              @"fullName" : @"user.name",
              @"screenName" : @"user.screen_name",
              @"iconURL" : @"user.profile_image_url",
              @"body" : @"text",
              @"createdAt" : @"created_at" };
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

@end
