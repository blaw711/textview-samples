//
//  INUserTextTableViewCell.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/10/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INUserTextTableViewCell.h"

@interface INUserTextTableViewCell ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSLayoutConstraint *labelWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelHeightConstraint;

@end

@implementation INUserTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundView.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.5 alpha:0.4];
        self.backgroundView.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor;
        self.backgroundView.layer.borderWidth = 2.0f;
        self.backgroundView.layer.cornerRadius = 15.0f;
        self.backgroundView.tag = 8;
        self.backgroundView.clipsToBounds = YES;
        [self.contentView addSubview:self.backgroundView];
        
        self.label = [[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 0;
        self.label.text = nil;
        self.label.textAlignment = NSTextAlignmentLeft;
        [self.backgroundView addSubview:self.label];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:5]];
        
         [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:4.5]];
        
         [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeWidth multiplier:1 constant:30]];
        
         [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-4.5]];
        
         [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterX multiplier:1 constant:3]];
        
         [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-0.5]];
        
        self.label.preferredMaxLayoutWidth = 218;
        
         [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeHeight multiplier:1 constant:-15]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareWithText:(NSString *)text incoming:(BOOL)incoming
{
    self.label.text = text;
    
    NSLayoutAttribute layoutAttribute;
    CGFloat layoutConstant;
    
    if (incoming) {
        self.backgroundView.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.5 alpha:0.4];
        self.backgroundView.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor;
        layoutAttribute = NSLayoutAttributeLeft;
        layoutConstant = 10;
    } else {
        self.backgroundView.backgroundColor = [UIColor colorWithRed:.5 green:.2 blue:.2 alpha:0.4];
        self.backgroundView.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.3].CGColor;
        layoutAttribute = NSLayoutAttributeRight;
        layoutConstant = -10;
    }
    NSLayoutConstraint *layoutConstraint = self.backgroundView.constraints[1];
    layoutConstraint.constant = -layoutConstraint.constant;
    
    NSArray *constraints = self.contentView.constraints;
    NSUInteger indexOfConstraint = [constraints indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ((UIView *)[obj firstItem]).tag == 8 && ([obj firstAttribute] == NSLayoutAttributeLeft || [obj firstAttribute] == NSLayoutAttributeRight);
    }];

    [self.contentView removeConstraint:constraints[indexOfConstraint]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:layoutAttribute multiplier:1 constant:layoutConstant]];
}

- (void)prepareForReuse
{
    self.label.text = nil;
    self.labelWidthConstraint.constant = 0;
    self.labelHeightConstraint.constant = 0;
}


@end
