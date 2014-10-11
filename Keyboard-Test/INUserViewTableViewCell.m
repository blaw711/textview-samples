//
//  INImageViewTableViewCell.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/10/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INUserViewTableViewCell.h"

@interface INUserViewTableViewCell ()

@property (nonatomic, strong) UIImageView *chatImageView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *labelWidthConstraint;

@end

@implementation INUserViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIView *profileView = [[UIView alloc] init];
        profileView.translatesAutoresizingMaskIntoConstraints = NO;
        profileView.backgroundColor = [UIColor colorWithRed:.2 green:.2 blue:.5 alpha:0.4];
        profileView.layer.borderColor = [UIColor blueColor].CGColor;
        profileView.layer.borderWidth = 2.0f;
        profileView.layer.cornerRadius = 25.0f;
        [self.contentView addSubview:profileView];
        
        self.widthConstraint = [NSLayoutConstraint constraintWithItem:profileView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        [self.contentView addConstraint:self.widthConstraint];
        
        self.label = [[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.textColor = [UIColor whiteColor];
        self.label.text = @"Name Here Longer Name Here";
        [profileView addSubview:self.label];
        
        self.labelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        [self.contentView addConstraint:self.labelWidthConstraint];
        
        self.chatImageView = [[UIImageView alloc] init];
        self.chatImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.chatImageView.image = [UIImage imageNamed:@"puppy"];
        self.chatImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.chatImageView.clipsToBounds = YES;
        self.chatImageView.layer.cornerRadius = 20.0f;
        self.chatImageView.backgroundColor = [UIColor blueColor];
        [profileView addSubview:self.chatImageView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_chatImageView, _label);
        [profileView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_label]-3-[_chatImageView(==40)]-5-|" options:0 metrics:nil views:views]];
        [profileView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_chatImageView(==40)]-5-|" options:0 metrics:0 views:views]];
        [profileView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_label]-5-|" options:0 metrics:0 views:views]];
        views = NSDictionaryOfVariableBindings(profileView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[profileView]-10-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[profileView]-5-|" options:0 metrics:0 views:views]];
    }
    
    return self;
}

- (void)prepareWithImage:(UIImage *)image name:(NSString *)name
{
    self.chatImageView.image = image;
    self.label.text = name;
    self.labelWidthConstraint.constant = self.label.intrinsicContentSize.width;
    self.widthConstraint.constant = self.label.intrinsicContentSize.width + 65;
    
    [self.contentView layoutIfNeeded];
}

- (void)prepareForReuse
{
    self.chatImageView.image = nil;
    self.label.text = nil;
    self.widthConstraint.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
