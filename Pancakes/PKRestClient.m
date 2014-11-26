//
//  PKRestClient.m
//  Pancakes
//
//  Created by Glenn Sonna on 24/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "PKRestClient.h"


@implementation PKRestClient

NSString * const themesUrl = kApiRootUrl @"/themes";
NSString * const createUser = kApiRootUrl @"/user/create";
NSString * const article = kApiRootUrl @"/articles/%@";
NSString * const articles = kApiRootUrl @"/articles";





+(void) sendCommentWithId : (NSString *)_id params:(NSDictionary*)params completion:(JSONObjectBlock)completeBlock {
    NSString *url = [kApiRootUrl stringByAppendingString:[NSString stringWithFormat:@"/articles/%@/comments", _id]];
    
    //make post, get requests
    [JSONHTTPClient postJSONFromURLWithString:url params:params completion:completeBlock];
}

+(void) getAllThemesAndComplete :(JSONObjectBlock)completeBlock{
    
    [JSONHTTPClient getJSONFromURLWithString:themesUrl completion:completeBlock];
}


+ (void) getUserWithUser : (NSDictionary *) user :(JSONObjectBlock)completeBlock{
    //make post, get requests
    [JSONHTTPClient postJSONFromURLWithString:createUser params:user completion:completeBlock];
}

+ (void)getArticleWithId : (NSString *)articleId :(JSONObjectBlock)completeBlock{

    NSString* articleUrl = [NSString stringWithFormat:article, articleId];
    
    [JSONHTTPClient getJSONFromURLWithString:articleUrl completion:completeBlock];
}

+ (NSString *) apiUrlWithRoute : (NSString *)route{
    return[kApiRootUrl stringByAppendingString:route];
}

+ (NSString *) mediaUrl : (NSString *)mediaName{
    return[kMediaRootUrl stringByAppendingString:[NSString stringWithFormat:@"/%@", mediaName]];
}

+ (NSString *) mediaUrl : (NSString *)mediaName withRoute : (NSString *)route{
    return[kMediaRootUrl stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",route, mediaName]];
}

@end
