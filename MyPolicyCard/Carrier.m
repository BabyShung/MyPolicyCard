//
//  Carrier.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/19/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "Carrier.h"


@implementation Carrier

-(instancetype)initWithPlan:(NSString *)plan andPolicyNo:(NSString *)policyNo andPhoneNo:(NSString *) phoneNo andWeb:(NSString *)website{
    
    self = [super init];
    if(self){
        _plan = plan;
        _policyNumber = policyNo;
        _phoneNumber = phoneNo;
        _website = website;
        //
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"planName: %@,policyNum: %@,phoneNum: %@,website: %@",_plan,_policyNumber,_phoneNumber,_website];
}

@end
