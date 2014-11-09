//
//  SubThemeInterest.h
//  Pancakes
//
//  Created by Glenn Sonna on 07/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "JSONModel.h"

@protocol SubThemeInterest <NSObject>
@end

@interface SubThemeInterest : JSONModel
@property (strong, nonatomic) NSString* _id;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* image;
@end
