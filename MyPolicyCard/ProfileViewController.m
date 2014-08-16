//
//  ProfileViewController.m
//  upDownTransition
//
//  Created by Hao Zheng on 8/9/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "User.h"
#import "GeneralControl.h"
#import "UIAlertView+Blocks.h"

#import "LocalizationSystem.h"
#import "IQFeedbackView.h"

#import "AppDelegate.h"

@interface ProfileViewController ()

@property (strong,nonatomic) NSArray *profileData;

@property (strong,nonatomic) NSArray *profileImagesData;

@end

@implementation ProfileViewController

const NSString *settingCellIdentity = @"Cell";

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self loadControls];

}

-(void)loadControls{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"bgProfile.png"];
    [self.view insertSubview:backgroundView belowSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    
    User *user = [User sharedInstance];
    
    self.profileData = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:@"%@",user.profileName],
                        @"Feedback",
                        @"Logout",
                        nil];
    self.profileImagesData = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"EDB_language.png"],
                              [UIImage imageNamed:@"EDB_tutorial.png"],
                              [UIImage imageNamed:@"EDB_aboutus.png"],
                              nil];
}


#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.profileData count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileCell *cell = (ProfileCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[settingCellIdentity copy] forIndexPath:indexPath];
    cell.profileLabel.text = [self.profileData objectAtIndex:indexPath.row];
    cell.profileImageView.image = self.profileImagesData[indexPath.row];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.row;
    if(index == 0){
//        [Flurry logEvent:@"Index_0_Search"];
//        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Search"] animated:YES];
    }else if(index == 1){
        
        //[Flurry logEvent:@"Index_1_Feedback"];
        
        
        IQFeedbackView *feedback = [[IQFeedbackView alloc] initWithTitle:AMLocalizedString(@"Feedback", nil) message:@"xxx" image:nil cancelButtonTitle:AMLocalizedString(@"Cancel", nil) doneButtonTitle:AMLocalizedString(@"Send", nil)];
        [feedback setCanAddImage:NO];
        [feedback setCanEditText:YES];
        
        
        [feedback showInViewController:self completionHandler:^(BOOL isCancel, NSString *message, UIImage *image) {
            
            if(!isCancel){//sending feedback
//                [User sendFeedBack:message andCompletion:^(NSError *err,BOOL success){
//                    
//                    if(success){
//                        [self.view makeToast:AMLocalizedString(@"SUCCESS_FEEDBACK", nil)];
//                        self.tempFeedbackText = @"";
//                    }else{
//                        [self.view makeToast:AMLocalizedString(@"FAIL_FEEDBACK", nil)];
//                    }
//                    
//                }];
            }else{
                //temporary save the text
                //self.tempFeedbackText = message;
            }
            [feedback dismiss];
      
        }];
    }else if (index == 2){
        [GeneralControl showConfirmLogout];
    }else if (index == 3){
       
    }
    
}



@end
