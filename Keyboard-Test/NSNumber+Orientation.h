//
//  NSNumber+Orientation.h
//  Keyboard-Test
//
//  Created by Bob Law on 10/13/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNumber (Orientation)

+ (NSNumber *)getHeightForPortait;
+ (NSNumber *)getWidthForPortrait;

+ (NSNumber *)getWidthForLandscape;
+ (NSNumber *)getHeightForLandscape;

@end
