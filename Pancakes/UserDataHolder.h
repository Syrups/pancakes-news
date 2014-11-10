//
//  UserDataHolder.h
//  Pancakes
//
//  Created by Glenn Sonna on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserDataHolder : NSObject

+ (UserDataHolder *)sharedInstance;

@property (strong) User *user;

-(void) saveData;
-(void) loadData;

@end