//
//  MainMenuViewController.h
//  Pancakes
//
//  Created by Leo on 05/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

// All view controllers that can display the main menu
// must implement this procotol
@protocol MainMenuDisplayer <NSObject>

@required
- (void) closeMainMenu;
- (void) mainMenuDidSelectViewController:(UIViewController*)viewController;

@end

@interface MainMenuViewController : UIViewController

// This is a the view controller the stands below the main menu view,
// i.e the current view
@property (strong, nonatomic) UIViewController<MainMenuDisplayer>* currentViewController;

- (void) animateOpening;
- (void) animateClosing;

@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *interestsButton;
@property (weak, nonatomic) IBOutlet UIButton *synchronizationButton;


@end


