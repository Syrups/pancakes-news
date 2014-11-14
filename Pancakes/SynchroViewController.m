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
    int screenMidSize = self.view.frame.size.width/2;
    

    self.synchroTable = [[UITableView alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, self.view.frame.size.height)];
    //self.background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glenn"]];
    //self.background.frame = CGRectMake(0, kMenuBarHeigth, screenMidSize , self.view.frame.size.height - kMenuBarHeigth);
    //self.infoText = [[UILabel alloc] initWithFrame:CGRectMake(40, self.view.frame.size.height / 4, screenMidSize - 80, self.view.frame.size.height /2.5)];
    //self.infoText.numberOfLines = 0;
    self.infoText.text = NSLocalizedString(@"SynchDescription", nil);
    self.background.image = [[UIImage imageNamed:@"glenn"] stackBlur:20];
    
    
    //self.synchButton = [[UIButton alloc] initWithFrame:CGRectMake(screenMidSize, 0, screenMidSize, self.view.frame.size.height)];
    
    //self.infoText.textContainerInset = UIEdgeInsetsMake(30, 30, 30, 30);
    //self.infoText.font = [UIFont fontWithName:@"Heuristica-Regular" size:15.5];
    //self.infoText.textColor = [Utils colorWithHexString:@"322e1d"];
    //self.infoText.selectable = NO;
    [self.view addSubview:self.synchroTable];
    //[self.view addSubview:self.background];
    //[self.view addSubview:self.infoText];
    
    self.constraintY.constant = kMenuBarHeigth;

}

@end
