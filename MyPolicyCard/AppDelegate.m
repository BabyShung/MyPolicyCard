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
#import "HaoWindow.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"StSG8dSOBAuifnwNj4nSh22ppKK6smU3Ayh8864t"
                  clientKey:@"lYw5JetgqAcRM12QOURKjlguO0szzE52nBLP1Gdb"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    [self.window makeKeyAndVisible];
    
    //my special window
    self.foregroundWindow = [[HaoWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.foregroundWindow.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    self.foregroundWindow.windowLevel = UIWindowLevelStatusBar;
    //self.foregroundWindow.backgroundColor = [UIColor clearColor];
    [self.foregroundWindow makeKeyAndVisible];
    
    //self.notifyWindow = [[notifyWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //[self.notifyWindow makeKeyAndVisible];

    
    return YES;
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
