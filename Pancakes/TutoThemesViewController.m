//
//  TutoThemesViewController.m
//  Pancakes
//
//  Created by Leo on 28/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "TutoThemesViewController.h"
#import "MainViewController.h"

@implementation TutoThemesViewController

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
