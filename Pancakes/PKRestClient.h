//
//  PKRestClient.h
//  Pancakes
//
//  Created by Glenn Sonna on 24/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel/JSONHTTPClient.h"



@interface PKRestClient : NSObject

+ (void) sendCommentWithId : (NSString *)_id params:(NSDictionary*)params completion:(JSONObjectBlock)completeBlock;
+ (void) getAllThemesAndComplete :(JSONObjectBlock)completeBlock;

+ (void) getUserWithUser : (NSDictionary *) user :(JSONObjectBlock)completeBlock;

+ (void)getArticleWithId : (NSString *)_id :(JSONObjectBlock)completeBlock;



+ (NSString *) apiUrlWithRoute : (NSString *)route;
@end