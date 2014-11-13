//
//  ThemeInterest.m
//  Pancakes
//
//  Created by Glenn Sonna on 07/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ThemeInterest.h"

@implementation ThemeInterest

+ (BOOL) themInterestIsOn: (ThemeInterest *) theme forSubThemes :(NSArray *)subthemes{
    for (int i = 0; i < theme.subthemes.count ; i++) {
        SubThemeInterest *s = theme.subthemes[i];
        if([subthemes containsObject:s._id]){
            return YES;
        }
    }
    return NO;
}

@end
