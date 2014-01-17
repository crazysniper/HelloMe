//
//  DisplayImageView.m
//  HelloMe
//
//  Created by smartphone22 on 13-12-24.
//  Copyright (c) 2013年 ldns. All rights reserved.
//
#import "MBProgressHUD.h"
#import "DisplayImageView.h"

@interface DisplayImageView ()

@end

@implementation DisplayImageView

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
    NSLog(@"DisplayImageView");
    //左边navigationItems back 设置
    [self.navigationItem setHidesBackButton:YES];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 17.0f, 25.0f);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    
    float screenHeight =[UIScreen mainScreen].bounds.size.height;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
//    imageView.frame = CGRectMake(screenWidth/2-image.size.width/2, screenHeight/2-image.size.height/2, image.size.width, image.size.height);
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, screenWidth, screenHeight)];
    NSLog(@"%f======%f",screenWidth, screenHeight);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
   // [_scrollView setContentSize:CGSizeMake(screenWidth,screenHeight)];
    
    _zoomScrollView = [[MRZoomScrollView alloc]init];
    _zoomScrollView.imageView.image = _image;
    _zoomScrollView.imageView.frame = CGRectMake(((screenWidth/2)-(_image.size.width/2)), (screenHeight/2-_image.size.height/2+10), _image.size.width, _image.size.height);
    [self.scrollView addSubview:_zoomScrollView];
    
    // 右滑返回
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipped:)];
    [_scrollView addGestureRecognizer:swipeGestureRecognizer];

    // tap 保存图片
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [_scrollView addGestureRecognizer:tap];
    // 共通
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didSwipped:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        //NSLog(@"UISwipeGestureRecognizerDirectionRight");
        NSLog(@"====right");
        [self backAction];
    }
}
-(void) didTap:(UILongPressGestureRecognizer *)gestureRecognizer{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"放弃"
                                  destructiveButtonTitle:@"保存图片"
                                  otherButtonTitles:@"放弃并返回",nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"0000000000000");
        UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil);
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] init] ;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"图片保存成功";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        NSLog(@"save");
        
    }else if(buttonIndex == 1){
        NSLog(@"actionSheetCancel");
        [self backAction];
        
    }else if(buttonIndex == 2){
        NSLog(@"2222222222222");
    }
}

@end
