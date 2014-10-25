//
//  MyFeedViewController.m
//  Pancakes
//
//  Created by Leo on 24/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MyFeedViewController.h"
#import <JSONModel/JSONHTTPClient.h>
#import "Article.h"
#import "Configuration.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyFeedViewController ()

@end

@implementation MyFeedViewController {
    NSArray* feedArticles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedTableView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    
    // dummy data
    feedArticles = [NSArray array];
    
    [self fetchFeed];
    [self.view bringSubviewToFront:self.feedTableView];
}

- (void)fetchFeed {
    NSString *feedUrl = [kApiRootUrl stringByAppendingString:@"/feed"];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:feedUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* err = nil;
        feedArticles = [Article arrayOfModelsFromData:data error:&err];
        
        // Reload table data on main thread to avoid problems
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.feedTableView reloadData];
        });
        
    }] resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedArticles count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.feedTableView dequeueReusableCellWithIdentifier:@"FeedArticleCell"];
    Article* article = [feedArticles objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FeedArticleCell"];
    }
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.text = article.title;
    
    
    
    return cell;
}

@end
