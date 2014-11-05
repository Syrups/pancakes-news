//
//  MyFeedViewController.h
//  Pancakes
//
//  Created by Leo on 24/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"

@interface MyFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MainMenuDisplayer>

@property (strong, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) IBOutlet UIView *topBar;
@property (strong, nonatomic) IBOutlet UIImageView *selectedArticleCover;

@property (strong, nonatomic) IBOutlet UIButton *readButton;

@property (weak, nonatomic) IBOutlet MainMenuViewController *mainMenu;
@end
