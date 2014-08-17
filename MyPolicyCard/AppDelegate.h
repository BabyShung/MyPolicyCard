//
//  AppDelegate.h
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HaoWindow.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HaoWindow *profileWindow;
@property (strong, nonatomic) HaoWindow *foregroundWindow;

-(void)initLoginWindow;

@end
