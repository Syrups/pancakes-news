//
//  PKNotificationManager.h
//  Pancakes
//
//  Created by Glenn Sonna on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface PKNotificationManager : NSObject


+(void)initSynchronisationNotificationWithDay : (NSDate *) date;

+(id)loadSynchronisationNotifications;
+(void)unloadSynchronisationNotifications : (UILocalNotification *)notification ;

+ (NSString *) hourMinuteFormatForNotification : (UILocalNotification *)notif;

@end
