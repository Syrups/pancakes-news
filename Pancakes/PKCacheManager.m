//
//  PKCacheManager.m
//  Pancakes
//
//  Created by Glenn Sonna on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "PKCacheManager.h"
#import "ThemeInterest.h"
NSString * const PINTERESTS = @"PancakesIntrests";
NSString * const PLASTREADS = @"PancakesLastReads";
NSString * const PFEED = @"PancakesFeed";

@implementation PKCacheManager

- (id) init
{
    self = [super init];
    if (self)
    {
        //self.user = [[User alloc] init];
    }
    return self;
}

+ (PKCacheManager *)sharedInstance {
    static PKCacheManager *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    
    return _sharedInstance;
}

#pragma Interests

+(void) cacheIntrests: (NSMutableArray *) interests{
    
    NSArray *toSave = [ThemeInterest arrayOfDictionariesFromModels:interests];
    [[NSUserDefaults standardUserDefaults]setObject:toSave forKey:PINTERESTS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id) loadInterestsFromCache{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:PINTERESTS]){
        
        
        return [ThemeInterest arrayOfModelsFromDictionaries:[[NSUserDefaults standardUserDefaults] objectForKey:PINTERESTS]];
    }else{
    
        return [[NSMutableArray alloc] init];
    }
}


#pragma Articles - LastRead
+(void) saveLastReadArticle :(Article *) article{
    
    NSMutableArray * lastReads = [PKCacheManager loadLastReadArticles];
    [lastReads addObject:[article toDictionary]];
    
    [[NSUserDefaults standardUserDefaults]setObject:lastReads forKey:PLASTREADS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSMutableArray *) loadLastReadArticles{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:PLASTREADS]){
        
        return [Article arrayOfModelsFromDictionaries:[[NSUserDefaults standardUserDefaults] objectForKey:PLASTREADS]];
    }else{
        
        return [[NSMutableArray alloc] init];
    }
}


#pragma Articles - Feed

+(void) cacheFeed :(NSArray *) feed{
    
    NSArray *toSave = [Article arrayOfDictionariesFromModels:feed];
    
    [[NSUserDefaults standardUserDefaults]setObject:toSave forKey:PFEED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray *) loadCachedFeed{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:PFEED]){
        
        return [Article arrayOfModelsFromDictionaries:[[NSUserDefaults standardUserDefaults] objectForKey:PFEED]];
    }else{
        
        return [[NSArray alloc] init];
    }
}


#pragma Synchro

+(void) synchonizationRoutine {
    
}

@end
