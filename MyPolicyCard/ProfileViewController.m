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
#import "UIView+Toast.h"

#import "IQFeedbackView.h"


@interface ProfileViewController ()

@property (strong,nonatomic) NSArray *profileData;

@property (strong,nonatomic) NSArray *profileImagesData;

@property (strong,nonatomic) NSString *tempFeedbackText;

@end

@implementation ProfileViewController

const NSString *settingCellIdentity = @"Cell";

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
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
    
    [cell.profileButton setTitle:[self.profileData objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    cell.profileButton.backgroundColor = [UIColor clearColor];
    cell.profileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cell.profileButton.contentEdgeInsets = UIEdgeInsetsMake(0, cell.profileButton.bounds.size.width/2 - 30, 0, 0);
    cell.profileButton.trackTouchLocation = YES;
    
    cell.profileImageView.image = self.profileImagesData[indexPath.row];
    
    [cell.profileButton addTarget:self action:@selector(clickCell:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)clickCell:(id)sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPosition];
    NSUInteger index = indexPath.row;
    
    if(index == 0){
        
    }else if(index == 1){
        [self showFeedbackView];
    }else if(index == 2){
        [self showConfirmLogout];
    }
}

-(void)showConfirmLogout{
    [UIAlertView showConfirmationDialogWithTitle:@"Log out" message:@"Are you sure to log out?" handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
        }else{
            [User logOut];
            [GeneralControl transitionForLogout];
        }
    }];
}

-(void)showFeedbackView{
    //[Flurry logEvent:@"Index_1_Feedback"];
    
    
    IQFeedbackView *feedback = [[IQFeedbackView alloc] initWithTitle:AMLocalizedString(@"FEEDBACK", nil) message:self.tempFeedbackText image:nil cancelButtonTitle:AMLocalizedString(@"Cancel", nil) doneButtonTitle:AMLocalizedString(@"Send", nil)];
    [feedback setCanAddImage:NO];
    [feedback setCanEditText:YES];
    
    
    [feedback showInViewController:self completionHandler:^(BOOL isCancel, NSString *message, UIImage *image) {
        
        if(!isCancel){//sending feedback
            [User sendFeedBack:message andCompletion:^(NSError *err,BOOL success){
                
                if(success){
                    [self.view makeToast:AMLocalizedString(@"SUCCESS_FEEDBACK", nil) duration:3.f position:@"top"];
                    self.tempFeedbackText = @"";
                }else{
                    [self.view makeToast:AMLocalizedString(@"FAIL_FEEDBACK", nil) duration:3.f position:@"top"];
                }
            }];
        }else{
            //temporary save the text
            self.tempFeedbackText = message;
        }
        [feedback dismiss];
        
    }];
}


@end
