//
//  PKRestClient.h
//  Pancakes
//
//  Created by Glenn Sonna on 24/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel/JSONHTTPClient.h"

#define kApiRootUrl @"http://pancakes-back.herokuapp.com/api"
#define kMediaRootUrl @"http://pancakes-back.herokuapp.com/media" //http://192.168.2.2
//#define kApiRootUrl @"http://localhost:5000/api"
//#define kMediaRootUrl @"http://localhost:5000/media"

//pancakes-back.herokuapp.com/
//localhost:5000
//192.168.2.2

@interface PKRestClient : NSObject

+ (void) sendCommentWithId : (NSString *)_id params:(NSDictionary*)params completion:(JSONObjectBlock)completeBlock;
+ (void) getAllThemesAndComplete :(JSONObjectBlock)completeBlock;

+ (void) getUserWithUser : (NSDictionary *) user :(JSONObjectBlock)completeBlock;

+ (void)getArticleWithId : (NSString *)_id :(JSONObjectBlock)completeBlock;



+ (NSString *) apiUrlWithRoute : (NSString *)route;
+ (NSString *) mediaUrl : (NSString *)mediaName;
+ (NSString *) mediaUrl : (NSString *)mediaName withRoute : (NSString *)route;
@end
