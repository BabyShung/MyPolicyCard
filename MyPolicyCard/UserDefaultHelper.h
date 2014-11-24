//
//  NSUserDefaultControls.h
//  EdibleCameraApp
//
//  Created by Hao Zheng on 7/17/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultHelper : NSObject

+(void)saveUserDictionaryIntoNSUserDefault_dict:(NSDictionary *)dict andKey:(NSString *)key;

+(BOOL)isFirstLaunch;

+(void)userFinishFirstLaunch;

+(NSDictionary *)getCurrentUser;

@end
