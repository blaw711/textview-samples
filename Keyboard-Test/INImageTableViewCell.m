//
//  INImageTableViewCell.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/11/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INImageTableViewCell.h"

@interface INImageTableViewCell ()

@property (nonatomic, strong) UIImageView *chatImageView;

@end

@implementation INImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.chatImageView = [[UIImageView alloc] init];
        self.chatImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.chatImageView.image = [UIImage imageNamed:@"puppy"];
        self.chatImageView.layer.cornerRadius = 15.0f;
        self.chatImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.chatImageView];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:4.5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-4.5]];
    }
    
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareWithImage:(UIImage *)image
{
    if (image.size.width >= CGRectGetWidth([UIScreen mainScreen].bounds)){
        CGFloat size = image.size.width / (CGRectGetWidth([UIScreen mainScreen].bounds) - 20);
        NSLog(@"%f", size);
        image = [UIImage imageWithCGImage:[image CGImage] scale:(image.scale * size) orientation:image.imageOrientation];
    }
    self.chatImageView.image = image;
}

- (void)prepareForReuse
{
    self.chatImageView.image = nil;
}
@end
