//
//  User.h
//  MyPolicyCard
//
//  Created by Hao Zheng on 8/4/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *username;//email for login
@property (strong, nonatomic) NSString *profileName;//name
@property (strong, nonatomic) NSDate *checkDeviceDate; ///profile picture

typedef void (^edibleBlock)(NSError *err, BOOL success);
typedef void (^edibleBlockForCarriers)(NSError *err, BOOL success,NSArray *carriers);

+ (User *)sharedInstance;

+ (User *)sharedInstanceWithUserName:(NSString*)username andProfileName:(NSString *)profileName andCheckDeviceDate:(NSDate*)checkDeviceDate;

+(void)fetchPlansWithBlock:(void(^)(NSError *err, BOOL success,NSArray *carriers))block;

//-(UIImage *) loadAvatar;

+(void)logInWithUsername:(NSString *)username andPassword:(NSString *)pwdString WithCompletion:(void (^)(NSError *err, BOOL success))block;

+(void)logOut;

+(BOOL) isLoggedIn;

+(NSError *) signUpWithEmail:(NSString *)email
                 andPassword:(NSString *)pwdString
                 andUsername:(NSString *)nickname
                   andAvatar:(UIImage *)photo;

+(NSError *) updateProfileWithEmail:(NSString *)emailString andImage:(UIImage *)profileImage;

+(NSDictionary*)toDictionary;

+(User *)fromDictionaryToUser:(NSDictionary *)dict;

+(void)sendFeedBack:(NSString*)content andCompletion:(void (^)(NSError *err, BOOL success))block;

@end
