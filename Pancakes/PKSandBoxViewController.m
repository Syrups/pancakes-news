//
//  PKSandBoxViewController.m
//  Pancakes
//
//  Created by Glenn Sonna on 10/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "PKSandBoxViewController.h"
#import "PKAIDecoder.h"
#import "AudioPlayer.h"

@interface PKSandBoxViewController ()

@end

@implementation PKSandBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [PKAIDecoder builAnimatedImageIn:self.pkaImageTest fromFile:@"lunette-picto"];
    //[PKAIDecoder builAnimatedImageInButton:self.pkaImgeButtonTest fromFile:@"lunette-picto"];
    self.pksyrupButtontest.innerColor = [UIColor blackColor];
    
    [self.pksyrupButtontest addTarget:self
                     action:@selector(syrupButtonValueChanged:)
           forControlEvents:UIControlEventValueChanged];
   
}
- (void)syrupButtonValueChanged:(PKSyrupButton *)button
{
    NSLog(@"Value : %d", button.isOn);

//    [PKAIDecoder builAnimatedImageIn:self.pkaImageTest fromFile:@"lunette-picto"];
//    [PKAIDecoder builAnimatedImageInButton:self.pkaImgeButtonTest fromFile:@"lunette-picto"];
    
    [self.view addSubview:[[AudioPlayer alloc] initWithFrame:CGRectMake(50, 50, 200, 200)]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
