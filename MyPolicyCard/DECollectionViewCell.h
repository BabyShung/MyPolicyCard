//
//  DECollectionViewCell.h
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DECollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;

@property (nonatomic) BOOL isPlaceHolder;

@end
