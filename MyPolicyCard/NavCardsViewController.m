//
//  NavCardsViewController.m
//  PaperForeBackWindow
//
//  Created by Hao Zheng on 8/14/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "NavCardsViewController.h"
#import "dragViewBehavior.h"
#import "AppDelegate.h"

@interface NavCardsViewController ()

@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) dragViewState state;
@property (nonatomic, strong) dragViewBehavior *dragBehavior;

@property (nonatomic,strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation NavCardsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self loadControls];
    
}

-(void)loadControls{
    self.delegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
    self.window = self.delegate.foregroundWindow;
    self.window.layer.cornerRadius = 12.0f;
    self.window.layer.shadowRadius = 6.0f;
    self.window.layer.shadowOffset = CGSizeMake(0,1);
    self.window.layer.shadowColor = [UIColor blackColor].CGColor;
    self.window.layer.shadowOpacity = .8f;
    //self.window.layer.shouldRasterize = YES;
    self.window.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.window.bounds].CGPath;
    
    // Pan for a dismissal using UIKit Dynamics
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:panGesture];
    
    //add tap
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.window addGestureRecognizer:_tapRecognizer];
    _tapRecognizer.enabled = NO;
    
    self.state = StateOpen;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.superview];
}

- (void)didTap:(UITapGestureRecognizer *)tapRecognizer{
    _tapRecognizer.enabled = NO;
    [self animateDragViewWithInitialVelocity:CGPointMake(0, -300)];
}

- (void)didPan:(UIPanGestureRecognizer *)gesture{
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            //when the touch begins, first remove the animation
            [self.animator removeAllBehaviors];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            CGPoint offsetXandY = [gesture translationInView:self.view.superview];
            self.window.center = CGPointMake(self.window.center.x, self.window.center.y + offsetXandY.y);
            [gesture setTranslation:CGPointZero inView:self.view.superview];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            CGPoint velocity = [gesture velocityInView:self.view.superview];
            velocity.x = 0;
            [self animateDragViewWithInitialVelocity:velocity];
            
            break;
        }
        default:
            break;
    }
}

- (void)animateDragViewWithInitialVelocity:(CGPoint)initialVelocity{
    
    if(initialVelocity.y >= 0){    //going down, which means closing
        self.state = StateClosed;
        _tapRecognizer.enabled = YES;
    }else{
        self.state = StateOpen;
        _tapRecognizer.enabled = NO;
    }
    
    if (!self.dragBehavior) {
        NSLog(@"init once for dragView behavior");
        self.dragBehavior = [[dragViewBehavior alloc] initWithItem:self.window];//which object you want to operate
    }
    self.dragBehavior.targetPoint = self.targetPoint;
    self.dragBehavior.velocity = initialVelocity;
    
    //once added, it will effect
    [self.animator addBehavior:self.dragBehavior];
}

//getter
- (CGPoint)targetPoint{
    
    CGSize size = self.view.bounds.size;
    CGPoint result;
    if(self.state == StateClosed){
        result = CGPointMake(size.width/2, size.height+200);
    }else{
        result = CGPointMake(size.width/2, size.height/2);
    }
    return result;
}

@end
