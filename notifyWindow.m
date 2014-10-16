//
//  notifyWindow.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 8/15/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "notifyWindow.h"
#import "LoadingAnimation.h"
#import "UIColor+flat.h"
#import "FBShimmering.h"
#import "FBShimmeringView.h"
#import "LoadControls.h"

@interface notifyWindow ()

@property (nonatomic,strong) LoadingAnimation *loadingImage;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) FBShimmeringView *shimmeringView;
@end

@implementation notifyWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 1;
        
        [self setup];

    }
    return self;
}

-(void)setup{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    //transparent view
    UIView *tranView = [[UIView alloc]initWithFrame:self.bounds];
    tranView.backgroundColor = [UIColor blackColor];
    tranView.alpha = 0.7;
    [self addSubview:tranView];
    
    //loading spin
    self.loadingImage = [[LoadingAnimation alloc] initWithStyle:RTSpinKitViewStylePlane color:[UIColor flatAlizarinColor]];
    
    self.loadingImage.center = CGPointMake(CGRectGetMidX(screenBounds), iPhone5? screenBounds.size.height*0.4:screenBounds.size.height*0.75);
    [self addSubview:self.loadingImage];
    
    [self.loadingImage startAnimating];
    
    
    //shimmer label
    CGRect titleRect = CGRectMake(0, 0, screenBounds.size.width, 80);
    self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:titleRect];
    self.shimmeringView.center = CGPointMake(self.loadingImage.center.x,self.loadingImage.center.y + 32);
    self.shimmeringView.shimmering = NO;   //start shimmering
    self.shimmeringView.shimmeringBeginFadeDuration = 0.2;
    self.shimmeringView.shimmeringOpacity = 0.5;
    self.shimmeringView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.shimmeringView];
    
    self.titleLabel = [LoadControls createLabelWithRect:_shimmeringView.bounds andTextAlignment:NSTextAlignmentCenter andFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22] andTextColor:[UIColor whiteColor]];
    self.titleLabel.text = @"Loading";

    _shimmeringView.contentView = self.titleLabel;
    
}


-(void)showWindow{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self makeKeyAndVisible];
        [self.loadingImage startAnimating];
        self.shimmeringView.shimmering = YES;
        self.alpha = 1;
        
    } completion:nil];
}

-(void)hideWindow{
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.hidden = YES;
        [self.loadingImage stopAnimating];
        self.shimmeringView.shimmering = NO;
        self.alpha = 0;
        
    } completion:nil];
}


@end
