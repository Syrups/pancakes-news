//
//  MyProfileViewController.h
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PKSyrupButton.h"

@interface MyProfileViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIView *profilePictureOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *profileAsRightBackground;
@property (weak, nonatomic) IBOutlet PKSyrupButton *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *tableViewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *signInOutLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileAsRightBackgroundY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTitleLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePictureConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedArticleTrailingConstraint;
- (IBAction)loginButtonTouched:(id)sender;
@end
