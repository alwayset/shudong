//
//  SDAddPostViewController.m
//  shudong
//
//  Created by Eric Tao on 4/28/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import "SDAddPostViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SDPost.h"
#import "SDHole.h"
#import "SDUtils.h"
@interface SDAddPostViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) NSMutableArray *myHoles;

@property BOOL isUsingSystemBackground;
@property (strong, nonatomic) NSNumber *selectedPicId;


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillApeear) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear) name:UIKeyboardWillHideNotification object:nil];
    _myHoles =  [NSMutableArray arrayWithArray:[SDUtils sharedInstance].myHoles];
    _isUsingSystemBackground = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_contentText becomeFirstResponder];
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
- (IBAction)post:(id)sender {
    SDPost *newPost = [SDPost object];
    newPost.text = _contentText.text;
    newPost.poster = [AVUser currentUser];
    newPost.commentCount = @0;
    newPost.likeCount = @0;
    if (_isUsingSystemBackground) {
        newPost.picId = _selectedPicId;
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
        newPost.image = newFile;
        
    }
    
    
}

#pragma mark UIImagePicker Delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _background.image = pickedImage;
    _isUsingSystemBackground = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
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
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
                break;
            }
            case 1: {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.allowsEditing = YES;
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

- (void)keyboardWillApeear {
    //调整两个按钮的位置
    
}
- (void)keyboardWillDisappear {
    //调整两个按钮的位置
    
}

@end
