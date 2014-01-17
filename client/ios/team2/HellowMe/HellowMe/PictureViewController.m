//
//  PictureViewController.m
//  Draw
//
//  Created by student on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureViewController.h"
#import "UIViewHelper.h"
#import "SendMessageViewControl.h"

@interface PictureViewController (){
    UIImage *image;
}

@end

@implementation PictureViewController


@synthesize button;
@synthesize color;
@synthesize width;

@synthesize v;
@synthesize label;
@synthesize sColor;
@synthesize sWidth;

@synthesize tempLines;

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
    // Do any additional setup after loading the view from its nib.
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhang_jing_chu.png"]];
//    [v addSubview:imageView];

    

    
    
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 298, 269)];
    
    //imageView.image = [UIImage imageNamed:@"1.gif"];

    
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    
//    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"tuya.png"];    
//    
//    imageView.image = [[UIImage alloc] initWithContentsOfFile:filePath];
//    
//    imageView.userInteractionEnabled=YES;
    
    drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, 298, 269)];
    drawView.backgroundColor = [UIColor clearColor];
    
    drawView.userInteractionEnabled = YES;
    
//    drawView.backgroundColor = [UIColor whiteColor];
//    drawView.alpha =0.5;

//    [v addSubview:drawView];
    
    [v addSubview:imageView];
    [v addSubview:drawView];
    
    
    
    
    if ( (color == nil) || (width == 0) )
    {
        color = [UIColor blackColor];
        width = 2.0; 
        //[delegate passColor:color andWidth:width];
    }
    
//    label.text = [NSString stringWithFormat:@"颜色:%@ 粗细:%f",@"",];
    
    tempLines = [NSMutableArray array];
    i = 0; 
    j = 0;
}

- (void)viewDidUnload
{
    [self setButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark segment

-(void)chooseColor:(id)sender
{
    int a = [sColor selectedSegmentIndex];
    
    //NSLog(@"%@",color);
    
    switch (a)
    {
        case 0:
            color = [UIColor blackColor];
            drawView.color = color;
            
            break;
            
        case 1:
            color = [UIColor redColor];
            drawView.color = color;
            break;    
            
        case 2:
            color = [UIColor greenColor];
            drawView.color = color;
            break;
            
        case 3:
            color = [UIColor blueColor];
            drawView.color = color;
            break;
            
        case 4:
        {
//            CGFloat red=(CGFloat)random()/(CGFloat)RAND_MAX;
//            CGFloat blue=(CGFloat)random()/(CGFloat)RAND_MAX;
//            CGFloat green=(CGFloat)random()/(CGFloat)RAND_MAX;

            float x = arc4random()%256;
            float y = arc4random()%256;
            float z = arc4random()%256;
            
            NSLog(@"---%f-%f-%f",x,y,z);
            
            float red= x/255;
            float blue= y/255;
            float green= z/255;

            NSLog(@"===%f-%f-%f",red,blue,green);
            
            
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f]; 
            
            drawView.color = color;
            
            break;
        }
        
        case 5:
            //color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
            
            color = [UIColor clearColor];
            
            drawView.color = color;
            break;
            
            
        default:
            break;
    }

}


-(void)chooseWidth:(id)sender
{
    int a = [sWidth selectedSegmentIndex];
    
    //NSLog(@"%f",width);
    
    switch (a)
    {
        case 0:
            width = 2.0;
            drawView.width = width;
            break;
            
        case 1:
            width = 4.0;
            drawView.width = width;
            break;    
            
        case 2:
            width = 6.0;
            drawView.width = width;
            break;
            
        case 3:
            width = 8.0;
            drawView.width = width;
            break;
            
        case 4:
            width = 10.0;
            drawView.width = width;
            break;
        
        case 5:
            width = 12.0;
            drawView.width = width;
            break;
            
        default:
            break;
    }

}

#pragma mark 按钮

-(void)clear:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"tuya.png"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {   
        NSLog(@"======");
    }
    else 
    {
        NSLog(@"------");
    }
    
    button.imageView.image = [UIImage imageNamed:@"graffiti_cls.png"];
    
    
    
    [drawView.Lines removeAllObjects];
    [tempLines removeAllObjects];
    //[drawView.Points removeAllObjects];
    [drawView setNeedsDisplay];
}

-(void)cancel:(id)sender
{
    
    //button.imageView.image = nil;
    
    
    if (drawView.Lines.count == 0) return;
    
    if (tempLines.count == 0)
    {
        i = drawView.Lines.count;
        j = tempLines.count;
    }
    
    if ((tempLines.count + drawView.Lines.count) > i )
    {
        [tempLines removeAllObjects];
    }
    
    
    [tempLines addObject:[drawView.Lines lastObject]];
    
    [drawView.Lines removeLastObject];
    [drawView setNeedsDisplay];
    
    
    
    NSLog(@"cancel %i,%i",drawView.Lines.count,tempLines.count);
    
    
    
}

-(void)regain:(id)sender
{
    if (tempLines.count == 0) return;
    
    if ((tempLines.count + drawView.Lines.count) > i )
    {
        [tempLines removeAllObjects];
    }
    
    if (tempLines.count == 0) return;
    
    [drawView.Lines addObject:[tempLines lastObject]];
    [tempLines removeLastObject];
    
    [drawView setNeedsDisplay];
    
    
    NSLog(@"regain %i,%i",drawView.Lines.count,tempLines.count);
    
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //goToInbox
    if ([segue.identifier isEqualToString:@"saveImage"]) {
        SendMessageViewControl *messagedetail =(SendMessageViewControl *)segue.destinationViewController;
        messagedetail.tuyaImage = image;

    }
    
}


-(void)save:(id)sender
{
    image = [v currentContextImage];
   
    [self performSegueWithIdentifier:@"saveImage" sender:sender];
}


#pragma mark 背景

//设置没有背景

-(void)noneBackgruandImage:(id)sender
{
    imageView.image = nil;
}

//相册选择图片

-(void)chooseBackgruandImage:(id)sender
{


//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
//    imagePickerController.delegate = self;
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentModalViewController:imagePickerController animated:YES];
//    //[imagePickerController release];
//    
//    [imagePickerController dismissModalViewControllerAnimated:YES];

    

    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //picker.view.frame = CGRectMake(0, 0, 298, 269);
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:picker animated:YES];
    //[picker dismissModalViewControllerAnimated:YES];
    
}


-(void)UseCamera:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有或未找到相机" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentModalViewController:picker animated:YES];
    
}










-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    imageView.image = image;
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


//相机拍摄背景



@end
