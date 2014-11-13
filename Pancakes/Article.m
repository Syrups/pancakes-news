//
//  Article.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "Article.h"

@implementation Article

- (BOOL)containsSubtheme:(SubThemeInterest *)subtheme {
    NSArray* subthemes = self.subthemes;
    
    NSLog(@"%@", subthemes);
    NSLog(@"%@", subtheme);
    
    for (SubThemeInterest* s in subthemes) {
        if ([s respondsToSelector:@selector(_id)] && [subtheme._id isEqualToString:s._id]) {
            return YES;
        }
    }
    
    return NO;
}

@end
