//
//  SynchroViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "SynchroViewController.h"
#import "Configuration.h"
#import "PKNotificationManager.h"
#import "FXBlurView.h"

NSArray *vals ;

@implementation SynchroViewController


- (void)viewDidLoad {
    [super viewDidLoad];


    self.infoText.text = NSLocalizedString(@"SynchDescription", nil);
    self.background.image = [[UIImage imageNamed:@"glenn"]  blurredImageWithRadius:20.0f iterations:5 tintColor:[UIColor clearColor]];
    self.backgroundRight.image = [[UIImage imageNamed:@"glenn"] blurredImageWithRadius:20.0f iterations:1 tintColor:[UIColor blackColor]];
    self.constraintY.constant = kMenuBarHeigth;
    
    vals = @[@"19:00", @"7:00"];
    
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.synchroTable dequeueReusableCellWithIdentifier:@"SynchroCell"];
    //cell.contentView.backgroundColor = kArticleViewBlockBackground;
    
    //Article* article = [feedArticles objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SynchroCell"];
    }
    
    UILocalNotification *n = [self.notifications objectAtIndex:indexPath.row];
    UILabel* cellTime = (UILabel*)[cell.contentView viewWithTag:10];
    UIButton *cellButton = (UIButton *)[cell.contentView viewWithTag:20];
    
    cellTime.text = [PKNotificationManager hourMinuteFormatForNotification: n];
    
    cellButton.tag = indexPath.row;
    [cellButton addTarget:self action:@selector(removeNotification:) forControlEvents:UIControlEventTouchUpInside];
    
    // [cell setNeedsLayout];
    return cell;
}


- (IBAction)addTimeAction:(id)sender {
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //self.pickerParent.alpha = self.pickerParent.hidden;
        self.pickerParent.hidden =  !self.pickerParent.hidden;
        NSLog(@"%hhd",  self.pickerParent.hidden );
        
    } completion:^(BOOL finished) {
       
    }];
}


- (IBAction)addSynchroDate:(id)sender {
    
    [PKNotificationManager initSynchronisationNotificationWithDay:self.datePicker.date];
    
}

- (void) loadNotifications{

    self.notifications = [PKNotificationManager loadSynchronisationNotifications];
}

- (void)removeNotification:(UIButton*)sender{
    
    [PKNotificationManager unloadSynchronisationNotifications:[self.notifications objectAtIndex:sender.tag]];
}

@end
