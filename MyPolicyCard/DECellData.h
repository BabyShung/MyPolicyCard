//
//  DECellData.h
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DECellData : NSObject
@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, strong) UIImageView *cellImageView;

- (id) initWithString:(NSString*)cellName;
@end
