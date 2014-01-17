//
//  MessageDetailViewController.h
//  HellowMe
//
//  Created by System Administrator on 12/20/13.
//  Copyright (c) 2013 Smartphone18. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UIViewController
@property(strong,nonatomic) NSString  *mailId;
@property (weak, nonatomic) IBOutlet UILabel *setTime;
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UITextView *messageContent;
@property (strong, nonatomic) IBOutlet UIView *detailview;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
