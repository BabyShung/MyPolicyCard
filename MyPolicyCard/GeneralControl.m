//
//  GeneralControl.m
//  EdibleCameraApp
//
//  Created by Hao Zheng on 7/15/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "GeneralControl.h"
#import "UIAlertView+Blocks.h"
#import "LocalizationSystem.h"
#import "AppDelegate.h"
#import "HaoWindow.h"

@implementation GeneralControl

+(void)showError:(NSError *)error withTextField:(UITextField *)textfield{
    
    NSString *errorMsg;
    
    if(error.code == 101){
        errorMsg = AMLocalizedString(@"ERROR_LOGIN", nil);
    }else{
        //general error
    }
    [self showAlertView:errorMsg withTextField:textfield];
}

+(void)showErrorMsg:(NSString *)msg withTextField:(UITextField *)textfield{
    [self showAlertView:msg withTextField:textfield];
}

+(void)showAlertView:(NSString *)msg withTextField:(UITextField *)textfield{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AMLocalizedString(@"OOPS", nil) message:msg delegate:nil cancelButtonTitle:AMLocalizedString(@"Cancel", nil) otherButtonTitles: nil];
    [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            if(textfield){
                textfield.text = @"";
                [textfield becomeFirstResponder];
            }
        }
    }];
}


+(void)transitionToShowPlan:(UIStoryboard*)sb withAnimation:(BOOL)animate{
    
    NSLog(@"transitionToShowPlan ******");
    
    AppDelegate *appd =[[UIApplication sharedApplication] delegate];
    
    appd.foregroundWindow = [[HaoWindow alloc] initWithFrameAndGestures:[UIScreen mainScreen].bounds];
    appd.foregroundWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"CardsNav"];
    appd.foregroundWindow.windowLevel = UIWindowLevelStatusBar;
    
    if(animate){
        [appd.foregroundWindow SlideInFromButtom];
    }else{
        [appd.foregroundWindow makeKeyAndVisible];
    }

    
    appd.profileWindow = [[HaoWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    appd.profileWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"Profile"];
    appd.profileWindow.windowLevel = UIWindowLevelNormal + 50;
    
    [appd.profileWindow makeKeyAndVisible];
    appd.profileWindow.alpha = 0;
//
    //release the login window
    [UIView animateWithDuration:.5 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        appd.window.alpha = 0;
    } completion:^(BOOL success){
        appd.window = nil;
    }];
    
}

+(void)transitionForLogout{
    AppDelegate *appd =[[UIApplication sharedApplication] delegate];
    
    [appd initLoginWindow];
    
    [appd.profileWindow slideOutFromTop];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [appd.foregroundWindow slideOutFromTop];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            appd.foregroundWindow = nil;
            appd.profileWindow = nil;
        });
    });
    
    
    
    
}


+(void)transitionToVC:(UIViewController *)vc withToVCStoryboardId:(NSString*)name{
    [self transitionToVC:vc withToVCStoryboardId:name withDuration:0.8];
}

+(void)transitionToVC:(UIViewController *)vc withToVCStoryboardId:(NSString*)name withDuration:(CGFloat) duration{
    
    AppDelegate *appd = [[UIApplication sharedApplication] delegate];
    UIWindow *windooo = appd.foregroundWindow;
    UIViewController *fvc = [vc.storyboard instantiateViewControllerWithIdentifier:name];
    //fvc.view.backgroundColor = [UIColor clearColor];
    [UIView transitionWithView:windooo
                      duration:duration
                       options:UIViewAnimationOptionCurveEaseOut
                    animations:^{
                        vc.view.alpha = 0;
                    }
                    completion:^(BOOL success){
                        windooo.rootViewController = fvc;
                    }];
}

@end
