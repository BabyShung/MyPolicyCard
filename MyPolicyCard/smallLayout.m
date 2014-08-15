//
//  smallLayout.m
//  HaoPaper
//
//  Created by Hao Zheng on 6/20/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "smallLayout.h"

#define ip5CellHeight 205
#define ip4CellHeight 175
#define CellWidth 148

@implementation smallLayout

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (id)init{
    if (self = [super init]){
        [self setup];
    }
    return self;
}

-(void)setup{
    
    CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    CGFloat sectionInset = iPhone5?screenHeight - ip5CellHeight:screenHeight-ip4CellHeight;
    self.itemSize = CGSizeMake(CellWidth, iPhone5? ip5CellHeight:ip4CellHeight);
    self.sectionInset = UIEdgeInsetsMake(sectionInset, 2, 0, 2);
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 2.5f;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return NO;
}

@end
