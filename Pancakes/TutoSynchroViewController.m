//
//  TutoSynchroViewController.m
//  Pancakes
//
//  Created by Leo on 03/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "TutoSynchroViewController.h"
#import "MainViewController.h"
#import "Configuration.h"
#import "UserDataHolder.h"
#import "PKNotificationManager.h"

@implementation TutoSynchroViewController

- (void)viewDidLoad {
    
    // skip tuto if setting present
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kPancakesTutoSynchroCookie] != nil) {
        UIViewController* mainVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TutoThemes"];
        [self.navigationController pushViewController:mainVc animated:NO];
    }
}

- (IBAction)yes:(id)sender {
    UIViewController* mainVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TutoThemes"];
    
    [self.navigationController pushViewController:mainVc animated:NO];
    
    NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]]; // gets the year, month, day,hour and minutesfor today's date
    [components setHour:8];
    [components setMinute:0];
    
    [PKNotificationManager initSynchronisationNotificationWithDay:[calendar dateFromComponents:components]];
    
    [UserDataHolder allowSynchronisation:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kPancakesTutoSynchroCookie];
}

- (IBAction)no:(id)sender {
    UIViewController* mainVc = [self.storyboard instantiateViewControllerWithIdentifier:@"TutoThemes"];
    
    [self.navigationController pushViewController:mainVc animated:NO];

    
    [UserDataHolder allowSynchronisation:NO];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kPancakesTutoSynchroCookie];
}

@end
