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
- (void)textView:(KBInteractiveTextView *)textView didPressCameraButton:(BOOL)pressed;
- (void)textView:(KBInteractiveTextView *)textView didPressSendButton:(BOOL)pressed;


@end

@interface KBInteractiveTextView : UIView

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong, readonly) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSNumber *maxHeight;

@property (nonatomic, weak) id<KBInteractiveTextViewDelegate> delegate;

@end
