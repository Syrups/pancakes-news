//
//  TutoSynchroViewController.m
//  Pancakes
//
//  Created by Leo on 03/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "TutoSynchroViewController.h"
#import "MainViewController.h"

@implementation TutoSynchroViewController

- (IBAction)yes:(id)sender {
    MainViewController* mainVc = (MainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
    mainVc.initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseThemesView"];
    
    [self.navigationController pushViewController:mainVc animated:NO];
}

- (IBAction)no:(id)sender {
    MainViewController* mainVc = (MainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
    mainVc.initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFeedView"];
    
    [self.navigationController pushViewController:mainVc animated:NO];
}

@end
