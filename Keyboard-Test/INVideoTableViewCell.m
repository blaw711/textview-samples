//
//  INVideoTableViewCell.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/12/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INVideoTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface INVideoTableViewCell ()

@property (nonatomic, strong) MPMoviePlayerController *chatImageView;
@property (nonatomic, strong) NSNumber *isPrivate;

@property (nonatomic, strong) NSLayoutConstraint *sideConstraint;

@end

@implementation INVideoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"beach" ofType:@"mp4"];
        NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
        self.chatImageView = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
        self.chatImageView.view.translatesAutoresizingMaskIntoConstraints =  NO;
        [self.chatImageView prepareToPlay];
        
        //[self.chatImageView.view setFrame:CGRectMake(0, 0, 320, 200)];
        self.chatImageView.view.layer.cornerRadius = 15.0f;
        self.chatImageView.view.clipsToBounds = YES;
        [self.contentView addSubview:self.chatImageView.view];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:4.5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-4.5]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:150]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.chatImageView.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:260]];
    }
    
    return  self;
}

- (void)prepareWithIncoming:(BOOL)incoming
{
    [self.chatImageView play];
    
    if (incoming) {
        self.sideConstraint = [NSLayoutConstraint constraintWithItem:self.chatImageView.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    } else {
        self.sideConstraint = [NSLayoutConstraint constraintWithItem:self.chatImageView.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    }
    
    [self.contentView addConstraint:self.sideConstraint];
}

- (void)prepareForReuse
{
    [self.contentView removeConstraint:self.sideConstraint];
}

@end
