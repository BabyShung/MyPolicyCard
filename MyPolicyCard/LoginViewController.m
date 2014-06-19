//
//  LoginViewController.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "LoginViewController.h"

#import "UIButton+Bootstrap.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.loginBtn primaryStyle];
    
    
    //GESTURE - Dismiss the keyboard when tapped on the controller's view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
}


- (IBAction)login:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Miscellaneous


-(void) dismissKeyboard
{
    [self.userTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}


@end
