//
//  INMotherChatTableViewCell.h
//  Keyboard-Test
//
//  Created by Bob Law on 10/12/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@class INMotherChatTableViewCell;

@protocol INMotherChatTableViewCellDelegate <NSObject>

- (void)deleteCell:(INMotherChatTableViewCell *)cell;
- (void)displayTimeStamps:(BOOL)display;

@end

@interface INMotherChatTableViewCell : MCSwipeTableViewCell

@property (nonatomic, strong, readwrite) NSNumber *isPrivate;
@property (nonatomic, weak) id<INMotherChatTableViewCellDelegate> cellDelegate;
@property (nonatomic, strong) UILabel *timeStamp;

- (void)setPrivacyMode:(BOOL)private;
- (void)showTimeStamp:(BOOL)show;

@end
