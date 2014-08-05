//
//  FirstViewController.m
//  MyPolicyCard
//
//  Created by Hao Zheng on 6/18/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "CardsViewController.h"
#import "CollectionCell.h"
#import "LoginViewController.h"

#import "Carrier.h"

#import "FBShimmering.h"
#import "FBShimmeringView.h"
#import "RQShineLabel.h"
#import "User.h"
#import "UILayers.h"
#import "GeneralControl.h"

const NSString *collectionCellIdentity = @"Cell";
const CGFloat LeftMargin = 15.0f;
const CGFloat TopMargin = 25.0f;
static NSArray *colors;

@interface CardsViewController ()
    <UICollectionViewDataSource,
    UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentCellHeader;
@property (weak, nonatomic) IBOutlet UILabel *policyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;

@property (weak, nonatomic) IBOutlet UIView *numberSeparator;

@property (weak, nonatomic) IBOutlet UILabel *numerator;

@property (weak, nonatomic) IBOutlet UILabel *denominator;

@property (nonatomic, weak) IBOutlet UICollectionView *bottomCollectionView;

@property (strong,nonatomic) NSArray *carriers;

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) FBShimmeringView *shimmeringView;
@property (strong, nonatomic) RQShineLabel *descriptionLabel;

@end

@implementation CardsViewController
- (void) doInits {
    
    colors = @[[UIColor colorWithRed:(0/255.0) green:(181/255.0) blue:(239/255.0) alpha:1],
               [UIColor colorWithRed:(150/255.0) green:(222/255.0) blue:(35/255.0) alpha:1],
               [UIColor colorWithRed:(255/255.0) green:(216/255.0) blue:(0/255.0) alpha:1],
               [UIColor colorWithRed:(0/255.0) green:(125/255.0) blue:(192/255.0) alpha:1],
               [UIColor colorWithRed:(253/255.0) green:(91/255.0) blue:(159/255.0) alpha:1],
               [UIColor colorWithRed:(233/255.0) green:(0/255.0) blue:(11/255.0) alpha:1]];
    
//    Carrier *c1 = [[Carrier alloc]initWithPlan:@"United Healthcare Medical" andPolicyNo:@"718595" andPhoneNo:@"866.633.2446" andWeb:@"www.myuhc.com"];
//    Carrier *c2 = [[Carrier alloc]initWithPlan:@"MetLife Dental" andPolicyNo:@"5723634" andPhoneNo:@"888.466.8673" andWeb:@"www.metlife.com"];
//    Carrier *c3 = [[Carrier alloc]initWithPlan:@"VSP Vision" andPolicyNo:@"30017638" andPhoneNo:@"800.877.7195" andWeb:@"www.vsp.com"];
//    Carrier *c4 = [[Carrier alloc]initWithPlan:@"Lincoln: Life/AD&D LTD" andPolicyNo:@"0122960" andPhoneNo:@"800.423.2765" andWeb:@"www.lfg.com"];
//    Carrier *c5 = [[Carrier alloc]initWithPlan:@"401(k): John Hancock" andPolicyNo:@"30654" andPhoneNo:@"800.395.1113" andWeb:@"www.jhpensions.com"];
//    Carrier *c6 = [[Carrier alloc]initWithPlan:@"FSA: Benefit Dynamics" andPolicyNo:nil andPhoneNo:@"925.956.0505" andWeb:@"www.pensiondynamics.com"];
//    
//    self.carriers = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,c6, nil];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self doInits];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //add layers to the image frame
    UILayers *uil = [[UILayers alloc]init];
    
    CALayer * calayer = [uil borderLayerWidth:self.logoImageView.frame.size.width andHeight:self.logoImageView.frame.size.height andBorderWidth:1.5 andColor:[UIColor whiteColor]];
    [self.logoImageView.layer addSublayer:calayer];
    calayer = [uil borderLayerWidth:self.logoImageView.frame.size.width andHeight:self.logoImageView.frame.size.height andBorderWidth:0.3 andColor:[UIColor grayColor]];
    [self.logoImageView.layer addSublayer:calayer];

    
    self.navigationController.navigationBarHidden = YES;
    
    [self.bottomCollectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:[collectionCellIdentity copy]];
    
    self.bottomCollectionView.clipsToBounds = NO;
    
    //first show
    Carrier *current = (Carrier*)[self.carriers firstObject];
    self.currentCellHeader.text = [NSString stringWithFormat:@"%@", current.plan];
    self.policyLabel.text = current.policyNumber;//current.policyNumber.count==0?@"":current.policyNumber;
    self.phoneLabel.text = current.phoneNumber;
    self.webLabel.text = current.website;
    
    CGRect titleRect = CGRectMake(LeftMargin, TopMargin, self.view.bounds.size.width, 30);
    self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:titleRect];
    self.shimmeringView.shimmering = YES;   //start shimmering
    self.shimmeringView.shimmeringBeginFadeDuration = 0.2;
    self.shimmeringView.shimmeringOpacity = 0.5;
    self.shimmeringView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.shimmeringView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:_shimmeringView.bounds];
    self.titleLabel.text = [NSString stringWithFormat:@"Hello, %@",[User sharedInstance].profileName];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22];
    self.titleLabel.textColor = [UIColor whiteColor];
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    _shimmeringView.contentView = self.titleLabel;
    
    self.descriptionLabel = ({
        RQShineLabel *label = [[RQShineLabel alloc] initWithFrame:CGRectMake(LeftMargin+32, CGRectGetHeight(self.titleLabel.frame)+ 64, 100, 300)];
        label.numberOfLines = 0;
        label.text = @"Plan\n\n\n\nPolicy No.\n\n\n\nPhone No.\n\n\n\nWebsite";
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        //label.center = self.view.center;
        label.textColor = [UIColor whiteColor];
        label;
    });
    [self.view addSubview:self.descriptionLabel];

    self.denominator.text = [NSString stringWithFormat:@"%d", self.carriers.count];
    
    
    [User fetchPlansWithBlock:^(NSError *err, BOOL success,NSArray *carriers){
        
        if(success){
            NSLog(@"done! %d",carriers.count);
            self.carriers = carriers;
            
            //update all UI
            
            [self.bottomCollectionView reloadData];
        }else{
            
        }
        
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    //let shine label shine
    [self.descriptionLabel shine];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.shimmeringView.shimmering = NO;
    });
}

