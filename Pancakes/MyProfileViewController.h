//
//  MyProfileViewController.h
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MyProfileViewController : UIViewController  <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *synchroTable;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
- (IBAction)loginButtonTouched:(id)sender;
@end
