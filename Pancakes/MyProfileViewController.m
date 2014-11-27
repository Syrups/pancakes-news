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
#import "Services.h"
#import <UIImageView+WebCache.h>



@implementation MyProfileViewController {
    NSArray* feedArticles;
    Article* selectedArticle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    int screenMidSize = self.view.frame.size.width/2;
    
    self.profilePicture  = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMenuBarHeigth + self.view.frame.size.height, screenMidSize, self.view.frame.size.height - kMenuBarHeigth)];
    
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePicture.clipsToBounds = YES;
    
    self.feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, kMenuBarHeigth, screenMidSize, self.view.frame.size.height)];
    
    self.tableViewTitleLabelHeightConstraint.constant = kMenuBarHeigth;
    
    self.feedTableView.delegate = self;
    self.feedTableView.dataSource = self;
    self.feedTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.feedTableView];
    
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    
    if( [UserDataHolder sharedInstance].fbUSer) {
        [self setUpFacebookUserInfo];
    }else{
         [self setUpFacebookUserNil];
    }
    
    int screenMidSize = self.view.frame.size.width/2;
    self.profilePicture.frame = CGRectMake(0, kMenuBarHeigth + self.view.frame.size.height, screenMidSize, self.view.frame.size.height - kMenuBarHeigth);
    self.feedTableView.frame = CGRectMake(self.view.frame.size.width, kMenuBarHeigth, screenMidSize, self.view.frame.size.height);
    
    CGRect f1 = CGRectMake(0, kMenuBarHeigth, self.view.frame.size.width/2, self.view.frame.size.height - kMenuBarHeigth);
    CGRect f2 = CGRectMake(screenMidSize, kMenuBarHeigth, self.view.frame.size.width/2, self.view.frame.size.height - kMenuBarHeigth);

        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.feedTableView.frame = f2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4f  delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^() {
                self.profilePicture.frame = f1;
            } completion:nil];
        }];
    
    self.tableViewTitleLabel.text = NSLocalizedString(@"LastViewedTitle", nil);
    [self.view bringSubviewToFront: self.loginButton];
    [self.view bringSubviewToFront: self.userName];
}

#pragma Facebook

// This method will be called when the user information has been fetched
- (void)setUpFacebookUserInfo{
    NSDictionary<FBGraphUser> *user  = [UserDataHolder sharedInstance].fbUSer;
    [Utils setImageWithFacebook:user imageview:self.profilePicture blur:NO] ;
    [Utils setImageWithFacebook:user imageview:self.profileAsRightBackground blur:YES] ;
    self.userName.text = user.name;
    
    [self.loginButton  setTitle: @"loggOut" forState:UIControlStateNormal];
}

- (void)setUpFacebookUserNil{
    [Utils setPlaceHolderImage:self.profilePicture blur:NO];
    [Utils setPlaceHolderImage:self.profileAsRightBackground blur:YES] ;
    self.userName.text = @"";
   //NSLocalizedString(LastViewedTitle, nil)
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedArticles count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:@"FeedArticleCell"];
    cell.contentView.backgroundColor = kArticleViewBlockBackground;
    
    Article* article = [feedArticles objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedArticleCell"];
    }
    
    UIView* overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height/3)];
    overlay.tag = 5;
    overlay.backgroundColor = RgbaColor(0, 0, 0, 0.6f);
    overlay.hidden = YES;
    [cell.contentView addSubview:overlay];
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.text = article.title;
    feedCellTitle.font = [UIFont fontWithName:kFontBreeBold size:15];
    feedCellTitle.textColor = kFeedViewListTitleColor;
    
    UIImageView* feedCellThumb = (UIImageView*)[cell.contentView viewWithTag:20];
    [feedCellThumb setFrame:CGRectMake(feedCellThumb.frame.origin.x, feedCellThumb.frame.origin.y, cell.frame.size.width/3.5, cell.frame.size.height)];
    [feedCellThumb sd_setImageWithURL:[NSURL URLWithString:article.coverImage]];
    feedCellThumb.clipsToBounds = YES;
    feedCellThumb.layer.masksToBounds = YES;
    
    UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:50];
    themeTitle.textColor = [Utils colorWithHexString:article.color];
    
    UIImageView* check = [[UIImageView alloc] initWithFrame:CGRectMake(38.0f, 40.0f, 22.0f, 15.0f)];
    check.image = [UIImage imageNamed:@"check_item"];
    check.tintColor = [UIColor whiteColor];
    check.contentMode = UIViewContentModeScaleAspectFit;
    check.tag = 50;
    check.alpha = 0.0f;
    
    UIImageView* zigzag = (UIImageView*)[cell.contentView viewWithTag:60];
    zigzag.image = [zigzag.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [zigzag setTintColor:[Utils colorWithHexString:article.color]];
    
    [overlay addSubview:check];
    
    [cell setNeedsLayout];
    
    return cell;
}


@end
