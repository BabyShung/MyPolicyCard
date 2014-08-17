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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"StSG8dSOBAuifnwNj4nSh22ppKK6smU3Ayh8864t"
                  clientKey:@"lYw5JetgqAcRM12QOURKjlguO0szzE52nBLP1Gdb"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    
    
    
    
    [self checkUserInNSUserDefaultAndPerformLogin];
    

    return YES;
}

-(void)checkUserInNSUserDefaultAndPerformLogin{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"];
        //from dictionary to User instance
        [User fromDictionaryToUser:dict];
        
        [GeneralControl transitionToShowPlan:[UIStoryboard storyboardWithName:@"Main" bundle:nil] withAnimation:NO];
        
        NSLog(@"******************  Second Login: %@",[User sharedInstance]);
        
    }else{
        [self initLoginWindow];
    }
}

-(void)initLoginWindow{
    
    //cache keyboard
    [UIResponder cacheKeyboard];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.window makeKeyAndVisible];

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
