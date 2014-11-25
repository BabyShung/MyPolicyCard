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
#import "UserDefaultHelper.h"

#import "AppDelegate.h"
#import "MovingBehavior.h"


#define USER_PWD_VIEW_MARGIN 10
#define SCROLLVIEW_CONTENTOFF_WhenClickTextfield 180

@interface LoginViewController ()

@property (nonatomic, strong) UIDynamicAnimator *mainAnimator;

@property (nonatomic, strong) MovingBehavior *loginBtnBehavior;
@property (nonatomic, strong) MovingBehavior *userViewBehavior;

@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadControls];
}

-(void)loadControls{
    
    _containerView.center = CGPointMake(DeviceScreenWidth/2, -100);
    _loginBtn.center = CGPointMake(DeviceScreenWidth/2, DeviceScreenHeight+100);
    
    [_loginBtn primaryStyle];
    
    _containerView.layer.cornerRadius = 8;
    _userTextField.delegate = self;
    _pwdTextField.delegate = self;
    [_userTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_userTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    _pwdTextField.secureTextEntry = YES;
    
    //GESTURE - Dismiss the keyboard when tapped on the controller's view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MySingleTap:)];
    [self.view addGestureRecognizer:tap];
    
    //uidynamics
    _mainAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _loginBtnBehavior = [[MovingBehavior alloc] initWithItem:_loginBtn];
    _userViewBehavior = [[MovingBehavior alloc] initWithItem:_containerView];
}

-(void)viewDidAppear:(BOOL)animated{

    //note, not good code, should happen only once
 
    _userViewBehavior.targetPoint = CGPointMake(DeviceScreenWidth/2, 250);
    _loginBtnBehavior.targetPoint = CGPointMake(DeviceScreenWidth/2, DeviceScreenHeight - 200);
    
    //once added, it will effect
    [_mainAnimator addBehavior:_loginBtnBehavior];
    [_mainAnimator addBehavior:_userViewBehavior];
}

- (IBAction)login:(UIButton *)sender {
    [self validateAllInputs];
}

-(void)validateAllInputs{
    FormValidator *validate=[[FormValidator alloc] init];
    [validate Email:_userTextField.text andUsername:nil andPwd:_pwdTextField.text];
    if([validate isValid]){    //success
        [self.view endEditing:YES];
        
        //********************* user login *******************************
        
        [User logInWithUsername:_userTextField.text andPassword:_pwdTextField.text WithCompletion:^(NSError *error,BOOL success){
            if(success){
                //save into NSUserDefault
                [UserDefaultHelper saveUserDictionaryIntoNSUserDefault_dict:[User toDictionary] andKey:@"CurrentUser"];
                
                NSLog(@"%@",[User sharedInstance]);
                
                //transition my special window
                [GeneralControl transitionToLoggedin_Animation:YES];
               
                
            }else{
                //not success
                
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
    //_userViewBehavior.targetPoint = CGPointMake(DeviceScreenWidth/2, 190);
}

- (void)MySingleTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
