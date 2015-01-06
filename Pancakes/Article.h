//
//  Article.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Block.h"
#import "Comment.h"

@protocol Article <NSObject>
@end

@interface Article : JSONModel

@property (strong, nonatomic) NSString* _id;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* credits;
@property (strong, nonatomic) NSString* heading;
@property (strong, nonatomic) NSString<Optional>* color;
@property (strong, nonatomic) NSString* coverImage;
@property (strong, nonatomic) NSArray<Block>* blocks;
@property (strong, nonatomic) NSArray<Comment>* comments;
@property (strong, nonatomic) NSArray<SubThemeInterest, Optional>* subthemes;
@property (strong, nonatomic) NSArray<Article, Optional, ConvertOnDemand>* related;

- (BOOL)containsSubtheme:(SubThemeInterest*)subtheme;

@end
