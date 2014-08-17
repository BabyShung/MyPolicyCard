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
#import "GeneralControl.h"
#import "User.h"
#import "FormValidator.h"
#import "NSUserDefaultControls.h"
#import "UIButton+ResponsiveInteraction.h"

#import "notifyWindow.h"
#import "HaoWindow.h"
#import "AppDelegate.h"

#import <Parse/Parse.h>

#define SCROLLVIEW_CONTENTOFF_WhenClickTextfield 180

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet AnimateLabel *animatedLabel;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (nonatomic,strong) notifyWindow *notiWindow;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    //[self checkUserInNSUserDefaultAndPerformLogin];
    [self loadControls];
}




- (IBAction)login:(UIButton *)sender {
    [self validateAllInputs];
}

-(void)validateAllInputs{
    FormValidator *validate=[[FormValidator alloc] init];
    [validate Email:self.userTextField.text andUsername:nil andPwd:self.pwdTextField.text];
    if([validate isValid]){    //success
        //[Flurry logEvent:@"Read_TO_Login"];
        
        [self.view endEditing:YES];
        [self.notiWindow showWindow];
        
        //********************* user login *******************************
        
        [User logInWithUsername:self.userTextField.text andPassword:self.pwdTextField.text WithCompletion:^(NSError *error,BOOL success){
            if(success){
                //save into NSUserDefault
                [NSUserDefaultControls saveUserDictionaryIntoNSUserDefault_dict:[User toDictionary] andKey:@"CurrentUser"];
                
                NSLog(@"%@",[User sharedInstance]);
                
                //[Flurry logEvent:@"Login_Succeed"];
                
                //transition
                //[GeneralControl transitionToVC:self withToVCStoryboardId:@"CardNav" withDuration:0.5];
                
                //my special window
                [GeneralControl transitionToShowPlan:self.storyboard withAnimation:YES];

                
                [self.notiWindow hideWindow];
            }else{
                //not success
                [self.notiWindow hideWindow];
                
                [GeneralControl showError:error withTextField:self.pwdTextField];
            }
        }];
        
        
    }else{  //validator failure
        NSString *errorString = [[validate errorMsg] componentsJoinedByString: @"\n"];
        [GeneralControl showErrorMsg:errorString withTextField:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField == self.userTextField){
        [self.pwdTextField becomeFirstResponder];
    }else if(theTextField == self.pwdTextField){
        [self validateAllInputs];
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self goUpAnimation];
}

- (void)MySingleTap:(UITapGestureRecognizer *)sender{
    [self goDownAnimation];
}

-(void)goUpAnimation{
    if(self.bgScrollView.bounds.origin.y != SCROLLVIEW_CONTENTOFF_WhenClickTextfield){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.bgScrollView setContentOffset:CGPointMake(0,SCROLLVIEW_CONTENTOFF_WhenClickTextfield) animated:YES];
        });
    }
}

-(void)goDownAnimation{
    if(self.bgScrollView.bounds.origin.y != 0){
        [self.bgScrollView setContentOffset:CGPointMake(0,0) animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
        });
    }
}

-(notifyWindow*)notiWindow{
    if(!_notiWindow){
        _notiWindow = [[notifyWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _notiWindow;
}

-(void)loadControls{
    [self.loginBtn primaryStyle];
    // Active effect

    [self.loginBtn activeResponsiveInteraction];
    [self.loginBtn setGlobalResponsiveInteractionWithView:self.view];
    
    //animate label
    [self.animatedLabel animateWithWords:@[@"PolicyApp",@"Like it?"] forDuration:3.0f];
    
    self.logoView.layer.cornerRadius = 80.0f;
    
    self.userView.layer.cornerRadius = 8;
    self.pwdView.layer.cornerRadius = 8;
    
    self.userTextField.delegate = self;
    self.pwdTextField.delegate = self;
    
    [self.userTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.pwdTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.userTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.pwdTextField.secureTextEntry = YES;
    
    //GESTURE - Dismiss the keyboard when tapped on the controller's view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MySingleTap:)];
    [self.view addGestureRecognizer:tap];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
