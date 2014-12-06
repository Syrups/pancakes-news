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
    
    [self.pickerContainerTopSpace setConstant:self.view.frame.size.height];
    
    vals = @[@"19:00", @"7:00"];
    
     [self loadNotifications];
    //[self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];

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
    
    NSLog(@"cellForRowAtIndexPath %ld", (long)indexPath.row);
    
    // [cell setNeedsLayout];
    return cell;
}

- (void) hidePicker{

    [self.pickerContainer.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
       
        //Update
        
        [self.cancelButtonTopSpace setConstant:-30];
        [self.synchroTableTopSpace setConstant:0];
        [self.pickerContainerTopSpace setConstant:self.view.frame.size.height];
        
        //layout
        [self.pickerContainer.superview layoutIfNeeded];

    } completion:^(BOOL finished) {
         self.pickerContainer.hidden = YES;
    }];
}

- (void) showPicker{
    
    //BOOL
    self.pickerContainer.hidden = NO;
    
    //[self.view layoutIfNeeded];
    [self.pickerContainer.superview layoutIfNeeded];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //Update
        
        [self.cancelButtonTopSpace setConstant:30];
        [self.synchroTableTopSpace setConstant:-self.synchroTable.bounds.size.height + 250];
        [self.pickerContainerTopSpace setConstant:90];
        
        //layout
        [self.pickerContainer.superview layoutIfNeeded];
        
    } completion:nil];
}




- (void) loadNotifications{

    self.notifications = [PKNotificationManager loadSynchronisationNotifications];
}

- (IBAction)addTimeAction:(id)sender {
    
    //NSLog(@"%hhd",  self.pickerParent.hidden );
    
    if(self.pickerContainer.hidden){
        [self showPicker];
    
    }else{
        
        UILocalNotification *notif =  [PKNotificationManager initSynchronisationNotificationWithDay:self.datePicker.date];
        [self.notifications addObject:notif];
        [self hidePicker];
        
        [self.synchroTable reloadData];
        [self.synchroTable reloadInputViews];
    }
}

- (IBAction)cancelTransaction:(id)sender {
    [self hidePicker];
}


- (void)removeNotification:(UIButton*)sender{
    
    UILocalNotification *notif = [self.notifications objectAtIndex:sender.tag];
   
    [PKNotificationManager unloadSynchronisationNotifications:notif];
    [self.notifications removeObjectAtIndex:sender.tag];
    [self.synchroTable reloadData];
    [self.synchroTable reloadInputViews];
    
     NSLog(@"removeNotification %ld, %@", (long)sender.tag , [notif.fireDate description]);
}

@end
