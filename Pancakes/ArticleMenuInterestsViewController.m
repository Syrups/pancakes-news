//
//  ArticleMenuInterestsViewController.m
//  Pancakes
//
//  Created by Leo on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuInterestsViewController.h"
#import "ArticleViewController.h"
#import "Configuration.h"
#import <JSONModel/JSONHTTPClient.h>
#import "ThemeInterest.h"
#import "Utils.h"

@interface ArticleMenuInterestsViewController ()

@end

@implementation ArticleMenuInterestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchInterests];
    
    ArticleViewController* articleVc = (ArticleViewController*)self.parentViewController.parentViewController;
    
    self.article = articleVc.displayedArticle;
}

- (void) fetchInterests {
//    NSString* interestsUrl = [kApiRootUrl stringByAppendingString:@"/interests"];
//    [JSONHTTPClient getJSONFromURLWithString:interestsUrl completion:^(NSDictionary *json, JSONModelError *err) {
//        
//    }];
    
    //initDummy Datas
    
    NSString * filePath =[[NSBundle mainBundle] pathForResource:@"MyInterest" ofType:@"json"];
    NSError * error;
    NSString* fileContents =[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {
        NSLog(@"Error reading file: %@",error.localizedDescription);
    }
    
    NSArray *jsonArray = (NSArray *)[NSJSONSerialization
                                     JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding]
                                     options:0 error:NULL];
    
    self.data = [ThemeInterest arrayOfModelsFromDictionaries:jsonArray];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height/4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"InterestCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InterestCell"];
    }
    
    ThemeInterest* interest = [self.data objectAtIndex:indexPath.row];
    
    UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:10];
    themeTitle.textColor = [Utils colorWithHexString:interest.color];
    themeTitle.text = interest.title;
    
    UIImageView* themeThumb = (UIImageView*)[cell.contentView viewWithTag:20];
    [themeThumb setFrame:CGRectMake(themeThumb.frame.origin.x, themeThumb.frame.origin.y, cell.frame.size.width/3.5, cell.frame.size.height)];
    [themeThumb setImage:[UIImage imageNamed:interest.coverImage]];
    themeThumb.clipsToBounds = YES;
    
    return cell;
}


@end
