//
//  SDAddPostViewController.h
//  shudong
//
//  Created by Eric Tao on 4/28/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SDPost.h"
#import "SDHole.h"
#import "SDUtils.h"



@interface SDAddPostViewController : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *toolbar;

@end
