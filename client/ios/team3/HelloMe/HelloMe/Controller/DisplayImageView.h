//
//  DisplayImageView.h
//  HelloMe
//
//  Created by smartphone22 on 13-12-24.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"

@interface DisplayImageView : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) MRZoomScrollView *zoomScrollView;

@end
