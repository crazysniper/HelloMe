//
//  TheamViewController.m
//  HelloMe
//
//  Created by 陳威 on 13-12-17.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "TheamViewController.h"
#import "ThemeManager.h"
@interface TheamViewController ()

@end

@implementation TheamViewController

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
    [self regitserAsObserver];
    [self configureViews];
    self.title = @"更换主题";
    [self.navigationItem setHidesBackButton:YES];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 17.0f, 25.0f);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	// Do any additional setup after loading the view, typically from a nib.
    for ( int i=0; i<[[self themes] count]; i++ )
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i<3) {
            button.frame = CGRectMake(i*100+7, 70, 100, 100);
        }else{
            button.frame = CGRectMake((i-3)*100+7, 70+110, 100, 100);

        }
        button.tag = i;
        
        NSString *image = [NSString stringWithFormat: @"skin_set_%@",
                           [[self themes] objectAtIndex:i]];
        
        [button setImage:IMAGE(image)
                forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(selectThemeAtIndex:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)regitserAsObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(configureViews)
                   name:ThemeDidChangeNotification
                 object:nil];
}
- (void)configureViews
{
    
    self.navigationController.navigationBar.barTintColor = [[ThemeManager sharedInstance]colorWithColorName];
}



- (NSArray *)themes
{
    return @[kThemeRed, kThemeBlue, kThemePray,kThemeGreen,kThemePurple,kThemePink];
}
- (void)selectThemeAtIndex:(UIButton *)sender
{
    [[ThemeManager sharedInstance]
     setTheme:[[self themes] objectAtIndex:sender.tag]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
