//
//  AlertViewWindow.m
//  testAlertView
//
//  Created by Hao Zheng on 11/23/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "AlertViewWindow.h"

@implementation AlertViewWindow


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.5;
        self.backgroundColor = [UIColor redColor];
        self.windowLevel = UIWindowLevelAlert;
        
        //transparent view
        UIView *tranView = [[UIView alloc]initWithFrame:self.bounds];
        tranView.backgroundColor = [UIColor blackColor];
        tranView.alpha = 0.7;
        [self addSubview:tranView];
    }
    return self;
}

-(void)showWindow{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self makeKeyAndVisible];
        NSLog(@"xx2");
        self.alpha = 1;
        
    } completion:nil];
}

-(void)hideWindow{
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.hidden = YES;
        self.alpha = 0;
        
    } completion:nil];
}
@end
