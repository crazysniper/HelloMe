//
//  PictureViewController.h
//  Draw
//
//  Created by student on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DrawView.h"



@interface PictureViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    
    UIColor *color;
    float width;
    
    DrawView *drawView;
    
    NSMutableArray *tempLines;
    
    int i;
    int j;
    
    
    UIImageView *imageView;
    
}


@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong ,nonatomic) UIColor *color;
@property float width;


@property (weak, nonatomic) IBOutlet UIView *v;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sColor;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sWidth;

@property (strong, nonatomic) NSMutableArray *tempLines;

-(IBAction)chooseColor:(id)sender;
-(IBAction)chooseWidth:(id)sender;


-(IBAction)clear:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)regain:(id)sender;
-(IBAction)save:(id)sender;

-(IBAction)noneBackgruandImage:(id)sender;
-(IBAction)chooseBackgruandImage:(id)sender;
-(IBAction)UseCamera:(id)sender;

@end
