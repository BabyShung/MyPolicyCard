//
//  GeneralControl.h
//  EdibleCameraApp
//
//  Created by Hao Zheng on 7/15/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralControl : NSObject

+(void)showError:(NSError *)error withTextField:(UITextField *)textfield;
+(void)showErrorMsg:(NSString *)msg withTextField:(UITextField *)textfield;

+(void)transitionToLoggedin_Animation:(BOOL)animate;
+(void)transitionForLogout;

@end
