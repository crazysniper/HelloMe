//
//  CustomUIAlertView.h
//  DIYdemo
//
//  Created by Smartphone24 on 13-9-10.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^alertViewButtonClickIndex)(int buttonIndex);

@interface CustomUIAlertView : UIAlertView<UIAlertViewDelegate>{
    alertViewButtonClickIndex _buttonClickBlock;
}
@property (nonatomic,strong)alertViewButtonClickIndex buttonClickBlock;

-(void) showWithButtonClickedBlock:(alertViewButtonClickIndex)buttonClickedBlock;

@end
