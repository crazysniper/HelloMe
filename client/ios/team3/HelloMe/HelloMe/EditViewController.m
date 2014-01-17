//
//  EditViewController.m
//  HelloMe
//
//  Created by Eva.yuanzi on 2013/12/16.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendmail:(id)sender {
}

- (IBAction)selecttime:(id)sender {
    
    UIDatePicker *selected = [[UIDatePicker alloc]init];
    
    
    NSTimeZone *timeZone3 = [NSTimeZone timeZoneForSecondsFromGMT:3600*8];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setTimeZone:timeZone3];
    [formatter3 setDateFormat:@"G YYYY-MM-dd EEEE aa HH:mm:ss Z"];
    NSString *dateString = [formatter3 stringFromDate:selected];
    
    NSString *message = [[NSString alloc]initWithFormat:@"%@",dateString];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Yes,I did" otherButtonTitles: nil];
    [alert show];
   
   
}
@end
