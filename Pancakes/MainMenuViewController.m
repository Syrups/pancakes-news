//
//  MainMenuViewController.m
//  Pancakes
//
//  Created by Leo on 05/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MyFeedViewController.h"
#import "Configuration.h"

#define EnterMenuItem(button) \
[button setAlpha:1]; \
CGRect frame = button.frame; \
frame.origin.x -= 10; \
[button setFrame:frame]; \

@implementation MainMenuViewController {
    NSDictionary* itemTagsControllers;
}

- (void)viewDidLoad {
    
    itemTagsControllers = @{
                            @"10": [MyFeedViewController class]
                        };
    
    [self.newsButton setAlpha:0.0f];
    [self.profileButton setAlpha:0.0f];
    [self.interestsButton setAlpha:0.0f];
    [self.synchronizationButton setAlpha:0.0f];
    
    [super viewDidLoad];
}

- (void)animateOpening {
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        EnterMenuItem(self.newsButton);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            EnterMenuItem(self.profileButton);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                EnterMenuItem(self.interestsButton);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    EnterMenuItem(self.synchronizationButton);
                } completion:nil];
            }];
        }];
    }];
}

- (void)animateClosing {
    [self.newsButton setAlpha:0.0f];
    [self.profileButton setAlpha:0.0f];
    [self.interestsButton setAlpha:0.0f];
    [self.synchronizationButton setAlpha:0.0f];
}

- (IBAction)menuItemSelected:(UIView*)sender {
    NSString* tag = [NSString stringWithFormat:@"%d", sender.tag];
    
    // Check if the current dispplayed VC is the one that has been selected
    // in the menu, and if so, close the menu
    if ([itemTagsControllers objectForKey:tag] == [self.currentViewController class]) {
        [self.currentViewController closeMainMenu];
    } else {
        [self.currentViewController closeMainMenu];
        // Display target VC
    }
}

@end
