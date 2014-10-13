//
//  INChatObject.h
//  Keyboard-Test
//
//  Created by Bob Law on 10/12/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface INChatObject : NSObject

@property (nonatomic, strong) NSNumber *incoming;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;

@end
