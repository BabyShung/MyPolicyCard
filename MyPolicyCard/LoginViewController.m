//
//  LoginViewController.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "LoginViewController.h"

#import "UIButton+Bootstrap.h"
#import "GeneralControl.h"
#import "User.h"
#import "FormValidator.h"
#import "NSUserDefaultControls.h"
#import "UIButton+ResponsiveInteraction.h"

#import "HaoWindow.h"
#import "AppDelegate.h"
#import "MovingBehavior.h"

#define USER_PWD_VIEW_MARGIN 10
#define SCROLLVIEW_CONTENTOFF_WhenClickTextfield 180

@interface LoginViewController ()

@property (nonatomic, strong) UIDynamicAnimator *mainAnimator;

@property (nonatomic, strong) MovingBehavior *movingBehavior;

@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadControls];
}

-(void)loadControls{
    _mainAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    _userView.center = CGPointMake(DeviceScreenWidth/2, -100);
    _pwdView.center = CGPointMake(DeviceScreenWidth/2, -100 + USER_PWD_VIEW_MARGIN);
    _loginBtn.center = CGPointMake(DeviceScreenWidth/2, DeviceScreenHeight+100);
    
    [_loginBtn primaryStyle];
    [_loginBtn activeResponsiveInteraction];
    [_loginBtn setGlobalResponsiveInteractionWithView:self.view];
    
    //animate label
    [_animatedLabel animateWithWords:@[@"PolicyApp",@"Like it?"] forDuration:3.0f];
    
    _logoView.layer.cornerRadius = 80.0f;
    _userView.layer.cornerRadius = 8;
    _pwdView.layer.cornerRadius = 8;
    _userTextField.delegate = self;
    _pwdTextField.delegate = self;
    [_userTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_userTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    _pwdTextField.secureTextEntry = YES;
    
    //GESTURE - Dismiss the keyboard when tapped on the controller's view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MySingleTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidAppear:(BOOL)animated{
    if (!_movingBehavior) {
        _movingBehavior = [[MovingBehavior alloc] initWithItem:_loginBtn];
    }
    MovingBehavior *userMB = [[MovingBehavior alloc] initWithItem:_userView];
    MovingBehavior *pwdMB = [[MovingBehavior alloc] initWithItem:_pwdView];
    
    userMB.targetPoint = CGPointMake(DeviceScreenWidth/2, 200);
    pwdMB.targetPoint = CGPointMake(DeviceScreenWidth/2, 200 + USER_PWD_VIEW_MARGIN + CGRectGetHeight(_pwdView.frame));
    
    _movingBehavior.targetPoint = CGPointMake(DeviceScreenWidth/2, DeviceScreenHeight - 200);
    
    //once added, it will effect
    [_mainAnimator addBehavior:_movingBehavior];
    [_mainAnimator addBehavior:userMB];
    [_mainAnimator addBehavior:pwdMB];
}

- (IBAction)login:(UIButton *)sender {
    [self validateAllInputs];
}

-(void)validateAllInputs{
    FormValidator *validate=[[FormValidator alloc] init];
    [validate Email:_userTextField.text andUsername:nil andPwd:_pwdTextField.text];
    if([validate isValid]){    //success
        [self.view endEditing:YES];
        [_notiWindow showWindow];
        
        //********************* user login *******************************
        
        [User logInWithUsername:_userTextField.text andPassword:_pwdTextField.text WithCompletion:^(NSError *error,BOOL success){
            if(success){
                //save into NSUserDefault
                [NSUserDefaultControls saveUserDictionaryIntoNSUserDefault_dict:[User toDictionary] andKey:@"CurrentUser"];
                
                NSLog(@"%@",[User sharedInstance]);
                
                //transition my special window
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [GeneralControl transitionToShowPlan:self.storyboard withAnimation:YES];
                    
                    [_notiWindow hideWindow];
                });
                
            }else{
                //not success
                [_notiWindow hideWindow];
                
                [GeneralControl showError:error withTextField:_pwdTextField];
            }
        }];
    }else{  //validator failure
        NSString *errorString = [[validate errorMsg] componentsJoinedByString: @"\n"];
        [GeneralControl showErrorMsg:errorString withTextField:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField == _userTextField){
        [_pwdTextField becomeFirstResponder];
    }else if(theTextField == _pwdTextField){
        [self validateAllInputs];
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (void)MySingleTap:(UITapGestureRecognizer *)sender{
    
}

-(notifyWindow*)notiWindow{
    if(!_notiWindow){
        _notiWindow = [[notifyWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _notiWindow;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
