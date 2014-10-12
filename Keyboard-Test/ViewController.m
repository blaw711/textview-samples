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
#import "INImageTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, KBInteractiveTextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) KBInteractiveTextView *textView;
@property (nonatomic, strong) NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSLayoutConstraint *toolbarHeight;
@property (nonatomic, strong) NSLayoutConstraint *toolBarBottomConstraint;

@property (nonatomic, strong) NSLayoutConstraint *tableViewBottomConstraint;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSNumber *keyboardHeight;

@property (nonatomic, strong) UIToolbar *toolBar;

@property (nonatomic, strong) NSMutableArray *userArray;
@property (nonatomic, strong) NSMutableArray *recipientArray;

@property (nonatomic, strong) NSNumber *isPrivate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Chat"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.height - 40.0f)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0f;
    [self.view addSubview:self.tableView];
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 40.0f,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    
    self.isPrivate = @(NO);
    
    self.userArray = @[@"dfuwbenfiwbjenfiwebfwleifjbwlefjbwielfblwefjbnwleifjnlweifj", @"dfjnwkejfbnw wefjbknwefw fw weweew wewew dfwef wef wef wef we fwe f wef ewf ef", @"wdfjbwnef wef wef ewf ew fe wfwe f wef wef ewf we f wef wef  few", @"dfwefwef wedwedw"].mutableCopy;
    self.recipientArray = @[@"fwonefenwjkenewfnjefwjkn", @"ewdjed wew qwr0etuopi 093ry23bieuqwd 2f3hiowfe", @"dfibwebfwe sad cdfv eweqw", @"wefjhwefjkwefh"].mutableCopy;
    
    self.toolBar.translucent = YES;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
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

- (void)viewDidAppear:(BOOL)animated
{
  //  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:49 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:49 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotate
{
//    self.tableView.scrollEnabled = NO;
//    [self.tableView reloadData];
//    self.tableView.scrollEnabled = YES;
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;
    //keyboardSlideDuration is an instance variable so we can keep it around to use in the "dismiss keyboard" animation.
    CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:49 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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

- (void)textView:(KBInteractiveTextView *)textView didPressCameraButton:(BOOL)pressed
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;

    UIAlertController *alertView = [[UIAlertController alloc] init];
    [alertView addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        pickerController.showsCameraControls = YES;
        [self presentViewController:pickerController animated:YES completion:nil];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"Choose Existing" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:YES completion:nil];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 5 == 0) {
        INUserViewTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"kimageCell"];
        
        if (!cell) {
            cell = [[INUserViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kimageCell"];
        }
        [cell prepareWithImage:[UIImage imageNamed:@"pup"] name:@"Ron Bergundy"];
        return cell;
    } else if (indexPath.row % 5 == 1){
        INUserTextTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"youtextimageCell"];
        if (!cell) {
            cell = [[INUserTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"youtextimageCell"];
        }
        [cell prepareWithText:self.userArray[indexPath.row % 3] incoming:NO privacy:self.isPrivate.boolValue];
        return cell;
    } else if(indexPath.row % 5 == 2){
        INRecipientImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"imageCell"];

        if (!cell) {
            cell = [[INRecipientImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
        }
        [cell prepareWithImage:[UIImage imageNamed:@"puppy"] name:@"Bob Law"];
        return cell;
    } else if(indexPath.row % 5 == 3){
        INUserTextTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"youtextimageCell"];
        if (!cell) {
            cell = [[INUserTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"youtextimageCell"];
        }
        [cell prepareWithText:self.recipientArray[indexPath.row % 3] incoming:YES privacy:self.isPrivate.boolValue];
        return cell;

    } else {
        INImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"realimageCell"];
        if (!cell) {
            cell = [[INImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"realimageCell"];
        }
        [cell prepareWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"puppy%ld", indexPath.row % 4]] privacy:self.isPrivate.boolValue incoming:indexPath.row % 2 == 0 ? YES : NO];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        self.isPrivate = [NSNumber numberWithBool:!self.isPrivate.boolValue];
        //r[self.tableView reloadData];
    } 
}

@end
