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
#import "ArticleViewController.h"
#import "MainViewController.h"
#import "MyFeedViewController.h"
#import <UIImageView+WebCache.h>

@implementation MyProfileViewController {
    NSArray* feedArticles;
    Article* selectedArticle;
    UIView *profilePictureShadow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePicture.clipsToBounds = YES;
    
    self.loginButton.switchMode = NO;
    self.loginButton.innerImageColor = [UIColor whiteColor];

    self.tableViewTitleLabelHeightConstraint.constant = kMenuBarHeigth;
    
    self.feedTableView.backgroundColor = [UIColor clearColor];
    self.feedTableView.separatorColor = [UIColor clearColor];
    
    NSNotificationCenter *userFB = [NSNotificationCenter defaultCenter];
    [userFB addObserver:self selector:@selector(setUpFacebookUserInfo:) name:@"FBUserLoaded" object:nil];
    [userFB addObserver:self selector:@selector(setUpFacebookUserNil:) name:@"FBUserLoggetOut" object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if(!profilePictureShadow){
        profilePictureShadow = [Utils addDropShadowToView:self.profilePicture];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    
    feedArticles = [PKCacheManager loadLastReadArticles].copy;
    
    if( [UserDataHolder sharedInstance].fbUSer) {
        
        [self setUpFacebookUserInfo];
    }else{
        
        [self setUpFacebookUserNil];
    }
    
    [self.profilePictureConstraint setConstant:self.view.frame.size.height];
    [self.feedArticleTrailingConstraint setConstant:-self.view.frame.size.width * 0.5];
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [self.feedArticleTrailingConstraint setConstant:-16];
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.4f  delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^() {
            
            [self.profilePictureConstraint setConstant:kMenuBarHeigth];
            
            [self.view layoutIfNeeded];
        } completion:nil];
        
    }];
    
    [self.profilePicture.superview layoutIfNeeded];
    
    self.tableViewTitleLabel.text = NSLocalizedString(@"LastViewedTitle", nil);
    
}

#pragma Facebook

- (void)setUpFacebookUserInfo{
    [self setUpFacebookUserInfo:nil];
}

- (void)setUpFacebookUserNil{
    [self setUpFacebookUserNil: nil];
}

// This method will be called when the user information has been fetched
- (void)setUpFacebookUserInfo :(NSNotification *)note{
    NSDictionary<FBGraphUser> *user  = [UserDataHolder sharedInstance].fbUSer;
    [Utils setImageWithFacebook:user imageview:self.profilePicture blur:NO] ;
    [Utils setImageWithFacebook:user imageview:self.profileAsRightBackground blur:YES] ;
    self.userName.text = user.name;

    [self.signInOutLabel  setText:@"Sign out"];
    self.loginButton.innerImageType = PKSyrupButtonTypeX;
}

- (void)setUpFacebookUserNil:(NSNotification *)note{
    [Utils setPlaceHolderImage:self.profilePicture blur:NO];
    [Utils setPlaceHolderImage:self.profileAsRightBackground blur:YES] ;
    self.userName.text = @"Log in";
    
    [self.signInOutLabel  setText:@"Sign in"];
    self.loginButton.innerImageType = PKSyrupButtonTypePlus;

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
             
             /*if (!error && state == FBSessionStateOpen){
                 NSLog(@"Profile opened");
                 // Show the user the logged-in UI
                 //[[UserDataHolder sharedInstance] loadFBUser];
                 [self setUpFacebookUserInfo];
             }
             
             if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
                 // If the session is closed
                 NSLog(@"Profile closed");
                 //[[UserDataHolder sharedInstance] loggoutFBUser];
                 // Show the user the logged-out UI
                 [self setUpFacebookUserNil];
             }*/
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Article* article = [feedArticles objectAtIndex:[indexPath row]];

    [self displaySelectedArticle:article];
}


- (void)displaySelectedArticle:(Article*)article {
    
   MainViewController* parent = (MainViewController*)self.parentViewController; // get the main view controller
//
//        UINavigationController* feedVc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MyFeedView"];
//        //                [feedVc setViewControllers:@[vc]];
//        
//        [parent displayContentController:feedVc];
//        
//        ArticleViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ArticleViewController"];
//        vc.displayedArticle = article;
//        vc.articleCoverImage = [[UIImageView alloc] initWithFrame:self.view.frame];
//        [vc.articleCoverImage sd_setImageWithURL:[NSURL URLWithString:article.coverImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image != nil) {
//                MyFeedViewController* feed = (MyFeedViewController*)feedVc.viewControllers[0];
//                [feed displaySelectedArticle:nil];
//            }
//        }];
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect f = parent.menuTopBar.frame;
        f.origin.x -= self.view.frame.size.width/2;
        [parent.menuTopBar setFrame:f];
        f = parent.menuItem.frame;
        f.origin.x -= self.view.frame.size.width/2;
        [parent.menuItem setFrame:f];
    } completion:^(BOOL finished) {
        
        ArticleViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ArticleViewController"];
        vc.displayedArticle = article;
        vc.articleCoverImage = [[UIImageView alloc] initWithFrame:self.view.frame];
        [vc.articleCoverImage sd_setImageWithURL:[NSURL URLWithString:selectedArticle.coverImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                UINavigationController* feedVc = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MyFeedView"];
//                [feedVc setViewControllers:@[vc]];
                
                [parent displayContentController:feedVc];
            }
        }];
    }];
}


@end
