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

@end

@interface INMotherChatTableViewCell : MCSwipeTableViewCell

@property (nonatomic, strong, readwrite) NSNumber *isPrivate;
@property (nonatomic, weak) id<INMotherChatTableViewCellDelegate> cellDelegate;

@end
