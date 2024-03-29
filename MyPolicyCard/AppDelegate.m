//
//  AppDelegate.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "CardsOldViewController.h"
#import "User.h"
#import "GeneralControl.h"
#import "UserDefaultHelper.h"

#import "UIResponder+KeyboardCache.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [Parse setApplicationId:@"StSG8dSOBAuifnwNj4nSh22ppKK6smU3Ayh8864t"
                  clientKey:@"lYw5JetgqAcRM12QOURKjlguO0szzE52nBLP1Gdb"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //cache keyboard
    //[UIResponder cacheKeyboard];
    
    self.myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //use to check first or second login
    [self checkUserDefaultAndPerformLogin];
    
    return YES;
}

-(void)checkUserDefaultAndPerformLogin{
    
    NSDictionary *currentUser = [UserDefaultHelper getCurrentUser];
    if(currentUser){
        //from dictionary to User instance + init
        [User initUserInstanceFromDictionary:currentUser];
        [GeneralControl transitionToLoggedin_Animation:NO];
        
        NSLog(@"Second Login: %@",[User sharedInstance]);
    
    }else{  //not exist, show login page
        self.window.rootViewController = [self.myStoryboard instantiateViewControllerWithIdentifier:@"Login"];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
