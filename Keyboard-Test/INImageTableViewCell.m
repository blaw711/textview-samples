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
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) NSNumber *isPrivate;

@property (nonatomic, strong) NSLayoutConstraint *sideConstraint;

@end

@implementation INImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.chatImageView = [[UIImageView alloc] init];
        self.chatImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.chatImageView.image = [UIImage imageNamed:@"puppy"];
        self.chatImageView.layer.cornerRadius = 15.0f;
        self.chatImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.chatImageView];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:4.5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-4.5]];
        
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
        self.blurView.alpha = 0;
        [self.chatImageView addSubview:self.blurView];
        
        [self.chatImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.chatImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.chatImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.chatImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.chatImageView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        gestureRecognizer.minimumPressDuration = .35;
        [self addGestureRecognizer:gestureRecognizer];
    }
    
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareWithImage:(UIImage *)image privacy:(BOOL)privacy incoming:(BOOL)incoming
{
    if (image.size.width >= CGRectGetWidth([UIScreen mainScreen].bounds)){
        CGFloat size = image.size.width / (CGRectGetWidth([UIScreen mainScreen].bounds) - 100);
        NSLog(@"%f", size);
        image = [UIImage imageWithCGImage:[image CGImage] scale:(image.scale * size) orientation:image.imageOrientation];
    }
    self.chatImageView.image = image;
    self.isPrivate = @(privacy);
    
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

- (void)longPressRecognizer:(UIGestureRecognizer *)gesture
{
    if (self.isPrivate.boolValue && gesture.state == UIGestureRecognizerStateBegan) {
        self.blurView.alpha = 0;
    } else if (self.isPrivate.boolValue && gesture.state == UIGestureRecognizerStateEnded){
        self.blurView.alpha = 1;
    }
}

- (void)prepareForReuse
{
    self.chatImageView.image = nil;
    [self.contentView removeConstraint:self.sideConstraint];
}
@end
