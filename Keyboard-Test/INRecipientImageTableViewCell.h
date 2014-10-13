//
//  INRecipientImageTableViewCell.h
//  Keyboard-Test
//
//  Created by Bob Law on 10/10/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INMotherChatTableViewCell.h"

@interface INRecipientImageTableViewCell : UITableViewCell

- (void)prepareWithImage:(UIImage *)image name:(NSString *)name;

@end
