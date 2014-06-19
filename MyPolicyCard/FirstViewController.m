//
//  FirstViewController.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "FirstViewController.h"
#import "DECollectionViewCell.h"
#import "DECellData.h"

const NSString *collectionCellIdentity = @"Cell";

@interface FirstViewController ()
    <UICollectionViewDataSource,
    UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentCellHeader;
@property (nonatomic, weak) IBOutlet UICollectionView *bottomCollectionView;

@property (nonatomic, strong) NSMutableArray * bottomCVDataSource;


@end

@implementation FirstViewController
- (void) doInits {
    self.bottomCVDataSource= [NSMutableArray arrayWithArray:@[[[DECellData alloc]               initWithString:@"A"],
                                                              [[DECellData alloc] initWithString:@"B"],
                                                              [[DECellData alloc] initWithString:@"C"],
                                                              [[DECellData alloc] initWithString:@"D"],
                                                              [[DECellData alloc] initWithString:@"E"],
                                                              [[DECellData alloc] initWithString:@"F"],
                                                              [[DECellData alloc] initWithString:@"G"],
                                                              [[DECellData alloc] initWithString:@"H"],
                                                              [[DECellData alloc] initWithString:@"I"],
                                                              [[DECellData alloc] initWithString:@"J"],
                                                              [[DECellData alloc] initWithString:@"K"]]];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self doInits];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.bottomCollectionView registerClass:[DECollectionViewCell class] forCellWithReuseIdentifier:[collectionCellIdentity copy]];
    
    
    
    self.bottomCollectionView.clipsToBounds = NO;
    
    self.currentCellHeader.text = [NSString stringWithFormat:@"This is data for cell \"%@\"", ((DECellData*)[self.bottomCVDataSource firstObject]).cellName];
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bottomCollectionView) {
        NSIndexPath *centerCellIndex = [self.bottomCollectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.bottomCollectionView.bounds) , CGRectGetMidY(self.bottomCollectionView.bounds))];
        self.currentCellHeader.text = [NSString stringWithFormat:@"This is data for cell \"%@\"", ((DECellData*)[self.bottomCVDataSource objectAtIndex:centerCellIndex.row]).cellName];
    }
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.bottomCVDataSource count];

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        DECollectionViewCell *cell = (DECollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[collectionCellIdentity copy] forIndexPath:indexPath];
        cell.imageView = ((DECellData*)self.bottomCVDataSource[indexPath.item]).cellImageView;
        

        
        return cell;

}

@end
