//
//  SynchroViewController.h
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SynchroViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *synchroTable;
@property (weak, nonatomic) IBOutlet UIView *LeftInfoView;
@property (weak, nonatomic) IBOutlet UIView *LeftNestedView;
@property (strong, nonatomic) IBOutlet UILabel *infoText;

@property (strong, nonatomic) IBOutlet UIButton *synchButton;
@property (strong, nonatomic) IBOutlet UILabel *synchButtonLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainHeigth;
@property (strong, nonatomic) IBOutlet UIImageView *background;

@end
