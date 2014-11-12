//
//  ArticleMenuInterestsViewController.h
//  Pancakes
//
//  Created by Leo on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleMenuInterestsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) NSMutableArray* data;
@property (strong, nonatomic) Article* article;

@end
