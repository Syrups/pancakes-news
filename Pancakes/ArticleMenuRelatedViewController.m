//
//  ArticleMenuRelatedViewController.m
//  Pancakes
//
//  Created by Leo on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuRelatedViewController.h"
#import "ArticleViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface ArticleMenuRelatedViewController ()

@end

@implementation ArticleMenuRelatedViewController {
    NSArray* related;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ArticleViewController* articleVc = (ArticleViewController*)self.parentViewController.parentViewController;
    self.article = articleVc.displayedArticle;
    
    related = [Article arrayOfModelsFromDictionaries:self.article.related];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return related.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Article* article = related[indexPath.row];
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"RelatedArticleCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RelatedArticleCell"];
    }
    
    UILabel* titleLabel = (UILabel*)[cell.contentView viewWithTag:10];
    titleLabel.text = article.title;
    
    UIImageView* feedCellThumb = (UIImageView*)[cell.contentView viewWithTag:20];
    [feedCellThumb setFrame:CGRectMake(feedCellThumb.frame.origin.x, feedCellThumb.frame.origin.y, cell.frame.size.width/3.5, cell.frame.size.height)];
    feedCellThumb.contentMode = UIViewContentModeScaleAspectFill;
    [feedCellThumb sd_setImageWithURL:[NSURL URLWithString:article.coverImage]];
    feedCellThumb.clipsToBounds = YES;

    
    return cell;
}


@end
