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
#import <MBProgressHUD/MBProgressHUD.h>
#import <AVOSCloud/AVLocationManager.h>
#import <AVOSCloud/AVOSCloud.h>
#import <MapKit/MapKit.h>
#import "SDSignupViewController.h"


@interface SDAddPostViewController () {
    
    
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (strong, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) NSMutableArray *myHoles;


@property (nonatomic, strong) AVObject *targetTerr;

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
    

    
    _toolbar.frame = CGRectMake(0, Screen_Height, 320, 44);
//    _titleField.layer.borderWidth = 2.0f;
//    _titleField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardDidChangeFrameNotification object:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _myHoles =  [NSMutableArray arrayWithArray:[SDUtils sharedInstance].myHoles];
    
    self.contentText.layer.cornerRadius = 4.0f;
    self.contentText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentText.layer.borderWidth = 1.0f;
    [self.contentText becomeFirstResponder];
    //self.contentText.frame = CGRectMake(14, 35, 292, Screen_Height - 35 - 216 - 40);

}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *registered = [AVUser currentUser][@"registered"];

    if (registered.boolValue) {
        [self setPostToAnnoymous:NO];
    } else {
        [self setPostToAnnoymous:YES];
        [self.displayNameButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self loadMostUpdatedTerr];
    
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
//- (IBAction)changeSystemBgRandomly:(id)sender {
//    
//    NSInteger pictureId = (rand() % 30);
//    if ([[NSNumber numberWithInt:pictureId] isEqualToNumber:_selectedPicId]) {
//        [self changeSystemBgRandomly:nil];
//    }
//    
//    _selectedPicId = [NSNumber numberWithInt:pictureId];
//    _background.image = [UIImage imageNamed:[_selectedPicId.stringValue stringByAppendingString:@".jpg"]];
//    
//}

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
- (IBAction)signup:(id)sender {
    SDSignupViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signup"];
    [self.navigationController pushViewController:vc animated:YES];
}
//
//#pragma mark UIImagePicker Delegate methods
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    _background.image = pickedImage;
//    _isUsingSystemBackground = NO;
//}
//
//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [self dismissViewControllerAnimated:NO completion:nil];
//}


//#pragma mark UIActionSheet delegate methods 
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (actionSheet.tag == 1) {
//        switch (buttonIndex) {
//            case 0: { //from library
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.allowsEditing = YES;
//                picker.delegate = self;
//                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                [self presentViewController:picker animated:YES completion:nil];
//                break;
//            }
//            case 1: {
//                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//                picker.allowsEditing = YES;
//                picker.delegate = self;
//                BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断照相机是否可用（是否有摄像头）
//                if (hasCamera) {
//                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                    [self presentViewController:picker animated:YES completion:nil];
//
//                } else {
//                }
//
//            }
//            default:
//                break;
//        }
//    }
//}

- (void)keyboardWillAppear:(NSNotification *)notification {
    //调整两个按钮的位置
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        _contentText.frame = CGRectMake(14, 107, 292, keyboardRect.origin.y - 33 - 107);
        _terrButton.frame = CGRectMake(26, keyboardRect.origin.y-33, 280, 33);
        //_toolbar.frame = CGRectMake(0, keyboardRect.origin.y - _toolbar.frame.size.height, 320, _toolbar.frame.size.height);
        //_titleField.frame = CGRectMake(15, 0, Screen_Width, 44);

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
    
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];

    
    [UIView beginAnimations:nil context:nil];
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [animationDurationValue getValue:&animationDuration];
    
    
    [UIView setAnimationDuration:animationDuration];
    //_toolbar.frame = CGRectMake(0, Screen_Height, Screen_Width, 44);
    //_titleField.frame = CGRectMake(15, 64, Screen_Height, _titleField.frame.size.height);
    _contentText.frame = CGRectMake(14, 107, 292, keyboardRect.origin.y - 33 - 107);
    _terrButton.frame = CGRectMake(26, keyboardRect.origin.y-33, 280, 33);
    [UIView commitAnimations];

}


-(IBAction)submit:(id)sender {
    SDPost *newPost = [SDPost object];
    
    if ([AVUser currentUser]) {
        newPost.poster = [AVUser currentUser];
        newPost.displayName = [AVUser currentUser][@"displayName"];
    }
    newPost.text = _contentText.text;
    newPost.commentCount = @0;
    newPost.likeCount = @0;
    newPost.score =@0;
    if (self.targetTerr) {
        newPost.terr = self.targetTerr;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"发布中";
    
    [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:NO];
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [SDUtils showErrALertWithText:@"发送失败"];
        }
    }];
    
    //    if (_isUsingSystemBackground) {
