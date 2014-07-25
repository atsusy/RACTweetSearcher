//
//  MMMSearchTweetFilterViewController.h
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/16.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMSearchTweetViewModel.h"

@interface MMMSearchTweetFilterViewController : UIViewController

@property (nonatomic) MMMSearchTweetViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UITextField *keywordText;
@property (nonatomic, weak) IBOutlet UISegmentedControl *emotionControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *languageControl;

@end
