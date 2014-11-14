//
//  PKNotificationManager.m
//  Pancakes
//
//  Created by Glenn Sonna on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "PKNotificationManager.h"
@import UIKit;

@implementation PKNotificationManager


-(void)initSynchronisationNotificationWithDay : (NSDate *) date{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = NSCalendarUnitDay;
}


@end
