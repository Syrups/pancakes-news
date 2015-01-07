//
//  ArticleMenuShareViewController.m
//  Pancakes
//
//  Created by Leo on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuShareViewController.h"
#import <Social/Social.h>
#import "UserDataHolder.h"
#import "Utils.h"

@interface ArticleMenuShareViewController ()

@end

@implementation ArticleMenuShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        self.facebook.enabled = NO;
    }
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        self.twitter.enabled = NO;
    }
    
//    if ([UserDataHolder sharedInstance].fbUSer) {
        NSDictionary<FBGraphUser> *user  = [UserDataHolder sharedInstance].fbUSer;
        [Utils setImageWithFacebook:user imageview:self.profilePicture blur:NO] ;
//    }
    
}

- (IBAction)shareFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbPostSheet setInitialText:@"Just read an article on Pancakes app !"];
        [self presentViewController:fbPostSheet animated:YES completion:nil];
    }
}

- (IBAction)shareTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twiPostSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twiPostSheet setInitialText:@"Just read an article on Pancakes app !"];
        [self presentViewController:twiPostSheet animated:YES completion:nil];
    }
}


@end
