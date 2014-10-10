//
//  KBInteractiveTextView.h
//  Keyboard-Test
//
//  Created by Bob Law on 10/9/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KBInteractiveTextView;

@protocol KBInteractiveTextViewDelegate <NSObject>

- (void)textView:(KBInteractiveTextView *)textView didChangeToHeight:(CGFloat)height;

@end

@interface KBInteractiveTextView : UIView

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong, readonly) NSLayoutConstraint *heightConstraint;

@property (nonatomic, weak) id<KBInteractiveTextViewDelegate> delegate;

@end
