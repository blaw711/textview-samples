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
#import "INVideoTableViewCell.h"
#import "INChatObject.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"

const static CGFloat kInitialToolBarHeight = 45.0f;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, KBInteractiveTextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate, INImageTableViewCellDelegate, INMotherChatTableViewCellDelegate>

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

@property(nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSMutableArray *chatArray;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;

@property (nonatomic, strong) INImageTableViewCell *imageCell;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatArray = [NSMutableArray new];
    
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.height - 44.0f)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollsToTop = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 70.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 44.0f,
                                                                     self.view.bounds.size.width,
                                                                     kInitialToolBarHeight)];
    
    
    self.isPrivate = @(NO);
    
    self.userArray = @[@"dfuwbenfiwbjenfiwebfwleifjbwlefjbwielfblwefjbnwleifjnlweifj", @"ou think water moves fast? You should see ice. It moves like it has a mind. Like it knows it killed the world once and got a taste for murder. After the avalanche, it took us a week to climb out.", @"w dfjb wnef wef wef ewf ew fe wfwe f wef wef ewf we f wef wef  few", @"dfwefwef wedwedw"].mutableCopy;
    self.recipientArray = @[@"Check out this website! www.google.com", @"ewdjed wew qwr0etuopi 093ry23bieuqwd 2f3hiowfe", @"dfibwebfwe sad cdfv eweqw", @"wefjhwefjkwefh"].mutableCopy;
    
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.toolBar];
    
    self.textView = [[KBInteractiveTextView alloc] init];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.delegate = self;
    [self.toolBar addSubview:self.textView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_textView);
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|" options:0 metrics:0 views:views]];
    [self.toolBar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|" options:0 metrics:0 views:views]];
    
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
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height > CGRectGetHeight([UIScreen mainScreen].bounds) - toolBarFrame.size.height ? CGRectGetHeight([UIScreen mainScreen].bounds) - toolBarFrame.size.height : keyboardFrameInView.origin.y - toolBarFrame.size.height;
        weakSelf.toolBar.frame = toolBarFrame;
        CGRect tableViewFrame = weakSelf.tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        weakSelf.tableView.frame = tableViewFrame;
    } constraintBasedActionHandler:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
//    [self.shyNavBarManager setExtensionView:toolBar];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    self.shyNavBarManager.scrollView = self.tableView;
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    self.shyNavBarManager.scrollView = self.tableView;
//
//}

//- (void) viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    
//   // ;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;
    //keyboardSlideDuration is an instance variable so we can keep it around to use in the "dismiss keyboard" animation.
    CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:49 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.keyboardHeight = @(keyboardFrame.size.height);
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = notification.userInfo;
    //keyboardSlideDuration is an instance variable so we can keep it around to use in the "dismiss keyboard" animation.
   CGFloat keyboardSlideDuration = [[userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey] floatValue];
   CGRect keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyboardHeight = @(keyboardFrame.size.height);

    
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

#pragma mark - INMotherChatTableViewCellDelegate

- (void)deleteCell:(INMotherChatTableViewCell *)cell
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    [self.chatArray removeObjectAtIndex:[self.tableView indexPathForCell:cell].row];
    [self.tableView endUpdates];
    if (self.chatArray.count == 0 || !self.chatArray) {
        self.chatArray = [NSMutableArray new];
    }
}

- (void)displayTimeStamps:(BOOL)display
{
    for (INMotherChatTableViewCell *cell in [self.tableView visibleCells]) {
        [cell showTimeStamp:display];
    }
}

#pragma mark - KBInteractiveTextViewDelegate

- (void)textView:(KBInteractiveTextView *)textView didChangeToHeight:(CGFloat)height
{
    [UIView animateWithDuration:0.0 animations:^{
        CGRect toolBar = self.toolBar.frame;
        toolBar.size.height = height + 5;
        toolBar.origin.y = self.view.frame.size.height - self.keyboardHeight.floatValue - toolBar.size.height;
        self.toolBar.frame = toolBar;
        
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.size.height = toolBar.origin.y;
        self.tableView.frame = tableViewFrame;
    }];

    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:49 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    self.view.keyboardTriggerOffset = self.toolBar.bounds.size.height;

}

- (void)textView:(KBInteractiveTextView *)textView didPressCameraButton:(BOOL)pressed
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;

    UIAlertController *alertView = [[UIAlertController alloc] init];
    [alertView addAction:[UIAlertAction actionWithTitle:@"Take Photo or Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        pickerController.mediaTypes = mediaTypes;
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

- (void)textView:(KBInteractiveTextView *)textView didPressSendButton:(BOOL)pressed
{
    INChatObject *chatObject = [[INChatObject alloc] init];
    chatObject.text = self.textView.textView.text;
    self.textView.textView.text = @"";
    chatObject.image = self.image.copy;
    chatObject.incoming = self.segment.selectedSegmentIndex == 0 ? @(NO) : @(YES);
    
    [self.chatArray addObject:chatObject];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.chatArray.count -1  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    self.image = nil;
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count -1  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma marks - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatArray.count;
}

- (UITableViewCell *)CellAtIndexPath:(NSIndexPath *)indexPath
{
    INChatObject *object = self.chatArray[indexPath.row];
    
    if (object.image) {
        INImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"realimageCell"];
        if (!cell) {
            cell = [[INImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"realimageCell"];
        }
        cell.delegate = self;
        cell.cellDelegate = self;
        [cell setPrivacyMode:self.isPrivate.boolValue];
        [cell prepareWithImage:object.image privacy:self.isPrivate.boolValue incoming:object.incoming.boolValue];
        return cell;
    } else {
        INUserTextTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"youtextimageCell"];
        if (!cell) {
            cell = [[INUserTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"youtextimageCell"];
        }
        [cell prepareWithText:object.text incoming:object.incoming.boolValue privacy:self.isPrivate.boolValue];
        [cell setPrivacyMode:self.isPrivate.boolValue];
        cell.cellDelegate = self;
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self CellAtIndexPath:indexPath];
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
        
        for (INMotherChatTableViewCell *cell in [self.tableView visibleCells]) {
            [cell setPrivacyMode:self.isPrivate.boolValue];
        }
        //r[self.tableView reloadData];
    } 
}

#pragma marks - INImageTableViewCellDelegate

- (void)imageTableView:(INImageTableViewCell *)imageCell didSelectCellWithImage:(UIImage *)image
{
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:image];
    viewController.transitioningDelegate = self;
    self.imageCell = imageCell;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.imageCell.chatImageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.imageCell.chatImageView];
    }
    return nil;
}


@end
