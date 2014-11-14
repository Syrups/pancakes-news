//
//  PKCacheManager.h
//  Pancakes
//
//  Created by Glenn Sonna on 13/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKCacheManager : NSObject
/*
+ (PKCacheManager *)sharedInstance;
*/

//@property (strong) User *user;

+(void) cacheIntrests: (NSArray *) interests;
+(id) loadInterestsFromCache;

-(void) saveArticles;
-(void) loadArticles;

+(void) synchonizationRoutine;

@end



