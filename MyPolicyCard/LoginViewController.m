//
//  LoginViewController.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "LoginViewController.h"
#import "AnimateLabel.h"
#import "UIButton+Bootstrap.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet AnimateLabel *animatedLabel;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.loginBtn primaryStyle];
    
    //animate label
    [self.animatedLabel animateWithWords:@[@"PolicyApp",@"Like it?"] forDuration:3.0f];
    
    self.logoView.layer.cornerRadius = 80.0f;
    
    //GESTURE - Dismiss the keyboard when tapped on the controller's view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    self.userView.layer.cornerRadius = 8;
    self.pwdView.layer.cornerRadius = 8;
    
    [self.userTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
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
