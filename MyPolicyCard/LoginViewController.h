//
//  LoginViewController.h
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

@interface LoginViewController : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
