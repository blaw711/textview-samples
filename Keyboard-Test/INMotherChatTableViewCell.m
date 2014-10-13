//
//  INMotherChatTableViewCell.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/12/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "INMotherChatTableViewCell.h"
#import "DACircularProgressView.h"

@interface INMotherChatTableViewCell () <MCSwipeTableViewCellDelegate>

@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) NSLayoutConstraint *timeStampConstraint;

@end

@implementation INMotherChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
//        gestureRecognizer.minimumPressDuration = .25;
//        [self addGestureRecognizer:gestureRecognizer];
        
        self.firstTrigger = 0.3;
        self.secondTrigger = 0.5;
        self.velocity = 0.0f;
        self.delegate = self;
        
        UIView *swipeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        swipeView.backgroundColor = [UIColor greenColor];
        
        UIView *deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        deleteView.backgroundColor = [UIColor redColor];
        
        __weak typeof(self) weakSelf = self;
        [self setSwipeGestureWithView:swipeView color:[UIColor whiteColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            NSLog(@"Did swipe \"Checkmark\" cell");
        }];
        
        [self setSwipeGestureWithView:deleteView color:[UIColor whiteColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            NSLog(@"Did swipe \"Cross\" cell");
            [weakSelf.cellDelegate deleteCell:weakSelf];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = weakSelf.contentView.frame;
                frame.origin.x = CGRectGetWidth([UIScreen mainScreen].bounds);
                weakSelf.contentView.frame = frame;
                weakSelf.contentView.alpha = 0;
            }];
        }];
        
        [self setSwipeGestureWithView:swipeView color:[UIColor whiteColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            NSLog(@"Did swipe \"Checkmark\" cell");
            
        }];
        
        [self setSwipeGestureWithView:deleteView color:[UIColor whiteColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState4 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
            NSLog(@"Did swipe \"Cross\" cell");
            [weakSelf.cellDelegate deleteCell:weakSelf];
//            [UIView animateWithDuration:0.3 animations:^{
//                CGRect frame = weakSelf.contentView.frame;
//                frame.origin.x = -CGRectGetWidth([UIScreen mainScreen].bounds);
//                weakSelf.contentView.frame = frame;
//                weakSelf.contentView.alpha = 0;
//            }];

        }];
    }
    
    return self;
}

- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell
{
    
}
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell
{
    
}
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage
{
    
}

- (void)longPressRecognizer:(UIGestureRecognizer *)gesture
{
    NSInteger alpha;
    if (self.isPrivate.boolValue && gesture.state == UIGestureRecognizerStateBegan) {
        alpha = 0;
    } else if (self.isPrivate.boolValue && gesture.state == UIGestureRecognizerStateEnded){
        alpha = 1;
    } else if (gesture.state == UIGestureRecognizerStateBegan){
        //show timestamp
        
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        //hide timestamp
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.contentView layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.blurView.alpha = alpha;
    }];
}

@end
