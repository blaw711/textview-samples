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

@end

@implementation INUserViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.label = [[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.text = @"Name Here Longer Name Here";
        [self.contentView addSubview:self.label];
        
        self.chatImageView = [[UIImageView alloc] init];
        self.chatImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.chatImageView.image = [UIImage imageNamed:@"puppy"];
        self.chatImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.chatImageView.clipsToBounds = YES;
        self.chatImageView.layer.cornerRadius = 20.0f;
        self.chatImageView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.chatImageView];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
        
       [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        
    }
    
    return self;
}

- (void)prepareWithImage:(UIImage *)image name:(NSString *)name
{
    self.chatImageView.image = image;
    self.label.text = name;
    
    [self.contentView layoutIfNeeded];
}

- (void)prepareForReuse
{
    self.chatImageView.image = nil;
    self.label.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
