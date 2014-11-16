//
//  PKNotificationManager.m
//  Pancakes
//
//  Created by Glenn Sonna on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "PKNotificationManager.h"
@import Foundation;
@import UIKit;

NSString *const PKNotification = @"PKNotification";

@implementation PKNotificationManager


+(void)initSynchronisationNotificationWithDay : (NSDate *) date{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = NSCalendarUnitDay;
    
    //NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *filename = [docsPath stringByAppendingPathComponent:PKNotification];
    //[NSKeyedArchiver archiveRootObject:localNotif toFile:filename];
}


+(id)loadSynchronisationNotifications{
    //return[NSKeyedUnarchiver unarchiveObjectWithFile:PKNotification];
    return [[UIApplication sharedApplication] scheduledLocalNotifications];
}

+(void)unloadSynchronisationNotifications : (UILocalNotification *)notification {
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

+ (NSString *) hourMinuteFormatForNotification : (UILocalNotification *)notif {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:notif.fireDate];
    return strDate;
}





@end
