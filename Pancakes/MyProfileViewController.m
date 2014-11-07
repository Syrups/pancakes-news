//
//  MyProfileViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MyProfileViewController.h"

@implementation MyProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    int screenMidSize = self.view.frame.size.width/2;
    
    UIImage *image = [UIImage imageNamed:@"glenn_test"];
    self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, screenMidSize, self.view.frame.size.height - 43)];
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    //self.profilePicture.clipsToBounds = true;
   //self.profilePicture.layer.contentsRect = CGRectMake(0.0, 0.0, 0, 0);
    
    self.synchroTable = [[UITableView alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, self.view.frame.size.height)];
    self.profilePicture.image = image;
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.synchroTable];
}
@end
