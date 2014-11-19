//
//  MainViewController.h
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@import UIKit;
@import Foundation;

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"


@interface MainViewController : UIViewController <MainMenuDelegate>
/// The view controllers currently managed by the container view controller.
@property (weak, nonatomic) IBOutlet UIView *menuTopBar;
@property (weak, nonatomic) IBOutlet UIView *childsContainer;
@property (nonatomic, copy) NSDictionary *viewControllers;


/// The currently selected and visible child view controller.
@property (nonatomic, assign) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UILabel *currentSectionTitle;
@property (weak, nonatomic) IBOutlet MainMenuViewController *mainMenu;

@property (weak, nonatomic) IBOutlet UIView *menuItem;
@property (strong, nonatomic) IBOutlet FXBlurView *blurView;

@end
