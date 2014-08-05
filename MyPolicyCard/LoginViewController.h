//
//  LoginViewController.h
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate>


@property (strong, nonatomic) UIView *sendButtonView;

@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end
