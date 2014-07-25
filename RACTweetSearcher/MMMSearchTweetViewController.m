//
//  MMMSearchTweetViewController.m
//  RACTweetSearcher
//
//  Created by KATAOKA,Atsushi on 2014/07/12.
//  Copyright (c) 2014年 MARSHMALLOW MACHINE. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/UIRefreshControl+RACCommandSupport.h>
#import "MMMSearchTweetViewController.h"
#import "MMMSearchTweetFilterViewController.h"
#import "MMMSearchTweetTableViewCell.h"
#import "MMMSearchTweetViewModel.h"
#import "MMMTweetViewModel.h"

@interface MMMSearchTweetViewController () <UIScrollViewDelegate>

@property (nonatomic) MMMSearchTweetViewModel *viewModel;
@property (nonatomic) MMMSearchTweetFilterViewController *filterViewController;
@property (nonatomic) MMMSearchTweetTableViewCell *exampleCell;
@property (nonatomic) BOOL isScrolling;

@end

@implementation MMMSearchTweetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.refreshControl = [UIRefreshControl new];
    self.isScrolling = NO;
    self.viewModel = [MMMSearchTweetViewModel new];
    self.filterViewController.viewModel = self.viewModel;

    [self defineReactiveBehaviors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)defineReactiveBehaviors
{
    self.searchButton.rac_command = self.viewModel.searchTweets;
    self.refreshControl.rac_command = self.viewModel.refreshTweets;
    
    @weakify(self);
    
    [[self.viewModel.searchTweets.executionSignals flatten] subscribeNext:^(NSArray *r){
        @strongify(self);
        
        self.title = self.viewModel.keyword;
        [self.tableView reloadData];
    }];
    
    [[self.viewModel.refreshTweets.executionSignals flatten] subscribeNext:^(NSArray *r){
        @strongify(self);
        
        [self.tableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[r count]
                                                    inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }];
    
    RACSignal *updateVisibleCells = [RACSignal interval:1
                                            onScheduler:RACScheduler.mainThreadScheduler];
    [[updateVisibleCells throttle:INFINITY
                valuesPassingTest:^(id _){
                    @strongify(self);
                    return self.isScrolling;
                }] subscribeNext:^(id _){
                    @strongify(self);
                    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"FilterHeaderView"]){
        self.filterViewController =
            (MMMSearchTweetFilterViewController *)segue.destinationViewController;
    }
}

#pragma mark - UITableViewDataSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMMSearchTweetTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    MMMTweetViewModel *viewModel = self.viewModel.tweets[indexPath.row];
    
    [self configureCell:cell withViewModel:viewModel];
    
    return cell;
}

- (void)configureCell:(MMMSearchTweetTableViewCell *)cell
        withViewModel:(MMMTweetViewModel *)viewModel
{
    [cell.iconImageView setImageWithURL:viewModel.iconURL];
    cell.fullNameLabel.text = viewModel.fullName;
    cell.screenNameLabel.text = viewModel.screenName;
    cell.tweetTextView.text = viewModel.body;
    cell.createdAtLabel.text = viewModel.createdAtAgo;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.exampleCell){
        self.exampleCell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    UITextView *tweetTextView = self.exampleCell.tweetTextView;
    MMMTweetViewModel *viewModel = self.viewModel.tweets[indexPath.row];
    tweetTextView.text = viewModel.body;
    
    CGFloat textHeight = [tweetTextView sizeThatFits:CGSizeMake(tweetTextView.frame.size.width, CGFLOAT_MAX)].height;    
    CGFloat delta = textHeight - tweetTextView.frame.size.height;
    if(delta < 0.0){
        delta = 0.0;
    }
    return self.exampleCell.frame.size.height + delta;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.isScrolling = scrollView.dragging && YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrolling = NO;
}

@end
