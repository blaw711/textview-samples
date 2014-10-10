//
//  INUserTextTableViewCell.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/10/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INUserTextTableViewCell.h"

@interface INUserTextTableViewCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSLayoutConstraint *labelWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelHeightConstraint;

@end

@implementation INUserTextTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIView *holdingView = [[UIView alloc] init];
        holdingView.translatesAutoresizingMaskIntoConstraints = NO;
        holdingView.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.5 alpha:0.4];
        holdingView.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor;
        holdingView.layer.borderWidth = 2.0f;
        holdingView.layer.cornerRadius = 25.0f;
        holdingView.clipsToBounds = YES;
        [self.contentView addSubview:holdingView];
        
        self.labelWidthConstraint = [NSLayoutConstraint constraintWithItem:holdingView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        [self.contentView addConstraint:self.labelWidthConstraint];
        self.labelHeightConstraint = [NSLayoutConstraint constraintWithItem:holdingView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        [self.contentView addConstraint:self.labelHeightConstraint];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(holdingView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[holdingView]" options:0 metrics:0 views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[holdingView]-10-|" options:0 metrics:0 views:views]];
        
        self.label = [[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 100;
        self.label.text = nil;
        self.label.textAlignment = NSTextAlignmentCenter;
        [holdingView addSubview:self.label];
        
        views = NSDictionaryOfVariableBindings(_label);
        [holdingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_label]-5-|" options:0 metrics:0 views:views]];
        [holdingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_label]-5-|" options:0 metrics:0 views:views]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareWithText:(NSString *)text
{
    self.label.text = text;
    self.labelWidthConstraint.constant = MIN(self.label.intrinsicContentSize.width + 20, [UIScreen mainScreen].bounds.size.width / 1.5);
    self.labelHeightConstraint.constant = MAX(self.label.intrinsicContentSize.height + 20, 100);
    self.label.layer.cornerRadius = 15.0;
    
    [self.contentView layoutIfNeeded];
}

- (void)prepareForReuse
{
    self.label.text = nil;
    self.labelWidthConstraint.constant = 0;
    self.labelHeightConstraint.constant = 0;
}


@end
