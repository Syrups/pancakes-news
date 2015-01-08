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
#import "ArticleMenuViewController.h"
#import "FXBlurView.h"

@interface ArticleViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) Article* displayedArticle;
@property (strong, nonatomic) NSString* articleId;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIImageView *moreButtonBackground;
@property (strong, nonatomic) ContentParser* parser;
@property (strong, nonatomic) IBOutlet UIButton* backButton;

@property (strong, nonatomic) UIImage *cover;
@property (weak, nonatomic) IBOutlet FXBlurView *coverBlur;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (strong, nonatomic) IBOutlet UIImageView* articleCoverImage;

@property (strong, nonatomic) ArticleMenuViewController* menuViewController;
@property (strong, nonatomic) UINavigationController* menuDetailViewController;
@property (strong, nonatomic) NSMutableArray* scrollListeners;

@property (strong, nonatomic) UIView* storyline;

- (void)revealBlockAtIndexPath:(NSIndexPath *)indexPath;
- (void)closeBlockAtIndexPath:(NSIndexPath *)indexPath;

@end
