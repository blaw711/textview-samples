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

@property (nonatomic, strong, readwrite) NSLayoutConstraint *heightConstraint;

@end

@implementation KBInteractiveTextView


- (id)init
{
    self = [super init];
    if (self) {
        
        self.textView = [[UITextView alloc] init];
        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
        self.textView.layer.cornerRadius = 10.0f;
        self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textView.layer.borderWidth = 2.0f;
        self.textView.keyboardType = UIKeyboardTypeWebSearch;
        self.textView.textContainerInset = UIEdgeInsetsMake(5, 2, 5, 2);
        self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f];
        self.textView.delegate = self;
        [self addSubview:self.textView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.button setTitle:@"Send" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor colorWithRed:15.0/255.0 green:98.0/255.0 blue:155.0/255.0 alpha:1] forState:UIControlStateNormal];
        [self addSubview:self.button];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_textView, _button);
        NSDictionary *metrics = @{@"buttonWidth" : @(self.button.intrinsicContentSize.width)};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_textView]-5-[_button(==buttonWidth)]-5-|" options:0 metrics:metrics views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_textView]-5-|" options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_button(==30)]-5-|" options:0 metrics:0 views:views]];
    }
    
    return self;
}

- (void)textViewDidChange:(UITextView *)textView
{
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
    CGFloat maxHeight = 150;
    NSInteger newSizeH = [self measureHeight];
    if (newSizeH < minHeight || !self.textView.text) {
        newSizeH = minHeight; //not smalles than minHeight

    }
    else if (maxHeight && newSizeH > maxHeight) {
        newSizeH = maxHeight; // not taller than maxHeight
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
        return self.textView.contentSize.height + 5;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
