//
//  AvatarBrowser.m
//  image
//
//  Created by 陳威 on 13-12-13.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "AvatarBrowser.h"

static CGRect oldframe;
static UIView *backgroundView;
static UIWindow *window;
static UIImageView *imageView;
static UIImage *images;
@interface AvatarBrowser(){
    
}
@end

@implementation AvatarBrowser

+(void)showImage:(UIImageView*)avatarImageView{
    images = avatarImageView.image;
    window = [UIApplication sharedApplication].keyWindow;

    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    NSLog(@"%f++++++++++++%f",avatarImageView.bounds.size.width,avatarImageView.bounds.size.height);
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 1;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = images;
    imageView.tag = 1;
    NSLog(@"%f------------%f",imageView.bounds.size.height,imageView.bounds.size.height);
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-images.size.height*[UIScreen mainScreen].bounds.size.width/images.size.width)/2, [UIScreen mainScreen].bounds.size.width, images.size.height*[UIScreen mainScreen].bounds.size.width/images.size.width);
        //backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}
+ (void)hideImage:(UITapGestureRecognizer *)tap{
    backgroundView=tap.view;
    imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
// 显示图片
+ (void)displayImage:(UIImage *)image{
//    获取应用程序的主窗口对象
    window = [UIApplication sharedApplication].keyWindow;
//    设置图片背景
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 1;                   // 背景透明度设置
    [backgroundView setUserInteractionEnabled:YES];
    
//    设置图片显示位置
    imageView = [[UIImageView alloc]initWithImage:image highlightedImage:nil];
    float screenHeight =[UIScreen mainScreen].bounds.size.height;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    imageView.frame = CGRectMake(screenWidth/2-image.size.width/2, screenHeight/2-image.size.height/2, image.size.width, image.size.height);
    imageView.userInteractionEnabled = YES;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
//    tap 关闭图片显示
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
//    图片缩放 TODO
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaGesture:)];
    [imageView addGestureRecognizer:pinch];
//   长按保存图片
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
    [imageView addGestureRecognizer:longPress];
}

//-(void)scaGesture:(id)sender {
//    
//    NSLog(@"scaGesture");
//    [self.viewbringSubviewToFront:[(UIPinchGestureRecognizer*)senderview]];
//    //当手指离开屏幕时,将lastscale设置为1.0
//    if([(UIPinchGestureRecognizer*)senderstate] == UIGestureRecognizerStateEnded) {
//        lastScale = 1.0;
//        return;
//    }
    
//    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)senderscale]);
//    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)senderview].transform;
//    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//    [[(UIPinchGestureRecognizer*)senderview]setTransform:newTransform];
//    lastScale = [(UIPinchGestureRecognizer*)senderscale];
//}

+ (void) scaGesture:(UIPinchGestureRecognizer*)gestureRecognizer{
    
    NSLog(@"=============scaGesture");
    
    
}
+ (void) saveImage:(UILongPressGestureRecognizer *)gestureRecognizer{
    NSLog(@"=============LongPressd");
    // 弹出打开相机、相册选择菜单
//    UIActionSheet *photoActionSheet = [[UIActionSheet alloc]initWithTitle:nil
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"取消"
//                                                   destructiveButtonTitle:@"保存图片"
//                                                        otherButtonTitles:@"拍照上传", nil];
//    photoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    //[photoActionSheet showInView:self.view];

}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]];
//}

@end
