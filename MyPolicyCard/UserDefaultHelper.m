//
//  NSUserDefaultControls.m
//  EdibleCameraApp
//
//  Created by Hao Zheng on 7/17/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "UserDefaultHelper.h"

@implementation UserDefaultHelper

+(void)saveUserDictionaryIntoNSUserDefault_dict:(NSDictionary *)dict andKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isFirstLaunch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]?NO:YES;
}

+(void)userFinishFirstLaunch{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(NSDictionary *)getCurrentUser{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"]:nil;
}

@end
