//
//  TutoThemesViewController.m
//  Pancakes
//
//  Created by Leo on 28/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "TutoThemesViewController.h"
#import "MainViewController.h"
#import "Configuration.h"

@implementation TutoThemesViewController

- (void)viewDidLoad {
    
    // skip tuto if setting present
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kPancakesTutoThemesCookie] != nil) {
//        MainViewController* mainVc = (MainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
//        mainVc.initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFeedView"];
//        
//        [self.navigationController pushViewController:mainVc animated:NO];
//    }
}

- (IBAction)yes:(id)sender {
    MainViewController* mainVc = (MainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
    mainVc.initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseThemesView"];
    
    [self.navigationController pushViewController:mainVc animated:NO];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kPancakesTutoThemesCookie];
}

- (IBAction)no:(id)sender {
    MainViewController* mainVc = (MainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
    mainVc.initialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFeedView"];
    
    [self.navigationController pushViewController:mainVc animated:NO];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kPancakesTutoThemesCookie];
}


@end
