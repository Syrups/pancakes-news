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


+(UILocalNotification *)initSynchronisationNotificationWithDay : (NSDate *) date{
    
    UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    NSSet *categories = [NSSet setWithObjects:[PKNotificationManager withDefaultCategory], [PKNotificationManager withDefaultCategory], nil];

   
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = NSCalendarUnitDay;
    localNotif.alertBody = @"Time to fap !";
    //localNotif.soundName = UILocalNotificationDefaultSoundName;
    
   
    [[UIApplication sharedApplication] scheduleLocalNotification: localNotif];
    [[UIApplication sharedApplication] presentLocalNotificationNow: localNotif];
    
    NSLog(@"PKNotificationManager new notif : %@", [date description]);
    
    return localNotif;
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
    
    //NSLog(@"%@", strDate);
    return strDate;
}




+ (UIMutableUserNotificationAction *) withPKDefaultNotificationYESAction {
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    // Define an ID string to be passed back to your app when you handle the action
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    
    // Localized string displayed in the action button
    acceptAction.title = @"Fap !";
    
    // If you need to show UI, choose foreground
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    
    // Destructive actions display in red
    acceptAction.destructive = NO;
    
    // Set whether the action requires the user to authenticate
    acceptAction.authenticationRequired = NO;
    
    return acceptAction;
}


+ (UIMutableUserNotificationAction *) withPKDefaultNotificationNOAction {
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    // Define an ID string to be passed back to your app when you handle the action
    acceptAction.identifier = @"REFUSE_IDENTIFIER";
    
    // Localized string displayed in the action button
    acceptAction.title = @"No !";
    
    // If you need to show UI, choose foreground
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    
    // Destructive actions display in red
    acceptAction.destructive = YES;
    
    // Set whether the action requires the user to authenticate
    acceptAction.authenticationRequired = NO;
    
    return acceptAction;
}

+ (UIMutableUserNotificationCategory *) withDefaultCategory {
    // First create the category
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    UIMutableUserNotificationAction *yesAction = [PKNotificationManager withPKDefaultNotificationYESAction];
    UIMutableUserNotificationAction *noAction = [PKNotificationManager withPKDefaultNotificationNOAction];
    
    // Identifier to include in your push payload and local notification
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    // Add the actions to the category and set the action context
    [inviteCategory setActions:@[yesAction,noAction] forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to present in a minimal context
    [inviteCategory setActions:@[yesAction, noAction] forContext:UIUserNotificationActionContextMinimal];
    
    
    return inviteCategory;
}





@end
