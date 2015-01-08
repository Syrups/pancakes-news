//
//  SlideshowEmbeddedBlock.h
//  Pancakes
//
//  Created by Leo on 08/01/2015.
//  Copyright (c) 2015 Gobelins. All rights reserved.
//

#import "DefinitionEmbeddedBlock.h"

@interface SlideshowEmbeddedBlock : DefinitionEmbeddedBlock

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) NSArray* imageViews;

@end
