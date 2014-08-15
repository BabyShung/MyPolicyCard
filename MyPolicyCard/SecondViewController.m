//
//  SecondViewController.m
//  PaperForeBackWindow
//
//  Created by Hao Zheng on 8/10/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
}

@end
