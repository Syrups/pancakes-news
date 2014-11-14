//
//  SynchroViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 06/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "SynchroViewController.h"
#import "Configuration.h"
#import "UIImage+StackBlur.h"

@implementation SynchroViewController
- (void)viewDidLoad {
    [super viewDidLoad];


    self.infoText.text = NSLocalizedString(@"SynchDescription", nil);
    self.background.image = [[UIImage imageNamed:@"glenn"] stackBlur:20];
    self.constraintY.constant = kMenuBarHeigth;

}

@end
