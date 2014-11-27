//
//  MyProfileViewController.h
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MyProfileViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIImageView *profileAsRightBackground;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *tableViewTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileAsRightBackgroundY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTitleLabelHeightConstraint;
- (IBAction)loginButtonTouched:(id)sender;
@end
