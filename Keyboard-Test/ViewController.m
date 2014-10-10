//
//  ViewController.m
//  Keyboard-Test
//
//  Created by Bob Law on 10/9/14.
//  Copyright (c) 2014 Bob Law. All rights reserved.
//

#import "ViewController.h"
#import "KBInteractiveTextView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, KBInteractiveTextViewDelegate>

@property (nonatomic, strong) KBInteractiveTextView *textView;
@property (nonatomic, strong) NSLayoutConstraint *textViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *tableViewHeight;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSNumber *keyboardHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[KBInteractiveTextView alloc] init];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.delegate = self;
//    self.textView.textView.inputAccessoryView = self.textView;
    [self.view addSubview:self.textView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:self.tableView];
    
    self.tableViewHeight = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight([UIScreen mainScreen].bounds) - self.textView.heightConstraint.constant];
    [self.view addConstraint:self.tableViewHeight];

    
    self.textViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0];
    [self.view addConstraint:self.textViewBottomConstraint];
    
    
    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textView(==40)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_textView)]];
    NSDictionary *views = NSDictionaryOfVariableBindings(_textView, _tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:0 views:views]];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

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
    CGFloat keyboardSlideDuration = [[userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyboardHeight = @(keyboardFrame.size.height);
    self.textViewBottomConstraint.constant = -keyboardFrame.size.height;
    self.tableViewHeight.constant = CGRectGetHeight([UIScreen mainScreen].bounds) - keyboardFrame.size.height - self.textView.heightConstraint.constant;
    
    [UIView animateWithDuration:keyboardSlideDuration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:29 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];

    
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;
    //keyboardSlideDuration is an instance variable so we can keep it around to use in the "dismiss keyboard" animation.
   CGFloat keyboardSlideDuration = [[userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey] floatValue];
   CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyboardHeight = @(keyboardFrame.size.height);
    self.textViewBottomConstraint.constant = 0;
    self.tableViewHeight.constant = self.tableViewHeight.constant + keyboardFrame.size.height;

    
    [UIView animateWithDuration:keyboardSlideDuration animations:^{
        [self.view layoutIfNeeded];
    }];

}

- (void)keyBoardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;

    CGFloat keyboardSlideDuration = [[userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    self.keyboardHeight = @(keyboardFrame.size.height);
    self.textViewBottomConstraint.constant = -keyboardFrame.size.height;
    self.tableViewHeight.constant = CGRectGetHeight([UIScreen mainScreen].bounds) - keyboardFrame.size.height - self.textView.heightConstraint.constant;
    
    [UIView animateWithDuration:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:29 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    
    
}

- (void)viewWasTapped
{
    [self.textView.textView resignFirstResponder];
}

#pragma mark - KBInteractiveTextViewDelegate

- (void)textView:(KBInteractiveTextView *)textView didChangeToHeight:(CGFloat)height
{
    self.tableViewHeight.constant = CGRectGetHeight([UIScreen mainScreen].bounds) - self.keyboardHeight.floatValue - height;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = @"placeholder";
    
    return cell ;
}

- (UIView *)inputAccessoryView {
    //if (!inputAccessoryView) {
        CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 77.0);
        UIView *inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
        inputAccessoryView.backgroundColor = [UIColor blueColor];
        UIButton *compButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        compButton.frame = CGRectMake(313.0, 20.0, 158.0, 37.0);
        [compButton setTitle: @"Word Completions" forState:UIControlStateNormal];
        [compButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     //   [compButton addTarget:self action:@selector(completeCurrentWord:)
           //  forControlEvents:UIControlEventTouchUpInside];
        [inputAccessoryView addSubview:compButton];
    //}
    return inputAccessoryView;
}

//- (UIView *)inputAccessoryView{
//    
//    return self.textView;
//    // where inputAccessoryToolbar is your keyboard accessory view
//    
//}
//
//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}



@end
