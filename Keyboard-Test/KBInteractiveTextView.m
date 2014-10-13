//
//  KBInteractiveTextView.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/9/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "KBInteractiveTextView.h"

@interface KBInteractiveTextView () <UITextViewDelegate>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *send;

@property (nonatomic, strong, readwrite) NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) UILabel *placeHolderLabel;


@end

@implementation KBInteractiveTextView


- (id)init
{
    self = [super init];
    if (self) {
        
        self.textView = [[UITextView alloc] init];
        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
        self.textView.scrollEnabled = NO;
        self.textView.layer.cornerRadius = 5.0f;
        self.textView.layer.borderWidth = 1.0f;
        self.textView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        self.textView.textAlignment = NSTextAlignmentLeft;
        self.textView.textContainerInset = UIEdgeInsetsMake(6, 2, 5, 2);
        self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f];
        self.textView.delegate = self;
        [self addSubview:self.textView];
        
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.placeHolderLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f];
        self.placeHolderLabel.text = NSLocalizedString(@"type here", @"type_placeholder");
        self.placeHolderLabel.textAlignment = NSTextAlignmentRight;
        self.placeHolderLabel.textColor = [UIColor lightGrayColor];
        //[self addSubview:self.placeHolderLabel];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.button setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [self.button setTintColor:[UIColor grayColor]];
        [self.button addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
        self.send = [UIButton buttonWithType:UIButtonTypeCustom];
        self.send.translatesAutoresizingMaskIntoConstraints = NO;
        [self.send setTitle:@"Send" forState:UIControlStateNormal];
        [self.send setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.send addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.send];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_textView, _button, _send);
        NSDictionary *metrics = @{@"buttonWidth" : @(50)};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_button(==buttonWidth)]-5-[_textView]-5-[_send(==buttonWidth)]-5-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_textView]-5-|" options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_button(==30)]-5-|" options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_send(==30)]-5-|" options:0 metrics:0 views:views]];

    }
    
    return self;
}

- (void)cameraButtonPressed
{
    [self.delegate textView:self didPressCameraButton:YES];
}

- (void)sendButtonPressed
{
    [self.delegate textView:self didPressSendButton:YES];
    self.textView.text = nil;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolderLabel.hidden = self.textView.text.length;
    [self refreshHeight];
}

-(void)resizeTextView:(NSInteger)newSizeH
{
//    if ([delegate respondsToSelector:@selector(growingTextView:willChangeHeight:)]) {
//        [delegate growingTextView:self willChangeHeight:newSizeH];
//    }
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [self layoutIfNeeded];
//    }];
//    CGRect internalTextViewFrame = self.frame;
//    internalTextViewFrame.size.height = newSizeH; // + padding
//    self.frame = internalTextViewFrame;
//    
//    internalTextViewFrame.origin.y = contentInset.top - contentInset.bottom;
//    internalTextViewFrame.origin.x = contentInset.left;
//    
//    if(!CGRectEqualToRect(internalTextView.frame, internalTextViewFrame)) internalTextView.frame = internalTextViewFrame;
}

- (void)refreshHeight
{
    //size of content, so we can set the frame of self
    CGFloat minHeight = 40;
    CGFloat maxHeight = 140;
    NSInteger newSizeH = [self measureHeight] + 7;
    if (newSizeH < minHeight || !self.textView.text) {
        newSizeH = minHeight; //not smalles than minHeight
        self.textView.scrollEnabled = NO;
    }
    else if (maxHeight && newSizeH > maxHeight) {
        newSizeH = maxHeight; // not taller than maxHeight
        self.textView.scrollEnabled = YES;
    }
    [self resizeTextView:newSizeH];
    [self.delegate textView:self didChangeToHeight:newSizeH];

}

- (CGFloat)measureHeight
{
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        return ceilf([self.textView sizeThatFits:self.textView.frame.size].height);
    }
    else {
        return self.textView.contentSize.height;
    }
}

@end
