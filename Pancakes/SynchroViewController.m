//
//  SynchroViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "SynchroViewController.h"

@implementation SynchroViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    int screenMidSize = self.view.frame.size.width/2;
    
    UIImageView* profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenMidSize, self.view.frame.size.height)];
    profileImage.image = [UIImage imageNamed:@"glenn"];
    profileImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:profileImage];
}
@end
