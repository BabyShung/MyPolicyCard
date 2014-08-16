//
//  CardsViewController.m
//  upDownTransition
//
//  Created by Hao Zheng on 8/9/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "helloViewController.h"
#import "SecondViewController.h"
#import "largeLayout.h"
#import "EDCollectionCell.h"

@interface helloViewController () 


@end

static NSString *CellIdentifier = @"Cell";

@implementation helloViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadControls];
    
}

-(void)loadControls{
    //registering dequueue cell
    [self.collectionView registerClass:[EDCollectionCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.collectionView.layer.cornerRadius = 6.0f;
    [self.collectionView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];//fix bug for nav, status bar 20px 
    
}

/*******************************
 
 collection view delegate
 
 *****************************/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EDCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //present secondVC
    SecondViewController *viewController = [[SecondViewController alloc] initWithCollectionViewLayout:[[largeLayout alloc] init]];
    viewController.useLayoutToLayoutNavigationTransitions = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}

@end
