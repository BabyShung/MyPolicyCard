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
#import "UIResponder+KeyboardCache.h"
#import "GeneralControl.h"
#import "User.h"
#import "FormValidator.h"
#import "NSUserDefaultControls.h"
#import "UIButton+ResponsiveInteraction.h"
#import "UIColor+flat.h"
#import "LoadingAnimation.h"

#import <Parse/Parse.h>

#define SCROLLVIEW_CONTENTOFF_WhenClickTextfield 180

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet AnimateLabel *animatedLabel;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (nonatomic,strong) LoadingAnimation *loadingImage;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //cache keyboard
    [UIResponder cacheKeyboard];
    
    //[self checkAndStartLoadingAnimation];
    
    [self checkUserInNSUserDefaultAndPerformLogin];
    
//    NSError *err = [User signUpWithEmail:@"alan.wang@afis-benefits.com" andPassword:@"333333" andUsername:@"Alan.Wang" andAvatar:nil];
//    if (!err)
//        NSLog(@"sign up success!!@@!!");
//    else
//        NSLog(@"sign up failed");

    
//    NSError *err = [User logInWithUsername:@"babyshung8@gmail.com" andPassword:@"123123"];
//    if (!err)
//        NSLog(@"login success");
//    else
//        NSLog(@"login failed");

    
//    [PFUser logInWithUsernameInBackground:@"1@1.com" password:@"123123"
//                                    block:^(PFUser *user, NSError *error) {
//                                        if (user) {
//                                            // Do stuff after successful login.
//                                            NSLog(@"login success!!");
//                                            
//                                        } else {
//                                            // The login failed. Check error to see why.
//                                            NSLog(@"login failed!!");
//                                        }
//                                    }];
    

    //NSLog(@"````%@",[PFUser currentUser]);

//    PFQuery *query2 = [PFQuery queryWithClassName:@"Policy"];
//    [query2 whereKey:@"policyNum" equalTo:@"5723634"];
//    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully22 retrieved %d scores.", objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"%@", object.objectId);
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];

    
//    //first, query to get all the plans based on the userId
//    PFQuery *plansQuery = [PFQuery queryWithClassName:@"UserPolicy"];
//   [plansQuery whereKey:@"UserObjectID" equalTo:[PFUser currentUser].objectId];
//    [plansQuery orderByDescending:@"createdAt"];
//    
//    //second, when you get a list of policyId, use these IDs to get all the policies
//    PFQuery *policyQuery = [PFQuery queryWithClassName:@"Policy"];
//    [policyQuery whereKey:@"objectId" matchesKey:@"PolicyObjectID" inQuery:plansQuery];
//    [policyQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully1111 retrieved %d scores.", results.count);
//            // Do something with the found objects
//            for (PFObject *object in results) {
//                NSLog(@"%@", object[@"policyNum"]);
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
    
    
    
//    PFQuery *query = [PFQuery queryWithClassName:@"UserPolicy"];
//    [query whereKey:@"UserObjectID" equalTo:[PFUser currentUser].objectId];
//    [query orderByDescending:@"createdAt"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully3333 retrieved %d scores.", objects.count);
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"%@", object.objectId);
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
    
//    PFQuery *nonBlockedUserInnerQuery = [PFUser query];
//    [nonBlockedUserInnerQuery whereKey:@"blocked" equalTo:@NO];
//    
//    PFQuery *postsByNonBlockedUsersQuery = [PFQuery queryWithClassName:@"Post"];
//    [postsByNonBlockedUsersQuery whereKey:@"user" matchesQuery:nonBlockedUserInnerQuery];
//    [postsByNonBlockedUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
//        // results contains players with lots of wins or only a few wins.
//    }];
//    
//    PFQuery *lotsOfWins = [PFQuery queryWithClassName:@"Player"];
//    [lotsOfWins whereKey:@"wins" greaterThan:@150];
//    
//    PFQuery *fewWins = [PFQuery queryWithClassName:@"Player"];
//    [fewWins whereKey:@"wins" lessThan:@5];
//    PFQuery *query = [PFQuery orQueryWithSubqueries:@[fewWins,lotsOfWins]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
//        // results contains players with lots of wins or only a few wins.
//    }];

}

-(void)checkUserInNSUserDefaultAndPerformLogin{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"];
        //from dictionary to User instance
        [User fromDictionaryToUser:dict];
        
        [GeneralControl transitionToVC:self withToVCStoryboardId:@"CardNav" withDuration:0.8];
        
        NSLog(@"******************  Second Login: %@",[User sharedInstance]);
        
    }else{
        [self loadControls];
    }
}

- (IBAction)login:(UIButton *)sender {
    [self validateAllInputs];
}

-(void)validateAllInputs{
    FormValidator *validate=[[FormValidator alloc] init];
    [validate Email:self.userTextField.text andUsername:nil andPwd:self.pwdTextField.text];
    if([validate isValid]){    //success
        //[Flurry logEvent:@"Read_TO_Login"];
        
        self.loginBtn.enabled = NO;
        //self.signUpBtn.enabled = NO;
        //self.skipBtn.enabled = NO;
        [self.view endEditing:YES];
        [self checkAndStartLoadingAnimation];
        
        //********************* user login *******************************
        
        [User logInWithUsername:self.userTextField.text andPassword:self.pwdTextField.text WithCompletion:^(NSError *error,BOOL success){
            if(success){
                //save into NSUserDefault
                [NSUserDefaultControls saveUserDictionaryIntoNSUserDefault_dict:[User toDictionary] andKey:@"CurrentUser"];
                
                NSLog(@"%@",[User sharedInstance]);
                
                //[Flurry logEvent:@"Login_Succeed"];
                
                //transition
                [GeneralControl transitionToVC:self withToVCStoryboardId:@"CardNav" withDuration:0.5];
            }else{
                //not success
                self.loginBtn.enabled = YES;
                //self.signUpBtn.enabled = YES;
                //self.skipBtn.enabled = YES;
                [self.loadingImage stopAnimating];
                
                [GeneralControl showError:error withTextField:self.pwdTextField];
            }
        }];
        
        
    }else{  //validator failure
        NSString *errorString = [[validate errorMsg] componentsJoinedByString: @"\n"];
        [GeneralControl showErrorMsg:errorString withTextField:nil];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
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
    NSLog(@"tapped.....");
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

-(void)checkAndStartLoadingAnimation{
    //start animation
    if(!self.loadingImage){
        self.loadingImage = [[LoadingAnimation alloc] initWithStyle:RTSpinKitViewStylePlane color:[UIColor flatAlizarinColor]];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        self.loadingImage.center = CGPointMake(CGRectGetMidX(screenBounds), iPhone5? screenBounds.size.height*0.5:screenBounds.size.height*0.75);
        [self.view addSubview:self.loadingImage];
    }
    [self.loadingImage startAnimating];
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

@end