////        newPost.picId = _selectedPicId;
//        uploadPackage = @{@"post": newPost};
//
//    } else {
//        CGFloat compression = 0.9f;
//        CGFloat maxCompression = 0.1f;
//        int maxFileSize = 70*1024;
//        
//        //original
//        NSData *imageData = UIImageJPEGRepresentation(_background.image, compression);
//        while ([imageData length] > maxFileSize && compression > maxCompression)
//        {
//            compression -= 0.1;
//            imageData = UIImageJPEGRepresentation(_background.image, compression);
//        }
//        AVFile *newFile = [AVFile fileWithData:imageData];
//        uploadPackage = @{@"post": newPost, @"file":newFile};
//        
//    }
    //myHoles is not validated
//    for (SDHole *eachHole in [SDUtils sharedInstance].myHoles) {
//        [newPost.holes addObject:eachHole];
//    }

//    [[NSNotificationCenter defaultCenter] postNotificationName:DidFinishPostingNotif object:nil];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text isEqualToString:@"\n"]) {
//        
//        [textView resignFirstResponder];
//        return NO;
//    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    return YES;
    
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}



- (void)loadMostUpdatedTerr {
    AVQuery *query = [AVQuery queryWithClassName:@"Terr"];
    [query orderByDescending:@"updatedAt"];
    
    
    if ([AVLocationManager sharedInstance].lastLocation) {
        [query whereKey:@"location" nearGeoPoint:[AVGeoPoint geoPointWithLatitude:[AVLocationManager sharedInstance].lastLocation.coordinate.latitude longitude:[AVLocationManager sharedInstance].lastLocation.coordinate.longitude] withinKilometers:500];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (!error) {
                self.targetTerr = object;
                [self.terrButton setTitle:[NSString stringWithFormat:@"当前领地:%@",object[@"name"]] forState:UIControlStateNormal];
            } else if (error.code == kAVErrorObjectNotFound) {
                [self.terrButton setTitle:@"创建新的领地" forState:UIControlStateNormal];
            }
        }];
    } else {
        [[AVLocationManager sharedInstance] updateWithBlock:^(AVGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                [query whereKey:@"location" nearGeoPoint:[AVGeoPoint geoPointWithLatitude:[AVLocationManager sharedInstance].lastLocation.coordinate.latitude longitude:[AVLocationManager sharedInstance].lastLocation.coordinate.longitude] withinKilometers:500];
                [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                    if (!error) {
                        self.targetTerr = object;
                        [self.terrButton setTitle:[NSString stringWithFormat:@"当前领地:%@",object[@"name"]] forState:UIControlStateNormal];
                    } else if (error.code == kAVErrorObjectNotFound) {
                        [self.terrButton setTitle:@"创建新的领地" forState:UIControlStateNormal];
                    }
                }];
            }
        }];
    }
    
    
}

- (void)setPostToAnnoymous:(BOOL)boo {
    //if (boo) {
        [UIView animateWithDuration:0.65 animations:^{
            self.displayNameButton.backgroundColor = [UIColor darkGrayColor];
            [self.displayNameButton setTitle:@"匿名发布" forState:UIControlStateNormal];
            self.displayNameButton.titleLabel.textColor = [UIColor lightTextColor];
        }];
//    } else {
//        [UIView animateWithDuration:0.65 animations:^{
//            self.displayNameButton.backgroundColor = [UIColor whiteColor];
//            [self.displayNameButton setTitle:[AVUser currentUser][@"displayName"] forState:UIControlStateNormal];
//            self.displayNameButton.titleLabel.textColor = [UIColor darkGrayColor];
//        }];
//    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //do something;
    }
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
