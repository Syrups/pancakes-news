//
//  MyProfileViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "MyProfileViewController.h"
#import "Configuration.h"
#import "UserDataHolder.h"


@implementation MyProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    int screenMidSize = self.view.frame.size.width/2;
    
 
   
    self.profilePicture  = [[FBProfilePictureView alloc] initWithFrame:CGRectMake(0, kMenuBarHeigth + self.view.frame.size.height, screenMidSize, self.view.frame.size.height - kMenuBarHeigth)];
 
    
    self.profilePicture.contentMode = UIViewContentModeTopLeft;
    //self.profilePicture.
    //self.profilePicture.clipsToBounds = YES;
   //self.profilePicture.layer.contentsRect = CGRectMake(0.0, 0.0, 0, 0);
    
    self.synchroTable = [[UITableView alloc] initWithFrame:CGRectMake(screenMidSize*2, 0, screenMidSize, self.view.frame.size.height)];
    
    
    //self.profilePicture.profileID
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.synchroTable];
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    
    if( [UserDataHolder sharedInstance].fbUSer) {
        [self setUpFacebookUserInfo];
    }else{
         [self setUpFacebookUserNil];
    }
    
    int screenMidSize = self.view.frame.size.width/2;
    self.profilePicture.frame = CGRectMake(0, kMenuBarHeigth + self.view.frame.size.height, screenMidSize, self.view.frame.size.height - kMenuBarHeigth);
    self.synchroTable.frame = CGRectMake(self.view.frame.size.width, 0, screenMidSize, self.view.frame.size.height);
    
    CGRect f1 = CGRectMake(0, kMenuBarHeigth, self.view.frame.size.width/2, self.view.frame.size.height);
    CGRect f2 = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, self.view.frame.size.height);

        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.synchroTable.frame = f2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4f  delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^() {
                self.profilePicture.frame = f1;
            } completion:nil];
        }];
    [self.view bringSubviewToFront: self.loginButton];
    [self.view bringSubviewToFront: self.userName];
}

#pragma Facebook

// This method will be called when the user information has been fetched
- (void)setUpFacebookUserInfo{
    NSDictionary<FBGraphUser> *user  = [UserDataHolder sharedInstance].fbUSer;
    self.profilePicture.profileID = user.objectID;
    self.userName.text = user.name;
    
    [self.loginButton  setTitle: @"loggOut" forState:UIControlStateNormal];
}

- (void)setUpFacebookUserNil{
    self.profilePicture.profileID = nil;
    self.userName.text = @"";
   //NSLocalizedString(menuNames[index], nil)
    [self.loginButton  setTitle: @"loggin" forState:UIControlStateNormal];
    
}




- (IBAction)loginButtonTouched:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}


@end
