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
    [[NSUserDefaults standardUserDefaults]
     setObject:userAsJson forKey:PUSER];
    
     NSLog(@"saving %@", userAsJson);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *  createUser = [kApiRootUrl stringByAppendingString:@"/user/save"];
    [JSONHTTPClient postJSONFromURLWithString:createUser params:[self.user toDictionary] completion:^(id json, JSONModelError *err) {
        NSLog(@"%@", json);
        
        //NSDictionary *j = [json toDictionary];
        
    }];
    
}

-(void)loadData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:PUSER])
    {
        NSString *userAsJson  = [defaults objectForKey:PUSER];
        NSError* err = nil;
        self.user  =[[User alloc] initWithString:userAsJson error:&err];
        
        NSLog(@"user loaded %@", userAsJson);
        
        NSString *  createUser = [kApiRootUrl stringByAppendingString:@"/user/create"];
        [JSONHTTPClient postJSONFromURLWithString:createUser params:@{@"phantom_id":self.user.phantomId} completion:^(id json, JSONModelError *err) {
            NSLog(@"%@", json);
            
            NSDictionary *j = [json toDictionary];
            
        }];
        
    }
    else
    {
        NSString *  createUser = [kApiRootUrl stringByAppendingString:@"/user/create"];
        
        NSString *phantomId =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *userString = [NSString stringWithFormat:@"{phantom_id : %@}", phantomId];
        NSError* err = nil;
        
        self.user  =[[User alloc] initWithString:userString error:&err];
        NSLog(@"user first load %@", userString);
        
        
        //make post, get requests
        [JSONHTTPClient postJSONFromURLWithString:createUser params:@{@"phantom_id":phantomId} completion:^(id json, JSONModelError *err) {
            NSLog(@"%@", json);
        }];
    }
}
@end
