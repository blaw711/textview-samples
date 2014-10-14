//
//  INUserTextTableViewCell.h
//  Keyboard-Test
//
//  Created by Bob Law on 10/10/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INMotherChatTableViewCell.h"


@interface INChatMessageTableViewCell : INMotherChatTableViewCell

- (void)prepareWithText:(NSString *)text incoming:(BOOL)incoming privacy:(BOOL)privacy;

@end
