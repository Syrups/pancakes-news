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
    //NSDictionary* itemTagsControllers;
    
    
}

float baseToggleX = 0.0f;
Boolean isOpen = false;

- (void)viewDidLoad {
    
    
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
    
    [self.delegate menuDidSelectItem : tag];
    [self close];
}


- (IBAction)toggle:(id)sender {
    
    if(!isOpen){
        [self open];
    }else {
        [self close];
    }
    
    NSLog(@"toggle %hhu", isOpen);
    
}

- (void)open {
    isOpen = !isOpen;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        CGRect theFrame = [self.toggleItem frame];
        theFrame.origin.x = self.view.frame.size.width;
        self.toggleItem.frame = theFrame;
        
    } completion:^(BOOL finished) {
        [self animateOpening];
    }];
}

- (void)close {
    isOpen = !isOpen;
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(-self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        CGRect theFrame = [self.toggleItem frame];
        theFrame.origin.x = 0;
        self.toggleItem.frame = theFrame;
    } completion:^(BOOL finished) {
        [self animateClosing];
    }];
    
}

@end
