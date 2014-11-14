//
//  SynchroViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "SynchroViewController.h"
#import "Configuration.h"
#import "UIImage+StackBlur.h"

NSArray *vals ;

@implementation SynchroViewController


- (void)viewDidLoad {
    [super viewDidLoad];


    self.infoText.text = NSLocalizedString(@"SynchDescription", nil);
    self.background.image = [[UIImage imageNamed:@"glenn"] stackBlur:20];
    self.backgroundRight.image = [[UIImage imageNamed:@"glenn"] stackBlur:20];
    self.constraintY.constant = kMenuBarHeigth;
    
    vals = @[@"19:00", @"7:00"];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [vals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.synchroTable dequeueReusableCellWithIdentifier:@"SynchroCell"];
    //cell.contentView.backgroundColor = kArticleViewBlockBackground;
    
    //Article* article = [feedArticles objectAtIndex:[indexPath row]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SynchroCell"];
    }
    
     UIButton *cellButton = (UIButton *)[cell.contentView viewWithTag:10];
    /*
    UIView* overlay = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width/2, self.view.frame.size.height/3)];
    overlay.tag = 5;
    overlay.backgroundColor = RgbaColor(0, 0, 0, 0.6f);
    overlay.hidden = YES;
    [cell.contentView addSubview:overlay];
    
    UILabel* feedCellTitle = (UILabel*)[cell.contentView viewWithTag:10];
    feedCellTitle.text = article.title;
    feedCellTitle.font = [UIFont fontWithName:kFontBreeBold size:15];
    feedCellTitle.textColor = kFeedViewListTitleColor;
    
    UIImageView* feedCellThumb = (UIImageView*)[cell.contentView viewWithTag:20];
    [feedCellThumb setFrame:CGRectMake(feedCellThumb.frame.origin.x, feedCellThumb.frame.origin.y, cell.frame.size.width/3.5, cell.frame.size.height)];
    [feedCellThumb sd_setImageWithURL:[NSURL URLWithString:article.coverImage]];
    feedCellThumb.clipsToBounds = YES;
    
    UILabel* themeTitle = (UILabel*)[cell.contentView viewWithTag:50];
    themeTitle.textColor = [Utils colorWithHexString:article.color];
    
    UIImageView* check = [[UIImageView alloc] initWithFrame:CGRectMake(38.0f, 38.0f, 22.0f, 15.0f)];
    check.image = [UIImage imageNamed:@"check_item"];
    check.tintColor = [UIColor whiteColor];
    check.contentMode = UIViewContentModeScaleAspectFit;
    check.tag = 50;
    check.alpha = 0.0f;
    
    [overlay addSubview:check];
    
    [cell setNeedsLayout];
    */
    return cell;
}


- (IBAction)addTimeAction:(id)sender {
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //self.pickerParent.alpha = self.pickerParent.hidden;
        self.pickerParent.hidden =  !self.pickerParent.hidden;
        NSLog(@"%hhd",  self.pickerParent.hidden );
        
    } completion:^(BOOL finished) {
       
    }];
    
}
@end
