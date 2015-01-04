//
//  SynchroViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "SynchroViewController.h"
#import "Configuration.h"
#import "FXBlurView.h"
#import "Services.h"


@implementation SynchroViewController{
    UIView *backgroundShadow;
}


- (void)viewDidLoad {
    [super viewDidLoad];


    self.infoText.text = NSLocalizedString(@"SynchDescription", nil);
    //self.background.image = [[UIImage imageNamed:@"glenn"]  blurredImageWithRadius:20.0f iterations:5 tintColor:[UIColor clearColor]];
    //self.backgroundRight.image = [[UIImage imageNamed:@"glenn"] blurredImageWithRadius:20.0f iterations:1 tintColor:[UIColor blackColor]];
    
    self.constraintY.constant = kMenuBarHeigth;
    
    [self.pickerContainerTopSpace setConstant:self.view.frame.size.height];
    
    
    self.addTimeButton.switchMode = NO;
    [self.addTimeButton setInnerImageColor:[UIColor whiteColor]];
    [self.addTimeButton setBackgroundColor:RGB(255, 109, 12)];
    [self.addTimeButton setInnerImageType:PKSyrupButtonTypePlus];
    
    //SynchButton style
    [self.synchButton setInnerImageColor:[UIColor whiteColor]];
    [self.synchButton setBackgroundColor:[UIColor clearColor] ];
    [self.synchButton setBorderColor:RGB(255, 109, 12)];
    
    
    [self.synchroTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.synchroTable setSeparatorColor:[UIColor clearColor]];
    
    
    
    //ff6d0c
    
    [self loadNotifications];
    //[self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(!backgroundShadow){
        backgroundShadow = [Utils addDropShadowToView:self.background];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    if( [UserDataHolder sharedInstance].fbUSer) {
        
        [self setUpFacebookUserInfo];
    }else{
        
        [self setUpFacebookUserNil];
    }
}


- (void)setUpFacebookUserInfo{
    NSDictionary<FBGraphUser> *user  = [UserDataHolder sharedInstance].fbUSer;
    [Utils setImageWithFacebook:user imageview:self.background blur:NO] ;
    [Utils setImageWithFacebook:user imageview:self.backgroundRight blur:YES] ;
}

- (void)setUpFacebookUserNil{
    [Utils setPlaceHolderImage:self.background blur:NO];
    [Utils setPlaceHolderImage:self.backgroundRight blur:YES] ;
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
    PKSyrupButton *cellButton = (PKSyrupButton *)[cell.contentView viewWithTag:20];
    
    
    cellButton.switchMode = NO;
    
    [cellButton setBorderColor:[UIColor whiteColor]];
    [cellButton setBackgroundColor:[UIColor whiteColor]];
    [cellButton setInnerImageColor:[UIColor blackColor]];
    [cellButton setInnerImageType:PKSyrupButtonTypeX];
    
    cellTime.text = [PKNotificationManager hourMinuteFormatForNotification: n];
    
    cellButton.tag = indexPath.row;
    [cellButton addTarget:self action:@selector(removeNotification:) forControlEvents:UIControlEventTouchUpInside];
    
    //NSLog(@"cellForRowAtIndexPath %ld", (long)indexPath.row);
    
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
        
        self.leftViewOverlay.alpha = 0;
        
        //layout
        [self.pickerContainer.superview layoutIfNeeded];

    } completion:^(BOOL finished) {
        self.pickerContainer.hidden = YES;
        self.leftViewOverlay.hidden = YES;
    }];
}

- (void) showPicker{
    
    //BOOL
    self.pickerContainer.hidden = NO;
    self.leftViewOverlay.hidden = NO;
    

    [self.pickerContainer.superview layoutIfNeeded];
    
    
    NSInteger factor = [self.notifications count] * 70;
    
    //NSLog(@"factor : %ld, notif : %ld", (long)factor, [self.notifications count]);
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //Update
        
        [self.cancelButtonTopSpace setConstant:15];
        [self.synchroTableTopSpace setConstant:kMenuBarHeigth + factor]; // - factor - 60
        [self.pickerContainerTopSpace setConstant:90];
        
        //NSLog(@"factor : %f", self.synchroTable.superview.frame.size.height);
        
        self.leftViewOverlay.alpha = 0.7;
        
        //layout
        [self.pickerContainer.superview layoutIfNeeded];
        
    } completion:nil];
}

- (void) loadNotifications{

    self.notifications = [PKNotificationManager loadSynchronisationNotifications];
}

- (void)removeNotification:(UIButton*)sender{
    
    UILocalNotification *notif = [self.notifications objectAtIndex:sender.tag];
    
    [PKNotificationManager unloadSynchronisationNotifications:notif];
    [self.notifications removeObjectAtIndex:sender.tag];
    [self.synchroTable reloadData];
    [self.synchroTable reloadInputViews];
    
    NSLog(@"removeNotification %ld, %@", (long)sender.tag , [notif.fireDate description]);
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

- (IBAction)allowDisallowSync:(PKSyrupButton *)sender {
    
    [UserDataHolder allowSynchronisation:sender.isOn];
}

@end