-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"will sub");
//    LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//    loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:loginVC animated:NO completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bottomCollectionView) {
        NSIndexPath *centerCellIndex = [self.bottomCollectionView indexPathForItemAtPoint:CGPointMake(CGRectGetMidX(self.bottomCollectionView.bounds) , CGRectGetMidY(self.bottomCollectionView.bounds))];
        
        Carrier *current = (Carrier*)[self.carriers objectAtIndex:centerCellIndex.row];
        self.currentCellHeader.text = [NSString stringWithFormat:@"%@", current.plan];
        self.policyLabel.text = current.policyNumber;
        self.phoneLabel.text = current.phoneNumber;
        self.webLabel.text = current.website;
        
        self.numerator.text = [NSString stringWithFormat:@"%d",centerCellIndex.row+1];
        
    }
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.carriers count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:[collectionCellIdentity copy] forIndexPath:indexPath];
        //cell.imageView = ((DECellData*)self.bottomCVDataSource[indexPath.item]).cellImageView;
    
        cell.titleLabel.text = ((Carrier*)[self.carriers objectAtIndex:indexPath.row]).plan;
        cell.backgroundColor = colors[indexPath.row%self.carriers.count];
    
        return cell;
}

- (IBAction)back:(id)sender {
    
    [User logOut];
    [GeneralControl transitionToVC:self withToVCStoryboardId:@"Login" withDuration:0.4];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
