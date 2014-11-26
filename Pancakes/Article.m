//
//  Article.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "Article.h"
#import "Configuration.h"

@implementation Article

- (BOOL)containsSubtheme:(SubThemeInterest *)subtheme {

    NSArray* subthemes = self.subthemes;
    
    for (SubThemeInterest* s in subthemes) {
        if ([s respondsToSelector:@selector(_id)] && [subtheme._id isEqualToString:s._id]) {
            return YES;
        }
    }
    
    return NO;
}

@end
