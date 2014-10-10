//
//  ViewController.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/9/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "ViewController.h"
#import "KBInteractiveTextView.h"
#import "DAKeyboardControl.h"
#import "INUserViewTableViewCell.h"
#import "INRecipientImageTableViewCell.h"
#import "INUserTextTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, KBInteractiveTextViewDelegate>

@property (nonatomic, strong) KBInteractiveTextView *textView;
@property (nonatomic, strong) NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSLayoutConstraint *toolbarHeight;
@property (nonatomic, strong) NSLayoutConstraint *toolBarBottomConstraint;

@property (nonatomic, strong) NSLayoutConstraint *tableViewBottomConstraint;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSNumber *keyboardHeight;

@property (nonatomic, strong) UIToolbar *toolBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.height - 40.0f)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 40.0f,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.toolBar];
    
    self.textView = [[KBInteractiveTextView alloc] init];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.delegate = self;
    //self.textView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.toolBar addSubview:self.textView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_textView);
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:0 views:views]];
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|" options:0 metrics:0 views:views]];

    
//    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f,
//                                                                           6.0f,
//                                                                           toolBar.bounds.size.width - 20.0f - 68.0f,
//                                                                           30.0f)];
//    textField.borderStyle = UITextBorderStyleRoundedRect;
//    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [toolBar addSubview:textField];
//    
//    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
//    sendButton.frame = CGRectMake(toolBar.bounds.size.width - 68.0f,
//                                  6.0f,
//                                  58.0f,
//                                  29.0f);
//    [toolBar addSubview:sendButton];
    
    
    self.view.keyboardTriggerOffset = self.toolBar.bounds.size.height;
    
    __weak typeof(self) weakSelf = self;
    
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        CGRect toolBarFrame = weakSelf.toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        weakSelf.toolBar.frame = toolBarFrame;
        
        CGRect tableViewFrame = weakSelf.tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        weakSelf.tableView.frame = tableViewFrame;
    } constraintBasedActionHandler:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;
    //keyboardSlideDuration is an instance variable so we can keep it around to use in the "dismiss keyboard" animation.
    CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:29 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.keyboardHeight = @(keyboardFrame.size.height);
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;
    //keyboardSlideDuration is an instance variable so we can keep it around to use in the "dismiss keyboard" animation.
   CGFloat keyboardSlideDuration = [[userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey] floatValue];
   CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyboardHeight = @(keyboardFrame.size.height);
    self.tableViewHeight.constant = CGRectGetHeight([UIScreen mainScreen].bounds) - self.toolbarHeight.constant - 20;
    //self.toolBarBottomConstraint.constant = 0;

    
    [UIView animateWithDuration:keyboardSlideDuration animations:^{
        [self.view layoutIfNeeded];
    }];

}

- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;

    CGFloat keyboardSlideDuration = [[userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //self.keyboardHeight = @(keyboardFrame.size.height);
//    self.textViewBottomConstraint.constant = -keyboardFrame.size.height;
    
    [UIView animateWithDuration:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
      //  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:29 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

- (void)keyBoardDidChangeFrame:(NSNotification *)notification
{
}

- (void)viewWasTapped
{
    [self.textView.textView resignFirstResponder];
}

#pragma mark - KBInteractiveTextViewDelegate

- (void)textView:(KBInteractiveTextView *)textView didChangeToHeight:(CGFloat)height
{
    [UIView animateWithDuration:0.0 animations:^{
        CGRect toolBar = self.toolBar.frame;
        toolBar.size.height = height;
        toolBar.origin.y = self.view.frame.size.height - self.keyboardHeight.floatValue - toolBar.size.height;
        self.toolBar.frame = toolBar;
    }];
    
    self.view.keyboardTriggerOffset = self.toolBar.bounds.size.height;

}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 3 == 0) {
        return 70;
    } else if(indexPath.row % 3 == 2){
        return 70;
    } else {
        return 300;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 3 == 0) {
        INUserViewTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"youimageCell"];
        
        if (!cell) {
            cell = [[INUserViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"youimageCell"];
        }
        [cell prepareWithImage:[UIImage imageNamed:@"puppy"] name:@"Ron Bergundy"];
        return cell;
    } else if(indexPath.row % 3 == 2){
        INRecipientImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        
        if (!cell) {
            cell = [[INRecipientImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        }
        [cell prepareWithImage:[UIImage imageNamed:@"puppy"] name:@"Place Holder"];
        return cell;
    } else {
        INUserTextTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"youtextimageCell"];
        if (!cell) {
            cell = [[INUserTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"youtextimageCell"];
        }
        [cell prepareWithText:@"This is a message let's see how it looks This is a message let's see how it looksThis is a message let's see how it looksThis is a message let's see how it looksThis is a message let's see how it looksThis is a message let's see how it looksThis is a message let's see how it looksThis is a message let's see how it looksThis is a message let's see how it looks"];
        return cell;

    }
    //cell.textLabel.text = @"placeholder";
    
    //[self configureCell:cell forIndexPath:indexPath];
    
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell = (INUserViewTableViewCell *)cell;
}

@end
