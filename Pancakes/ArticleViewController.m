//
//  ArticleViewController.m
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleViewController.h"
#import "JSONHTTPClient.h"
#import "Article.h"
#import "Block.h"
#import "GenericBlockCell.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController {
    NSMutableArray* hiddenBlocks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hiddenBlocks = [NSMutableArray array];
    
    // TEST
    self.displayedArticle = [[Article alloc] init];
    self.displayedArticle._id = @"5440d1b7cd53de6649187c8b";
    // /TEST
    
    NSString* articleUrl = [NSString stringWithFormat:@"http://localhost:5000/api/articles/%@", self.displayedArticle._id];
    
    [JSONHTTPClient getJSONFromURLWithString:articleUrl completion:^(NSDictionary *json, JSONModelError *err) {
        NSError* error = nil;
        self.displayedArticle = [[Article alloc] initWithDictionary:json error:&error];
        self.articleTitleLabel.text = self.displayedArticle.title;
        
        for (Block* block in self.displayedArticle.blocks) {
            if (![block.type.name isEqualToString:@"generic"]) {
                [hiddenBlocks addObject:block];
            }
        }
        
        [self.tableView reloadData];
    }];
    
    [self.tableView registerClass:[GenericBlockCell class] forCellReuseIdentifier:@"GenericBlockCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.displayedArticle.blocks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Block* block = [self.displayedArticle.blocks objectAtIndex:[indexPath row]];
    GenericBlockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenericBlockCell"];
    
    if (cell == nil) {
        cell = [[GenericBlockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GenericBlockCell"];
    }
    
    [cell setFrame:self.tableView.frame];
    [cell layoutWithBlock:block];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Block* block = [self.displayedArticle.blocks objectAtIndex:[indexPath row]];
    
    if ([hiddenBlocks indexOfObject:block] != NSNotFound) {
        return 0.0f;
    }
    
    return UITableViewAutomaticDimension;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    [hiddenBlocks removeObject:[self.displayedArticle.blocks objectAtIndex:1]];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


@end
