//
//  UserDataHolder.m
//  Pancakes
//
//  Created by Glenn Sonna on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "UserDataHolder.h"
#import <UIKit/UIKit.h>
#import "Configuration.h"
#import "PKRestClient.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PKNotificationManager.h"

NSString * const PUSER = @"PancakesUser";
NSString * const PSYNC = @"PancakesSync";

@implementation UserDataHolder
- (id) init
{
    self = [super init];
    if (self)
    {
        self.user = [[User alloc] init];
    }
    return self;
}

+ (UserDataHolder *)sharedInstance {
    static UserDataHolder *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    
    return _sharedInstance;
}


-(void)saveData
{
    NSString *userAsJson = [self.user toJSONString];
    [[NSUserDefaults standardUserDefaults]setObject:userAsJson forKey:PUSER];
    
    //NSLog(@"saving %@", userAsJson);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //NSString *  createUser = [kApiRootUrl stringByAppendingString:@"/user/save"];
    /*[JSONHTTPClient postJSONFromURLWithString:createUser params:[self.user toDictionary] completion:^(id json, JSONModelError *err) {
        NSLog(@"saved to network %@", json);
    }];*/
    
}

-(void)loadData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:PUSER])
    {
        NSString *userAsJson  = [defaults objectForKey:PUSER];
        NSError* err ;
        self.user  =[[User alloc] initWithString:userAsJson error:&err];
        
        if (err) {
            NSLog(@"Unable to initialize User, %@", err.localizedDescription);
        }
        
        NSLog(@"user loaded %@", [self.user toJSONString]);
        //[self loadJsonFromNetworkParams:@{@"phantomId":self.user.phantomId}];
    }
    else
    {
        NSString *phantomId =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *userString = [NSString stringWithFormat:@"{\"phantomId\" : \"%@\", \"interests\" : []}", phantomId];
        NSError* err;
        
        self.user  =[[User alloc] initWithString:userString error:&err];
        
        if (err) {
            NSLog(@"Unable to initialize User, %@", err.localizedDescription);
        }
        
        NSLog(@"user first load %@", [self.user toJSONString]);
        //[self loadJsonFromNetworkParams:@{@"phantomId":phantomId}];
        
    }
}

- (void) loadJsonFromNetworkParams : (NSDictionary *) user {
    NSError* err ;
    
    //make post, get requests
    [PKRestClient getUserWithUser:user :^(id json, JSONModelError *jsonError) {
        self.user  =[[User alloc] initWithDictionary:[json objectForKey:@"data"] error:&jsonError];
        
        if (err) {
            NSLog(@"Unable to initialize User, %@", err.localizedDescription);
        }
        NSLog(@"user loaded from network %@", [self.user toJSONString]);
    }];
}


- (void) loadFBUser{
    
    NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
    //[note addObserver:self selector:@selector(viewReceivedFBUser:) name:@"FBUserLoaded" object:nil];

    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             self.fbUSer = user;
             [note postNotificationName:@"FBUserLoaded" object:user];
         }
     }];
}

- (void) loggoutFBUser{
    NSNotificationCenter *note = [NSNotificationCenter defaultCenter];
    //[note addObserver:self selector:@selector(viewReceivedFBUser:) name:@"FBUserLoggetOut" object:nil];
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    self.fbUSer = nil;
    
    [note postNotificationName:@"FBUserLoggetOut" object:self.fbUSer];
}

+ (void) allowSynchronisation :(BOOL) allow{
    
    if (allow) {
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        NSSet *categories = [NSSet setWithObjects:[PKNotificationManager withDefaultCategory], nil];
        
        
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:allow] forKey:PSYNC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) isSyncAllowed {
    
    NSNumber *value =  [[NSUserDefaults standardUserDefaults] objectForKey:PSYNC];
    BOOL isAllowed = [value boolValue];
    
    return isAllowed;
}

@end
