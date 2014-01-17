//
//  AvatarBrowser.h
//  image
//
//  Created by 陳威 on 13-12-13.
//  Copyright (c) 2013年 ldns. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AvatarBrowser : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate>
+ (void)showImage:(UIImageView *)avatarImageView;
+ (void)displayImage:(UIImage *)image;
+ (void) scaGesture:(UIPinchGestureRecognizer*)gestureRecognizer;
+ (void) saveImage:(UILongPressGestureRecognizer *)gestureRecognizer;
@end
