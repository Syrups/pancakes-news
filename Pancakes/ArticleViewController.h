//
//  ArticleViewController.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "ContentParser.h"

@interface ArticleViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ContentParserDelegate>

@property (strong, nonatomic) Article* displayedArticle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) ContentParser* parser;

@property (strong, nonatomic) UIView* leftMenuView;
@property (strong, nonatomic) UIView* rightMenuView;

@end
