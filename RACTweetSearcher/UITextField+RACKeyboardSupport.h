//
//  UITextField+RACKeyboardSupport.h
//  RACTweetSearcher
//
//  https://gist.github.com/lukeredpath/9051769

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UITextField (RACKeyboardSupport)

- (RACSignal *)rac_keyboardReturnSignal;

@end
