//
//  AppDelegate.h
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "slidingWindow.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIStoryboard *myStoryboard;
@property (strong, nonatomic) slidingWindow *window;
@property (strong, nonatomic) slidingWindow *foregroundWindow;

-(void)initLoginWindow;

@end
