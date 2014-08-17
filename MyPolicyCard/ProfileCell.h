//
//  SettingsCell.h
//  EdibleCameraApp
//
//  Created by Hao Zheng on 7/19/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeRippleButton.h"

@interface ProfileCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet FeRippleButton *profileButton;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@end
