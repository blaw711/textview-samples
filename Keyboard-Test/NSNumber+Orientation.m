//
//  NSNumber+Orientation.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/13/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "NSNumber+Orientation.h"


@implementation NSNumber (Orientation)


+ (NSNumber *)getHeightForPortait
{
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:
            return @(CGRectGetHeight([UIScreen mainScreen].bounds));
            break;
        default:
            return @(CGRectGetWidth([UIScreen mainScreen].bounds));
            break;
    }
}

+ (NSNumber *)getWidthForPortrait
{
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:
            return @(CGRectGetWidth([UIScreen mainScreen].bounds));
            break;
        default:
            return @(CGRectGetHeight([UIScreen mainScreen].bounds));
            break;
    }
}

+ (NSNumber *)getHeightForLandscape
{
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:
            return @(CGRectGetWidth([UIScreen mainScreen].bounds));
            break;
        default:
            return @(CGRectGetHeight([UIScreen mainScreen].bounds));
            break;
    }
}

+ (NSNumber *)getWidthForLandscape
{
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:
            return @(CGRectGetHeight([UIScreen mainScreen].bounds));
            break;
        default:
            return @(CGRectGetWidth([UIScreen mainScreen].bounds));
            break;
    }
}

@end
