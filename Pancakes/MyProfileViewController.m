//
//  MyProfileViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Configuration.h"

@implementation MyProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    int screenMidSize = self.view.frame.size.width/2;
    
    UIImage *image = [UIImage imageNamed:@"glenn_test"];
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, kMenuBarHeigth + self.view.frame.size.height, screenMidSize, self.view.frame.size.height - kMenuBarHeigth)];
    self.profilePicture.contentMode = UIViewContentModeTopLeft;
    self.profilePicture.clipsToBounds = YES;
   //self.profilePicture.layer.contentsRect = CGRectMake(0.0, 0.0, 0, 0);
    
    self.synchroTable = [[UITableView alloc] initWithFrame:CGRectMake(screenMidSize*2, 0, screenMidSize, self.view.frame.size.height)];
    self.profilePicture.image = image;
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.synchroTable];
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    int screenMidSize = self.view.frame.size.width/2;
    self.profilePicture.frame = CGRectMake(0, kMenuBarHeigth + self.view.frame.size.height, screenMidSize, self.view.frame.size.height - kMenuBarHeigth);
    self.synchroTable.frame = CGRectMake(self.view.frame.size.width, 0, screenMidSize, self.view.frame.size.height);
    
    CGRect f1 = CGRectMake(0, kMenuBarHeigth, self.view.frame.size.width/2, self.view.frame.size.height);
    CGRect f2 = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, self.view.frame.size.height);

        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.synchroTable.frame = f2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4f  delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^() {
                self.profilePicture.frame = f1;
            } completion:nil];
        }];
}
@end
