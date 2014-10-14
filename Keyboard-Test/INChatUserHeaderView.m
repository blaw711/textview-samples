//
//  INChatUserHeaderView.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/14/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INChatUserHeaderView.h"

@interface INChatUserHeaderView ()

@property (nonatomic, strong) UIImageView *chatImageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation INChatUserHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
                
        self.label = [[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.label];
        
        self.chatImageView = [[UIImageView alloc] init];
        self.chatImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.chatImageView.image = [UIImage imageNamed:@"puppy"];
        self.chatImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.chatImageView.clipsToBounds = YES;
        self.chatImageView.layer.cornerRadius = 15.0f;
        self.chatImageView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.chatImageView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

- (void)prepareWithImage:(UIImage *)image name:(NSString *)name
{
    self.chatImageView.image = image;
    self.label.text = name;
    
    [self layoutIfNeeded];
}

@end
