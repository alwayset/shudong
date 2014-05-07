//
//  Common.h
//  RenRenSns
//
//  Created by Chengliang Li on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 screen width
 screen height  适配使用
 */
#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen] bounds].size.height

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define AppLog(fmt,...) [(AppDelegate *)[[UIApplication sharedApplication] delegate] appLog:fmt,##__VA_ARGS__]
