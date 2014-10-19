//
//  ContentParser.h
//  Pancakes
//
//  Created by Leo on 20/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentParser : NSObject

@property (weak, nonatomic) id delegate;

- (void) parseCallsFromString:(NSString*)string;
- (NSString*) getCleanedString:(NSString*)string;

@end

@protocol ContentParserDelegate <NSObject>

@required
- (void)parser:(ContentParser*)parser didCallBlockWithId:(NSString*)blockId atTextLocation:(NSUInteger)location;

@end
