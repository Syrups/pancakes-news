//
//  UserDataHolder.m
//  Pancakes
//
//  Created by Glenn Sonna on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "UserDataHolder.h"
#import <UIKit/UIKit.h>
#import "JSONModel/JSONModelNetworking/JSONHTTPClient.h"
#import "Configuration.h"

NSString * const PUSER = @"PancakesUser";
NSString * const createUser = kApiRootUrl @"/user/create";

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
    NSString *userAsJson = [ self.user toJSONString];
    [[NSUserDefaults standardUserDefaults]setObject:userAsJson forKey:PUSER];
    
    NSLog(@"saving %@", userAsJson);
    
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
    [JSONHTTPClient postJSONFromURLWithString:createUser params:user completion:^(id json, JSONModelError *jsonError) {
        self.user  =[[User alloc] initWithDictionary:[json objectForKey:@"data"] error:&jsonError];
        
        if (err) {
            NSLog(@"Unable to initialize User, %@", err.localizedDescription);
        }
        NSLog(@"user loaded from network %@", [self.user toJSONString]);
    }];
}

@end
