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
    
    
    self.synchroTable = [[UITableView alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, self.view.frame.size.height)];
    [self.view addSubview:self.synchroTable];
}
@end
