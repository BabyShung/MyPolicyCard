//
//  User.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 8/4/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "User.h"
#import "Carrier.h"
#import <Parse/Parse.h>

static User *sharedInstance = nil;
static edibleBlock CompletionBlock;
static edibleBlockForCarriers CompletionBlockForCarriers;
@interface User()

@end

#define PHOTO_MAX_SIZE 1 //max iamge size 1 m

@implementation User

+ (User *)sharedInstance{   //directly get the instance
    return sharedInstance;
}

+ (User *)sharedInstanceWithUserName:(NSString*)username andProfileName:(NSString *)profileName andCheckDeviceDate:(NSDate*)checkDeviceDate{
    User *user = [User sharedInstance];
    if(user){
        //for logout and login again
        user.username = username;
        user.profileName = profileName;
        user.checkDeviceDate = checkDeviceDate;
    }else{
        //just first login
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            sharedInstance = [[User alloc] init];
            sharedInstance.username = username;
            sharedInstance.profileName = profileName;
            sharedInstance.checkDeviceDate = checkDeviceDate;
        });
    }
    return sharedInstance;
}

//-(UIImage *) loadAvatar{
//    UIImage *image;
//    PFFile *userImageFile = self.userObj[@"avatar"];
//    NSData *imageData = [userImageFile getData];
//    if (imageData) {
//        image = [UIImage imageWithData:imageData];
//    }
//    self.avatar = image;
//    return image;
//}

+(void)fetchPlansWithBlock:(void(^)(NSError *err, BOOL success,NSArray *carriers))block{
    CompletionBlockForCarriers = block;
    
    //first, query to get all the plans based on the userId
    PFQuery *plansQuery = [PFQuery queryWithClassName:@"UserPolicy"];
    [plansQuery whereKey:@"UserObjectID" equalTo:[PFUser currentUser].objectId];
    [plansQuery orderByDescending:@"createdAt"];
    
    //second, when you get a list of policyId, use these IDs to get all the policies
    PFQuery *policyQuery = [PFQuery queryWithClassName:@"Policy"];
    [policyQuery whereKey:@"objectId" matchesKey:@"PolicyObjectID" inQuery:plansQuery];
    [policyQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSMutableArray *carriers = [NSMutableArray array];
            
            // Do something with the found objects
            for (PFObject *object in results) {
                
                NSString *planName = object[@"policyName"];
                NSString *planNo = object[@"policyNum"];
                NSString *phoneNo = object[@"phoneNum"];
                NSString *website = object[@"website"];
                
                Carrier *current = [[Carrier alloc] initWithPlan:planName andPolicyNo:planNo andPhoneNo:phoneNo andWeb:website];
                NSLog(@"%@",current);
                
                [carriers addObject:current];
            }
            CompletionBlockForCarriers(nil,YES,carriers);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            CompletionBlockForCarriers(error,NO,nil);
        }
    }];
}

+(BOOL) isLoggedIn{
    return [PFUser currentUser]?YES:NO;
}

+(void)logInWithUsername:(NSString *)username andPassword:(NSString *)pwdString WithCompletion:(void (^)(NSError *err, BOOL success))block{
    CompletionBlock = block;
    //using the parse framework
    [PFUser logInWithUsernameInBackground:username password:pwdString
                                    block:^(PFUser *user, NSError *appError) {
                                        if (user) {
                                            
                                            user[@"checkDeviceDate"] = [NSDate date];
                                            [user saveInBackground];
                                            
                                            //init the User instance
                                            [self sharedInstanceWithUserName:user.username andProfileName:user[@"AppUserName"] andCheckDeviceDate:user[@"checkDeviceDate"]];
                                            if (CompletionBlock) {
                                                CompletionBlock(nil,YES);
                                            }
                                        } else {
                                            if (CompletionBlock) {
                                                CompletionBlock(appError,NO);
                                            }
                                        }
                                    }];
}

+(void) logOut{
    
    /************************
     
     log out release things
     
     ************************/
    
    [PFUser logOut];
    
    //set user to nil
    [User ClearUserInfo];
    
    //clear userdefault for second login
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSLog(@"------ log out success------");
}

+(NSError *) signUpWithEmail:(NSString *)email
                 andPassword:(NSString *)pwdString
                 andUsername:(NSString *)nickname
                   andAvatar:(UIImage *)photo{
    NSError *error;
    PFUser *newuser = [PFUser user];
    //Set built-in properties
    newuser.username = email;
    newuser.email = email;
    newuser.password = pwdString;
    
    //Set customized properties;
    newuser[@"AppUserName"] = nickname;
    
    //For an image, creat a PFFile and save it separatly;
    //Then plug it in to User
    if (photo) {
        NSData *imagedata = UIImagePNGRepresentation(photo);
        PFFile *imgfile = [PFFile fileWithData:imagedata];
        [imgfile saveInBackground];
        newuser[@"avatar"] = imgfile;
    }
    
    NSLog(@"hash: %@",newuser.password);
    [newuser signUp:&error];
    return error;
}

+(NSError *) updateProfileWithEmail:(NSString *)emailString andImage:(UIImage *)profileImage{
    
    PFUser *updateUser = [PFUser currentUser];
    updateUser.email = emailString;
    if (profileImage) {
        NSData *imagedata = UIImagePNGRepresentation(profileImage);
        PFFile *imgfile = [PFFile fileWithData:imagedata];
        [imgfile saveInBackground];
        updateUser[@"avatar"] = imgfile;
    }
    NSError *error;
    [updateUser save:&error];
    return error;
}

+(NSDictionary*)toDictionary{
    
    if(!sharedInstance.username)
        return nil;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sharedInstance.username, @"username",
                          sharedInstance.profileName, @"profileName",
                          sharedInstance.checkDeviceDate, @"checkDeviceDate",
                          nil];
    return dict;
}

+(User *)fromDictionaryToUser:(NSDictionary *)dict{
    
    NSString *username = [dict objectForKey:@"username"];
    NSString *profileName = [dict objectForKey:@"profileName"];
    NSDate *checkDeviceDate = [dict objectForKey:@"checkDeviceDate"];
    
    User *user = [self sharedInstanceWithUserName:username andProfileName:profileName andCheckDeviceDate:checkDeviceDate];
    return user;
}

+(void)sendFeedBack:(NSString*)content andCompletion:(void (^)(NSError *err, BOOL success))block{
    CompletionBlock = block;
    
    PFObject *gameScore = [PFObject objectWithClassName:@"Feedback"];
    gameScore[@"email"] = sharedInstance.username;
    gameScore[@"content"] = content;
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            CompletionBlock(nil,YES);
        }else{
            CompletionBlock(error,NO);
        }
    }];
}


+(void)ClearUserInfo{
    NSLog(@"----- User info clear----");
    sharedInstance.username = nil;
    sharedInstance.profileName =nil;
    sharedInstance.checkDeviceDate = nil;
}

- (NSString *)description{
	NSString *desc  = [NSString stringWithFormat:@"\n username: %@,\n profileName: %@,\n checkDeviceDate: %@", self.username,self.profileName,self.checkDeviceDate];
	return desc;
}

@end
