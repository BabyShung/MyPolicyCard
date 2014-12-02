//
//  HaoWindow.m
//  PaperForeBackWindow
//
//  Created by Hao Zheng on 8/14/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "slidingWindow.h"
#import "draggableViewState.h"
#import "MovingBehavior.h"

#define kRecuriveAnimationEnabled NO
#define kWindowHeaderHeight 80
#define WindowScaleFactor 0.04

@interface slidingWindow()
{
    CGFloat ScreenWidth;
    CGFloat ScreenHeight;
}

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) dragViewState state;
@property (nonatomic, strong) MovingBehavior *dragBehavior;
@property (nonatomic,strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation slidingWindow

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //fix the first time bug
        //[self cancelTransition];
        
        [self setup];
    }
    return self;
}

- (id)initWithFrameAndGestures:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //fix the first time bug
        //[self cancelTransition];
        
        [self setup];
        
        //pan gesture
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [self addGestureRecognizer:panGesture];
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowRadius = 4.0f;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = .8f;
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        //add tap
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:_tapRecognizer];
        _tapRecognizer.enabled = NO;
        
    }
    return self;
}

-(void)setup{
    
    ScreenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    ScreenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    
    self.state = StateOpen;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
}


- (UIWindow *)superWindow{
    
    //for this app, temporarily a workaround
    NSArray * windows = [UIApplication sharedApplication].windows;
    return windows[0];
    
//    NSArray * windows = [UIApplication sharedApplication].windows;
//    NSInteger index = [windows indexOfObject:self];
//    if (index) {
//        return windows[index - 1];
//    }
//    return nil;
}

- (UIWindow *)nextWindow{
    
    NSArray * windows = [UIApplication sharedApplication].windows;
    NSInteger index = [windows indexOfObject:self];
    if (index+1 < [windows count]) {
        return windows[index + 1];
    }
    return nil;
}

- (void)didTap:(UITapGestureRecognizer *)tapRecognizer{
    _tapRecognizer.enabled = NO;
    [self animateDragViewWithInitialVelocity:CGPointMake(0, -300)];
}

-(void)SlideInFromButtom{
    self.center = CGPointMake(ScreenWidth/2, ScreenHeight * 1.5);
    [self animateDragViewWithInitialVelocity:CGPointMake(0, -300)];
}

-(void)slideOutFromTop{
    [self animateWindow_Velocity:CGPointMake(0, 200) andFinalPosition:CGPointMake(ScreenWidth/2, ScreenHeight * 1.5)];
}

- (void)onPan:(UIPanGestureRecognizer *)pan{
    
    CGPoint translation = [pan translationInView:self];
    CGPoint velocity = [pan velocityInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            //when the touch begins, first remove the animation
            [self.animator removeAllBehaviors];
        }
            break;
        case UIGestureRecognizerStateChanged:{
                self.center = CGPointMake(self.center.x, self.center.y + translation.y);
                [pan setTranslation:CGPointZero inView:self];
                //calculate a percentage
                CGFloat percentage = CGRectGetMinY(self.frame) /(CGRectGetHeight([UIScreen mainScreen].bounds) - kWindowHeaderHeight);
            
                [self updateTransitionAnimationWithPercentage:percentage];
                [self updateNextWindowTranslationIfNeeded];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            velocity.x = 0;
            [self animateDragViewWithInitialVelocity:velocity];
        }
            break;
        default:
            break;
    }
}

-(void)animateWindow_Velocity:(CGPoint)initialVelocity andFinalPosition:(CGPoint)pos{
    if (!self.dragBehavior) {
        NSLog(@"init once for dragView behavior");
        self.dragBehavior = [[MovingBehavior alloc] initWithItem:self];//which object you want to operate
    }
    self.dragBehavior.targetPoint = pos;
    self.dragBehavior.velocity = initialVelocity;
    
    //once added, it will effect
    [self.animator addBehavior:self.dragBehavior];
}

- (void)animateDragViewWithInitialVelocity:(CGPoint)initialVelocity{
    
    if(initialVelocity.y >= 0){    //going down, which means closing
        self.state = StateClosed;
        _tapRecognizer.enabled = YES;
    }else{
        self.state = StateOpen;
        _tapRecognizer.enabled = NO;
    }
    
    //important
    [self animateWindow_Velocity:initialVelocity andFinalPosition:[self getProperPoint]];
    
    //touch up and animate the rest
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (initialVelocity.y < 0) {
            [self cancelTransition];
        } else {
            [self completeTransition];
        }
    } completion:nil];
}

//getter
- (CGPoint)getProperPoint{
    
    CGSize size = self.bounds.size;
    CGPoint result;
    if(self.state == StateClosed){
        result = CGPointMake(size.width/2, size.height/2 + CGRectGetHeight([UIScreen mainScreen].bounds) - kWindowHeaderHeight);
    }else{
        result = CGPointMake(size.width/2,size.height/2);
    }
    return result;
}

- (void)updateTransitionAnimationWithPercentage:(CGFloat)percentage{
    
    UIWindow *window = self.superWindow;
    if (window) {
        CGFloat scale = 1.0 - WindowScaleFactor * (1-percentage);
        window.transform = CGAffineTransformMakeScale(scale, scale);
        window.alpha = percentage;
        if (kRecuriveAnimationEnabled && [window respondsToSelector:@selector(updateTransitionAnimationWithPercentage:)]) {
            [(slidingWindow *)window updateTransitionAnimationWithPercentage:percentage];
        }
    }
}

- (void)cancelTransition{
    UIWindow *window = self.superWindow;
    if (window) {
        CGFloat returnScale = 1 - WindowScaleFactor;
        window.transform = CGAffineTransformMakeScale(returnScale, returnScale);
        window.alpha = 0;
        if (kRecuriveAnimationEnabled && [window respondsToSelector:@selector(cancelTransition)]) {
            [(slidingWindow *)window cancelTransition];
        }
    }
    UIWindow *nextWindow = self.nextWindow;
    if (nextWindow) {
        nextWindow.transform = CGAffineTransformIdentity;
    }
}

- (void)completeTransition{
    UIWindow *window = self.superWindow;
    if (window) {
        window.transform = CGAffineTransformIdentity;
        window.alpha = 1;
        if (kRecuriveAnimationEnabled && [window respondsToSelector:@selector(completeTransition)]) {
            [(slidingWindow *)window completeTransition];
        }
    }
    [self completeNextWindowTranslation];
}

- (void)updateNextWindowTranslationIfNeeded{
    UIWindow *nextWindow = self.nextWindow;
    if (nextWindow) {
        CGFloat diffY = fabs(CGRectGetMinY(nextWindow.frame) - CGRectGetMinY(self.frame));
        if (diffY < kWindowHeaderHeight) {
            nextWindow.transform = CGAffineTransformMakeTranslation(0, kWindowHeaderHeight-diffY);
        }
    }
}

- (void)completeNextWindowTranslation{
    UIWindow *nextWindow = self.nextWindow;
    if (nextWindow) {
        nextWindow.transform = CGAffineTransformMakeTranslation(0, kWindowHeaderHeight);
    }
}
@end
