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


#import "UIResponder+KeyboardCache.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [Parse setApplicationId:@"StSG8dSOBAuifnwNj4nSh22ppKK6smU3Ayh8864t"
                  clientKey:@"lYw5JetgqAcRM12QOURKjlguO0szzE52nBLP1Gdb"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    //cache keyboard
    [UIResponder cacheKeyboard];
    
    self.myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //use to check first or second login
    [self checkUserInNSUserDefaultAndPerformLogin];
    

    return YES;
}

-(void)checkUserInNSUserDefaultAndPerformLogin{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"]) {
        //current user exists
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"];
        //from dictionary to User instance
        [User fromDictionaryToUser:dict];
        
        [GeneralControl transitionToShowPlan:self.myStoryboard withAnimation:NO];
        
        NSLog(@"Second Login: %@",[User sharedInstance]);
        
    }else{
        //not exist, show login page
        [self initLoginWindow];
    }
}

-(void)initLoginVC{
    self.window.rootViewController = [self.myStoryboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.window makeKeyAndVisible];
}

-(void)initLoginWindow{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.windowLevel = UIWindowLevelNormal;
    [self initLoginVC];
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
