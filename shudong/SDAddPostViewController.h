//
//  SDAddPostViewController.h
//  shudong
//
//  Created by Eric Tao on 4/28/14.
//  Copyright (c) 2014 1xiustudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SDChooseHoleTableViewController.h"
#import "SDPost.h"
#import "SDHole.h"
#import "SDUtils.h"

@protocol AddPostDelegate

- (void)didFinishPreparingNewPostToUpload:(SDPost *)newPost;

@end

@interface SDAddPostViewController : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, ChooseHoleDelegate>

@end
