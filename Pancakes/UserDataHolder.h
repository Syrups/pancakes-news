//
//  UserDataHolder.h
//  Pancakes
//
//  Created by Glenn Sonna on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>

@interface UserDataHolder : NSObject

+ (UserDataHolder *)sharedInstance;

@property (strong) User *user;
@property (strong) NSDictionary<FBGraphUser> *fbUSer;

- (void) saveData;
- (void) loadData;
- (void) loadFBUser;
- (void) loggoutFBUser;
+ (void) allowSynchronisation :(BOOL) allow;
+ (BOOL) isSyncAllowed ;

@end