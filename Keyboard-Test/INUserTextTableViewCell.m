//
//  INUserTextTableViewCell.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/10/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INUserTextTableViewCell.h"
#import "TTTAttributedLabel.h"

@interface INUserTextTableViewCell ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) TTTAttributedLabel *label;
@property (nonatomic, strong) NSLayoutConstraint *labelWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelHeightConstraint;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UILabel *timeStamp;
@property (nonatomic, strong) UIImageView *indicatorView;

@end

@implementation INUserTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundView.layer.borderWidth = 2.0f;
        self.backgroundView.layer.cornerRadius = 15.0f;
        self.backgroundView.tag = 8;
        self.backgroundView.clipsToBounds = YES;
        [self.contentView addSubview:self.backgroundView];
        
        self.label = [[TTTAttributedLabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.enabledTextCheckingTypes = NSTextCheckingTypeAddress | NSTextCheckingTypeDate | NSTextCheckingTypeLink;
        self.label.numberOfLines = 0;
        self.label.text = nil;
        self.label.textAlignment = NSTextAlignmentLeft;
        [self.backgroundView addSubview:self.label];
        
        self.indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.indicatorView];
        
        self.timeStamp = [[UILabel alloc] init];
        self.timeStamp.translatesAutoresizingMaskIntoConstraints = NO;
        self.timeStamp.numberOfLines = 2;
        self.timeStamp.text = @"now";
        self.timeStamp.textColor = [UIColor lightGrayColor];
        self.timeStamp.font = [UIFont fontWithName:@"Helvetica-NeueThin" size:13.0f];
        [self.contentView addSubview:self.timeStamp];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:4.5]];
        
         [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:4.5]];
        
         [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeWidth multiplier:1 constant:30]];
        
         [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.timeStamp attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
         [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterX multiplier:1 constant:3]];
        
         [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-0.5]];
        
        self.label.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) * .75;
        
         [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeHeight multiplier:1 constant:-15]];
        
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
        self.blurView.alpha = 0;
        [self.backgroundView addSubview:self.blurView];
        
        [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeStamp attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-2.5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeStamp attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-6]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.timeStamp attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareWithText:(NSString *)text incoming:(BOOL)incoming privacy:(BOOL)privacy
{
    self.label.text = text;
    
    self.isPrivate = @(privacy);
    
    NSLayoutAttribute layoutAttribute;
    CGFloat layoutConstant;
    
    if (incoming) {
        self.backgroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        self.backgroundView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1].CGColor;
        self.label.textColor = [UIColor blackColor];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.indicatorView.image = nil;
        layoutAttribute = NSLayoutAttributeLeft;
        layoutConstant = 10;
    } else {
        self.backgroundView.backgroundColor = [UIColor colorWithRed:91.0/255.0 green:173.0/255.0 blue:230.0/255.0 alpha:1.0];
        self.backgroundView.layer.borderColor = [UIColor colorWithRed:91.0/255.0 green:173.0/255.0 blue:230.0/255.0 alpha:0.8].CGColor;
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.textColor = [UIColor whiteColor];
        self.indicatorView.image = [UIImage imageNamed:@"dot"];
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
    
    [UIView animateWithDuration:0.0 animations:^{
        self.blurView.alpha = privacy ? 1.0f : 0.0f;
    }];
}

- (void)prepareForReuse
{
    self.label.text = nil;
}


@end
