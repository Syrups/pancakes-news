//
//  ThemeInterest.h
//  Pancakes
//
//  Created by Glenn Sonna on 07/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "JSONModel.h"
#import "SubThemeInterest.h"

@interface ThemeInterest : JSONModel

@property (strong, nonatomic) NSString* _id;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString<Optional>* coverImage;
@property (strong, nonatomic) NSString* color;
@property (strong, nonatomic) NSString<Optional>* desc;
@property (strong, nonatomic) NSArray<SubThemeInterest, Optional>* subthemes;


+ (BOOL) themInterestIsOn: (ThemeInterest *) theme forSubThemes :(NSArray *)subthemes;

@end
