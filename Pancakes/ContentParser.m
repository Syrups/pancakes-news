//
//  ContentParser.m
//  Pancakes
//
//  Created by Leo on 20/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ContentParser.h"

@implementation ContentParser

- (void)parseCallsFromString:(NSString *)string withBlock:(void(^)(NSArray* calls))block {
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"\\[call=([0-9a-z]+)\\](.*?)\\[\\/call\\]" options:NSRegularExpressionAnchorsMatchLines error:&error];
    
    NSMutableArray* foundCalls = [NSMutableArray array];
    
    __block NSInteger matchCount = [[regex matchesInString:string options:0 range:NSMakeRange(0, string.length)] count];
    __block NSInteger currentMatch = 0;
    
    if (matchCount == 0) {
        block(@[]);
    }
    
    [regex enumerateMatchesInString:string options:0 range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange range = [result rangeAtIndex:0];
        range.length -= 15;
        NSRange blockIdRange = [result rangeAtIndex:1];
        
        NSString* blockId = [string substringWithRange:blockIdRange];
        
//        [self parseCallAttributesFromCallString:[string substringWithRange:attributesRange]];
        
        if (self.delegate != nil) {
            [self.delegate parser:self didCallBlockWithId:blockId atTextLocation:blockIdRange.location];
        }
        
        [foundCalls addObject:@{@"blockId": blockId, @"textRange": [NSValue value:&range withObjCType:@encode(NSRange)] }];
        
        currentMatch++;
        
        if (currentMatch == matchCount) {
            block(foundCalls);
        }
    }];
}

- (void)parseCallAttributesFromCallString:(NSString*)callString {
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"([a-z]+)=([\\w\\s]+)" options:NSRegularExpressionAnchorsMatchLines error:&error];
    
    [regex enumerateMatchesInString:callString options:0 range:NSMakeRange(0, callString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSLog(@"%@", [callString substringWithRange:[result rangeAtIndex:0]]);
    }];
}

- (NSString*) getCleanedString:(NSString *)string {
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[call=([0-9]+)\\])|(\\[/call\\])" options:NSRegularExpressionAnchorsMatchLines error:&error];
    
    return [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
}

@end
