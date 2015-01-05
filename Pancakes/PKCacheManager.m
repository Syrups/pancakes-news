//
//  PKCacheManager.m
//  Pancakes
//
//  Created by Glenn Sonna on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "PKCacheManager.h"
#import "ThemeInterest.h"
NSString * const PINTERESTS = @"PancakesInterests";
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



#pragma Generics
+(BOOL) cacheDataWithArray:(NSArray *) array inFile:(NSString *)fileName{
    
    NSString *path =[self pathFormPlitsWithName:fileName];
    
    BOOL done = [array writeToFile:path atomically:YES];
    
    return done;
}

+(id) loadDataFromFile:(NSString *)fileName intoJSONModel:(Class) model{
    
    NSArray *interests = [NSArray arrayWithContentsOfFile:[self pathFormPlitsWithName:fileName]];
    
    if (!interests){
        
        return [[NSMutableArray alloc] init];
    }
    return [model arrayOfModelsFromDictionaries:interests];
}

#pragma Interests
+(void) cacheIntrests: (NSMutableArray *) interests{
    
    [self cacheDataWithArray:interests inFile:PINTERESTS];
}

+(id) loadInterestsFromCache{
    
    NSArray *interests = [NSArray arrayWithContentsOfFile:[self pathFormPlitsWithName:PINTERESTS]];
    
    if (!interests){
        
        return [[NSMutableArray alloc] init];
    }
    
    return [ThemeInterest arrayOfModelsFromDictionaries:interests];
}

#pragma Articles - LastRead
+(void) saveLastReadArticle :(Article *) article{
    
    NSString *path =[self pathFormPlitsWithName:PLASTREADS];
    
    NSMutableArray * lastReads = [Article arrayOfDictionariesFromModels:[PKCacheManager loadLastReadArticles]];
    //[self preventFomDoubleInArray:lastReads withObject:[article toDictionary]];
    
    [lastReads addObject:[article toDictionary]];
    [lastReads writeToFile:path atomically:YES];
}

+(NSMutableArray *) loadLastReadArticles{
    
    NSArray *last = [NSArray arrayWithContentsOfFile:[self pathFormPlitsWithName:PLASTREADS]];
    
    if (!last){
        
        return [[NSMutableArray alloc] init];
    }
    
    return [Article arrayOfModelsFromDictionaries:last];
}

+(NSArray *)preventFomDoubleInArray: (NSMutableArray *) originalArrayOfItems withObject :(NSDictionary *) object{
    NSMutableArray *discardedItems = [NSMutableArray array];
    NSDictionary *item;
    
    for (item in originalArrayOfItems) {
        if ([[item objectForKey:@"_id"] isEqualToString:[object objectForKey:@"_id"]])
            [discardedItems addObject:item];
    }
    
    [originalArrayOfItems removeObjectsInArray:discardedItems];
    
    return discardedItems;
}

#pragma Articles - Feed

+(void) cacheFeed :(NSArray *) feed{
    [self cacheDataWithArray:feed inFile:PFEED];
}

+(NSArray *) loadCachedFeed{
    
    NSArray *last = [NSArray arrayWithContentsOfFile:[self pathFormPlitsWithName:PFEED]];
    
    if (!last){
        
        return [[NSMutableArray alloc] init];
    }
    return [Article arrayOfModelsFromDictionaries:last];
}


#pragma Synchro

+(void) synchonizationRoutine {
    UserDataHolder* holder = [UserDataHolder sharedInstance];
    [holder loadData];
    
    NSString* feedUrl = @"";
    
    if (holder.user._id != nil) {
        NSString* userId = holder.user._id;
        feedUrl = [NSString stringWithFormat:[PKRestClient apiUrlWithRoute:@"/user/%@/feed"], userId];
    } else {
        // if no user, use public articles feed
        feedUrl = [PKRestClient apiUrlWithRoute:@"/articles"];
    }
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:feedUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* err = nil;
        NSArray* feedArticles = [Article arrayOfModelsFromData:data error:&err];
        [self cacheFeed:feedArticles];
    }] resume];
}

+(NSString *)pathFormPlitsWithName: (NSString *) name {
    
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [doc stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.plist",name]];
    
    return path;
}

@end
