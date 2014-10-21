//
//  ContentParser.m
//  Pancakes
//
//  Created by Leo on 20/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ContentParser.h"

@implementation ContentParser

- (void)parseCallsFromString:(NSString *)string {
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"\\[call=([0-9]+)\\](.*?)\\[/call\\]" options:NSRegularExpressionAnchorsMatchLines error:&error];
    
    [regex enumerateMatchesInString:string options:0 range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange blockIdRange = [result rangeAtIndex:1];
        NSString* blockId = [string substringWithRange:blockIdRange];
        
        if (self.delegate != nil) {
            [self.delegate parser:self didCallBlockWithId:blockId atTextLocation:blockIdRange.location];
        }
    }];
}

- (NSString*) getCleanedString:(NSString *)string {
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[call=([0-9]+)\\])|(\\[/call\\])" options:NSRegularExpressionAnchorsMatchLines error:&error];
    
    return [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
}

@end
