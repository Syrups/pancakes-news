//
//  MainViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ChooseThemesViewController.h"
#import "MyFeedViewController.h"
#import "MainViewController.h"
#import "MainMenuViewController.h"
#import "SynchroViewController.h"
#import "UserDataHolder.h"
#import "Configuration.h"

@interface MainViewController ()
@property (nonatomic, strong) UIView *privateButtonsView; /// The view hosting the buttons of the child view controllers.
@property (nonatomic, strong) UIView *privateContainerView; /// The view hosting the child view controllers views.
@end

@implementation MainViewController {
    NSDictionary* titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
    self.view .opaque = YES;
    
    titles = @{
                @"10": @"My news",
                @"20": @"My profile",
                @"30": @"My interests",
                @"40": @"Synchronization"
            };
    
    self.viewControllers = @{
                             @"10": [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyFeedView"],
                             @"20": [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyProfileView"],
                             @"30": [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseThemesView"],
                             @"40": [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SynchroView"]
                             };
    
    [self createMainMenu];
    
    if (self.initialViewController == nil) {
        self.initialViewController = [self.viewControllers objectForKey:@"10"];
    }
    
    [self displayContentController:self.initialViewController];
    
    
}


#pragma mark - Menu

- (void) createMainMenu {
    
    float screenMidSize =self.view.frame.size.width/2;
    CGRect initFrame = CGRectMake(-screenMidSize, 0.0f, screenMidSize, self.view.frame.size.height);
    
    //Blur init
    self.blurView = [[FXBlurView alloc] init];
    self.blurView.blurRadius = 7;
    //self.blurView.dynamic = NO;
    self.blurView.tintColor = [UIColor blackColor];
    self.blurView.contentMode = UIViewContentModeRight;
    self.blurView.layer.contentsGravity = kCAGravityBottomLeft;
    [self.blurView setClipsToBounds:YES];
    [self.blurView updateAsynchronously:YES completion:^{
        self.blurView.frame = CGRectMake(0.0f, kMenuBarHeigth, 0.0f, self.view.frame.size.height - kMenuBarHeigth);
    }];
    
    MainMenuViewController* menuVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    [self addChildViewController:menuVc];
    menuVc.view.frame = initFrame;
    menuVc.blurView = self.blurView;
    
    [self.view addSubview:self.blurView];
    [self.view addSubview:menuVc.view];
    [menuVc didMoveToParentViewController:self];
    
    
    self.mainMenu = menuVc;
    self.mainMenu.toggleItem = self.menuItem;
    menuVc.delegate = self;
}


-(void) viewDidLayoutSubviews{
    
    float screenMidSize =self.view.frame.size.width/2;
    CGRect rect = [self.menuTopBar frame] ;
    rect.size.width = screenMidSize;
    [self.menuTopBar setFrame:rect];
    
}

-(void) menuDidSelectItem:(NSString *)tag{
    
    UIViewController* toController = [self.viewControllers objectForKey:tag] ;
    [self transitionToChildViewController:toController];
    
    self.currentSectionTitle.text = [titles objectForKey:tag];
    
    NSLog(@"%@", tag);
}


#pragma mark - Actions

- (IBAction)toggleMainMenu:(id)sender {
    [self.mainMenu toggle:sender];
    //[self.view bringSubviewToFront:self.menuItem];
}

#pragma mark - Show/hide logic

- (void) displayContentController: (UIViewController*) content
{
    [self addChildViewController:content];                 // 1
    content.view.frame = [self.childsContainer frame];      // 2
    [self.childsContainer addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
    self.currentViewController = content;
}


- (void) hideContentController: (UIViewController*) content
{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
}


- (void)transitionToChildViewController:(UIViewController *)toViewController {
    
    if (toViewController == self.currentViewController || ![self isViewLoaded]) {
        return;
    }
    
    [self hideContentController: self.currentViewController];
    [self displayContentController: toViewController];
}



@end
