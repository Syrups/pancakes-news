//
//  SynchroViewController.h
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKSyrupButton.h"

@interface SynchroViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *synchroTable;
@property (weak, nonatomic) IBOutlet UIView *LeftInfoView;
@property (weak, nonatomic) IBOutlet UIView *LeftNestedView;
@property (strong, nonatomic) IBOutlet UILabel *infoText;


@property (weak, nonatomic) IBOutlet PKSyrupButton *synchButton;
@property (strong, nonatomic) IBOutlet UILabel *synchButtonLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainHeigth;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundRight;
@property (weak, nonatomic) IBOutlet PKSyrupButton *addTimeButton;
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *leftViewOverlay;

//Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerContainerTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *synchroTableTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonTopSpace;

@property NSMutableArray *notifications;

- (IBAction)addTimeAction:(id)sender;
- (IBAction)cancelTransaction:(id)sender;
- (IBAction)allowDisallowSync:(id)sender;

@end
