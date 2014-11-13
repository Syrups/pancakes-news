//
//  ArticleMenuViewController.h
//  Pancakes
//
//  Created by Leo on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleMenuViewController : UIViewController

@property (strong, nonatomic) NSDictionary* detailViewControllers;
@property (strong, nonatomic) Article* article;

@end
