//
//  GeneralControl.m
//  EdibleCameraApp
//
//  Created by Hao Zheng on 7/15/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "GeneralControl.h"


#import "AppDelegate.h"

#import "TLAlertView.h"

@implementation GeneralControl

+(void)showError:(NSError *)error withTextField:(UITextField *)textfield{
    
    NSString *errorMsg;
    
    if(error.code == 101){
        errorMsg = AMLocalizedString(@"ERROR_LOGIN", nil);
    }else{
        //general error
        errorMsg = [error localizedDescription];
    }
    [self showAlertView:errorMsg withTextField:textfield];
}

+(void)showErrorMsg:(NSString *)msg withTextField:(UITextField *)textfield{
    [self showAlertView:msg withTextField:textfield];
}

+(void)showAlertView:(NSString *)msg withTextField:(UITextField *)textfield{
    
    TLAlertView *alert = [[TLAlertView alloc] initWithTitle:AMLocalizedString(@"OOPS", nil) message:msg buttonTitle:AMLocalizedString(@"Cancel", nil) handler:^(TLAlertView *alertView) {
        if(textfield){
            textfield.text = @"";
            [textfield becomeFirstResponder];
        }
    }];
    [alert show];
}

+(void)transitionToLoggedin_Animation:(BOOL)animate{
    
    NSLog(@"transitionToShowPlan ******");
    
    AppDelegate *appd =[[UIApplication sharedApplication] delegate];
    
    appd.foregroundWindow = [[slidingWindow alloc] initWithFrameAndGestures:[UIScreen mainScreen].bounds];
    appd.foregroundWindow.rootViewController = [appd.myStoryboard instantiateViewControllerWithIdentifier:@"CardsNav"];
    appd.foregroundWindow.windowLevel = UIWindowLevelStatusBar;
    
    
    if(animate){
        
        UIViewController *toVC = [appd.myStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
        
//        [UIView transitionFromView:appd.window.rootViewController.view
//                            toView:toVC.view
//                          duration:2.65f
//                           options:UIViewAnimationOptionTransitionCrossDissolve
//                        completion:^(BOOL finished){
//                            
//                            
//                        }];
        
        [appd.foregroundWindow makeKeyAndVisible];
        [appd.foregroundWindow SlideInFromButtom];
        
        appd.window.rootViewController = toVC;
    }else{
        [appd.foregroundWindow makeKeyAndVisible];
        appd.window.rootViewController = [appd.myStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
    }
}

+(void)transitionForLogout{
    AppDelegate *appd =[[UIApplication sharedApplication] delegate];
    
    UIViewController *svc = [appd.myStoryboard instantiateViewControllerWithIdentifier:@"Login"];
    
    [UIView transitionFromView:appd.window.rootViewController.view
                        toView:svc.view
                      duration:0.65f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        appd.window.rootViewController = svc;
                        [appd.foregroundWindow slideOutFromTop];
                    }];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [appd.foregroundWindow slideOutFromTop];
//    });
}

@end
