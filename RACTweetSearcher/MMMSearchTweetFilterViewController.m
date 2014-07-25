//
//  MMMSearchTweetFilterViewController.m
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/16.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "UITextField+RACKeyboardSupport.h"
#import "MMMSearchTweetFilterViewController.h"

@interface MMMSearchTweetFilterViewController () <UITextFieldDelegate>

@end

@implementation MMMSearchTweetFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setViewModel:(MMMSearchTweetViewModel *)viewModel
{
    _viewModel = viewModel;
    [self defineReactiveBehavior];
}

- (void)defineReactiveBehavior
{
    RAC(self.viewModel, keyword) = self.keywordText.rac_textSignal;
    
    RACChannelTo(self.viewModel, emotion) =
        [self.emotionControl rac_newSelectedSegmentIndexChannelWithNilValue:@(0)];

    RACChannelTo(self.viewModel, language) =
        [self.languageControl rac_newSelectedSegmentIndexChannelWithNilValue:@(0)];
    
    @weakify(self);
    [self.viewModel.searchTweets.executionSignals subscribeNext:^(id _){
        @strongify(self);
        [self.keywordText resignFirstResponder];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
