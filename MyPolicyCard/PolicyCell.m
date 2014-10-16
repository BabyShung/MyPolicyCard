//
//  EDCollectionCell.m
//  Paper
//
//  Created by Hao Zheng on 6/11/14.
//  Copyright (c) 2014 Heberti Almeida. All rights reserved.
//

#import "PolicyCell.h"

@interface PolicyCell()

@end

@implementation PolicyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;
    
}

@end
