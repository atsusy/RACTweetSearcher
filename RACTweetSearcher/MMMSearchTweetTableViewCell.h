//
//  MMMSearchTweetTableViewCell.h
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMSearchTweetTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *screenNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, weak) IBOutlet UITextView *tweetTextView;
@property (nonatomic, weak) IBOutlet UILabel *createdAtLabel;

@end
