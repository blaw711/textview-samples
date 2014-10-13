//
//  INImageTableViewCell.h
//  Keyboard-Test
//
//  Created by Bob Law on 10/11/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INMotherChatTableViewCell.h"

@class INImageTableViewCell;

@protocol INImageTableViewCellDelegate <NSObject>

- (void)imageTableView:(INImageTableViewCell *)imageCell didSelectCellWithImage:(UIImage *)image;

@end

@interface INImageTableViewCell : INMotherChatTableViewCell

@property (nonatomic, strong) UIImageView *chatImageView;
@property (nonatomic, weak) id<INImageTableViewCellDelegate> delegate;

- (void)prepareWithImage:(UIImage *)image privacy:(BOOL)privacy incoming:(BOOL)incoming;


@end
