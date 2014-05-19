//
//  SDAddPostViewController.m
//  shudong
//
//  Created by Eric Tao on 4/28/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDAddPostViewController.h"
#import "SDUtils.h"
#import "Constants.h"
#import "SDTabViewController.h"
@interface SDAddPostViewController () {
    
    
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) NSMutableArray *myHoles;

@property BOOL isUsingSystemBackground;
@property (strong, nonatomic) NSNumber *selectedPicId;

@property (weak, nonatomic) IBOutlet UITextField *titleField;

@end

@implementation SDAddPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    _background.userInteractionEnabled = YES;
    [_background addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    
    _selectedPicId = @5;
    _background.image = [UIImage imageNamed:[_selectedPicId.stringValue stringByAppendingString:@".jpg"]];
    
    _toolbar.frame = CGRectMake(0, Screen_Height, 320, 44);
//    _titleField.layer.borderWidth = 2.0f;
//    _titleField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardDidChangeFrameNotification object:nil];

    
    _myHoles =  [NSMutableArray arrayWithArray:[SDUtils sharedInstance].myHoles];
    _isUsingSystemBackground = YES;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [_contentText becomeFirstResponder];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    SDTabViewController *tabvc = (SDTabViewController *)self.tabBarController;
//    [tabvc hideButton:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showPictureOptions:(id)sender {
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", @"拍照", nil];
    
    actionsheet.tag = 1;
    
    [actionsheet showInView:self.view];
    
    
}
- (IBAction)changeSystemBgRandomly:(id)sender {
    
    NSInteger pictureId = (rand() % 30);
    if ([[NSNumber numberWithInt:pictureId] isEqualToNumber:_selectedPicId]) {
        [self changeSystemBgRandomly:nil];
    }
    
    _selectedPicId = [NSNumber numberWithInt:pictureId];
    _background.image = [UIImage imageNamed:[_selectedPicId.stringValue stringByAppendingString:@".jpg"]];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIImagePicker Delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    _background.image = pickedImage;
    _isUsingSystemBackground = NO;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark UIActionSheet delegate methods 
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0: { //from library
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.allowsEditing = YES;
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
                break;
            }
            case 1: {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.allowsEditing = YES;
                picker.delegate = self;
                BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断照相机是否可用（是否有摄像头）
                if (hasCamera) {
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];

                } else {
                }

            }
            default:
                break;
        }
    }
}

- (void)keyboardWillAppear:(NSNotification *)notification {
    //调整两个按钮的位置
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        _contentText.frame = CGRectMake(0, _toolbar.frame.size.height, Screen_Width, Screen_Height - _toolbar.frame.size.height - keyboardRect.size.height);
        _toolbar.frame = CGRectMake(0, keyboardRect.origin.y - _toolbar.frame.size.height, 320, _toolbar.frame.size.height);
        _titleField.frame = CGRectMake(15, 0, Screen_Width, 44);

    } completion:^(BOOL finished) {
        
    }];
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:animationDuration];
    
//    _toolbar.frame = CGRectMake(0, keyboardRect.origin.y - _toolbar.frame.size.height, 320, _toolbar.frame.size.height);
//    _toolbar.frame = CGRectMake(0, 200, 320, _toolbar.frame.size.height);

//    [UIView commitAnimations];
    
    
}
- (void)keyboardWillDisappear:(NSNotification *)notification {
    //调整两个按钮的位置
    [UIView beginAnimations:nil context:nil];
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView setAnimationDuration:animationDuration];
    
    _toolbar.frame = CGRectMake(0, Screen_Height, Screen_Width, 44);
    _titleField.frame = CGRectMake(15, 64, Screen_Height, _titleField.frame.size.height);
    _contentText.frame = CGRectMake(0, 64 + _titleField.frame.size.height, Screen_Width, Screen_Height - 64 - 44);
    [UIView commitAnimations];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

}


-(IBAction)submit:(id)sender {
    SDPost *newPost = [SDPost object];
    newPost.text = _contentText.text;
    newPost.poster = [AVUser currentUser];
    newPost.commentCount = @0;
    newPost.likeCount = @0;
    newPost.title = _titleField.text;
    NSDictionary *uploadPackage;
    if (_isUsingSystemBackground) {
        newPost.picId = _selectedPicId;
        uploadPackage = @{@"post": newPost};

    } else {
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.1f;
        int maxFileSize = 70*1024;
        
        //original
        NSData *imageData = UIImageJPEGRepresentation(_background.image, compression);
        while ([imageData length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(_background.image, compression);
        }
        AVFile *newFile = [AVFile fileWithData:imageData];
        uploadPackage = @{@"post": newPost, @"file":newFile};
        
    }
    //myHoles is not validated
    for (SDHole *eachHole in [SDUtils sharedInstance].myHoles) {
        [newPost.holes addObject:eachHole];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:DidFinishPreparingWithNewPostNotif object:uploadPackage];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    return YES;
    
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
//    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
//}
//
//- (BOOL)prefersStatusBarHidden
//{
//    return NO; //返回NO表示要显示，返回YES将hiden
//}
@end
