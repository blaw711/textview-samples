//
//  INImageTableViewCell.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/11/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INImageTableViewCell.h"
#import "NSNumber+Orientation.h"

@interface INImageTableViewCell ()

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSLayoutConstraint *sideConstraint;

@end

@implementation INImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
                
        self.chatImageView = [[UIImageView alloc] init];
        self.chatImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.chatImageView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.1].CGColor;
        self.chatImageView.layer.borderWidth = 0.5f;
        self.chatImageView.layer.cornerRadius = 15.0f;
        self.chatImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.chatImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.chatImageView];
        
        self.indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dot"]];
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.indicatorView];
        
        self.timeStamp = [[UILabel alloc] init];
        self.timeStamp.translatesAutoresizingMaskIntoConstraints = NO;
        self.timeStamp.numberOfLines = 2;
        self.timeStamp.text = @"Wed 1:49 pm";
        self.timeStamp.textColor = [UIColor lightGrayColor];
        self.timeStamp.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
        self.timeStamp.alpha = 0;
        [self.contentView addSubview:self.timeStamp];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewWasTapped)]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.timeStamp attribute:NSLayoutAttributeTop multiplier:1 constant:-3]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeStamp attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-3]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-2.5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeStamp attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-6]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.timeStamp attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
        self.blurView.alpha = 0;
        [self.chatImageView addSubview:self.blurView];
        
        [self.chatImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.chatImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.chatImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.chatImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareWithImage:(UIImage *)image privacy:(BOOL)privacy incoming:(BOOL)incoming
{
  //  if (image.size.width >= CGRectGetWidth([UIScreen mainScreen].bounds)){
        CGFloat size = image.size.width / ([NSNumber getWidthForPortrait].integerValue * .65);
        image = [UIImage imageWithCGImage:[image CGImage] scale:(image.scale * size) orientation:image.imageOrientation];
  //  }
    self.chatImageView.image = image;
    
    if (incoming) {
        self.sideConstraint = [NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    } else {
        self.sideConstraint = [NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    }
    
    [self.contentView addConstraint:self.sideConstraint];
    
    [UIView animateWithDuration:0.0 animations:^{
        self.blurView.alpha = privacy ? 1.0f : 0.0f;
    }];
}

- (void)prepareForReuse
{
    self.chatImageView.image = nil;
    [self.contentView removeConstraint:self.sideConstraint];
}

- (void)imageViewWasTapped
{
    [self.delegate imageTableView:self didSelectCellWithImage:self.chatImageView.image];
}
@end
