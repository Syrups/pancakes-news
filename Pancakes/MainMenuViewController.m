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
#import "Utils.h"
#import "PKMenuItemCircle.h"


@import CoreGraphics;
@import UIKit;


#define EnterMenuItem(button) \
[button setAlpha:1]; \
CGRect frame = button.frame; \
frame.origin.x -= 10; \
[button setFrame:frame]; \

// pi is approximately equal to 3.14159265359.
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

//#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@implementation MainMenuViewController {
    //NSDictionary* itemTagsControllers;
    
    
}

int const ARC_CENTER_X = -70;
int const BUTONS_WIDTH = 130;
int const BUTONS_HEIGHT = 30;

BOOL flag_arc_loaded = false;

NSArray *angles;
NSArray *menuNames;
NSMutableArray *labels;
NSMutableArray *indicators;

float baseToggleX = 0.0f;
Boolean isOpen = false;

CGPoint arcStart;
CGPoint arcCenter;
CGFloat arcRadius;

PKMenuItemCircle *currentItem;


- (void)viewDidLoad {
    
    //Rotation constant 25
    angles = @[@-45, @-20, @5, @30];
    menuNames = @[@"MenuNews", @"MenuProfile" , @"MenuInterests", @"MenuSynchronization"];
    
    [super viewDidLoad];
    
    labels = [[NSMutableArray alloc] init];
    indicators = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < angles.count; i++) {
        PKMenuItemCircle* indicator = [[PKMenuItemCircle alloc] initWithFrame: CGRectMake(0, 0, 5, 5)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = (i+1) * 10;
        [button addTarget:self action:@selector(menuItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button setAlpha:0.0f];
       
        [labels addObject : button];
        [indicators addObject:indicator];
    }
    
     currentItem = [indicators objectAtIndex:0];
      
    //[self.view.window addSubview:self.blurView];
}


- (void)viewWillLayoutSubviews{
    
    if(!flag_arc_loaded){
        [self drawStyleArc];
    }
    
    
    for (int i = 0; i < angles.count; i++) {
        [self layoutButtonAtinddex:i];
    }
    
   
}


- (CGMutablePathRef)buildArcBaseWithEndAngle : (float)angle{
    
    float radius = self.view.frame.size.width * 0.5;
    arcStart = CGPointMake(0, radius);
    arcCenter = CGPointMake(ARC_CENTER_X, (0.5 * self.view.bounds.size.height) + kMenuBarHeigth);
    arcRadius =  self.view.frame.size.width * 0.5;
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathMoveToPoint(arcPath, NULL, arcStart.x, arcStart.y);
    CGPathAddArc(arcPath, NULL, arcCenter.x, arcCenter.y, arcRadius, DEGREES_TO_RADIANS(90), DEGREES_TO_RADIANS(angle), YES);
    
    return arcPath;
}

- (void) drawStyleArc{
    
    CGMutablePathRef arcPath = [self buildArcBaseWithEndAngle: -90];
    
    UIView* drawArcView = [[UIView alloc] initWithFrame: self.view.bounds];
    
    //Stroke
    CAShapeLayer* showArcLayer = [[CAShapeLayer alloc] init];
    showArcLayer.frame = drawArcView.layer.bounds;
    showArcLayer.path = arcPath;
    showArcLayer.strokeColor = [[UIColor whiteColor] CGColor];
    showArcLayer.fillColor = nil;
    showArcLayer.lineWidth = 1.0;
    //[drawArcView.layer addSublayer: showArcLayer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = drawArcView.layer.bounds; //CGRectMake(ARC_CENTER_X,0,arcRadius,self.view.frame.size.height);
    gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor ];
    gradientLayer.startPoint = CGPointMake(0,0.5);
    gradientLayer.endPoint = CGPointMake(0.2,0.5);
    [drawArcView.layer addSublayer:gradientLayer];
    gradientLayer.mask = showArcLayer;
    
    //fill
    CAShapeLayer* showArcFillLayer = [[CAShapeLayer alloc] init];
    showArcFillLayer.frame = drawArcView.layer.bounds;
    showArcFillLayer.path = arcPath;
    showArcFillLayer.strokeColor = nil;
    showArcFillLayer.fillColor = [UIColor colorWithWhite:255 alpha:0.06].CGColor;
    showArcFillLayer.lineWidth = 1.0;
    [drawArcView.layer addSublayer: showArcFillLayer];
    
    [self.view addSubview:drawArcView];
    
    CGPathRelease(arcPath);
    flag_arc_loaded = true;
}


- (void) layoutButtonAtinddex : (int) index {
    float  angle = [[angles objectAtIndex:index] floatValue];

    CGPoint point = [Utils pointOnCircleWithCenter:arcCenter withRadius:arcRadius withAngle:DEGREES_TO_RADIANS(angle)];
    point.x += (BUTONS_WIDTH * 0.5) + 20;
    
    UIButton *menuButton = [labels objectAtIndex:index];
    menuButton.frame = CGRectMake(0, 0, BUTONS_WIDTH, BUTONS_HEIGHT);
    menuButton.center = point;
    menuButton.titleLabel.font = [UIFont fontWithName:@"Heuristica-Italic" size:15.5];
   
    [menuButton setTitle: NSLocalizedString(menuNames[index], nil) forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
    
    [self.view addSubview: [indicators objectAtIndex:index]];
    [self.view addSubview:menuButton];

}

- (void) drawAnimationArcsWithEndAngleAtIndex : (int) index {

    float  angle = [[angles objectAtIndex:index] floatValue];
    CGPoint arcStart = CGPointMake(0, self.view.frame.size.width  );
    CGPoint arcCenter = CGPointMake(ARC_CENTER_X, (0.5 * self.view.bounds.size.height) + kMenuBarHeigth);
    CGFloat arcRadius =  self.view.frame.size.width * 0.5;
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathMoveToPoint(arcPath, NULL, arcStart.x, arcStart.y);
    CGPathAddArc(arcPath, NULL, arcCenter.x, arcCenter.y, arcRadius, DEGREES_TO_RADIANS(90), DEGREES_TO_RADIANS(angle), YES);
    
    
    PKMenuItemCircle* dynamicView = [indicators objectAtIndex:index];
    dynamicView.center = arcStart;
    
    // Animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.duration = 0.15f;
    pathAnimation.path = arcPath;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    CGPathRelease(arcPath);
    
    // Add the animation and reset the state so we can run again.
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
      
        //[drawArcView removeFromSuperview];
        //[dynamicView removeFromSuperview];
        if(index == labels.count - 3){
            [self animateButtonAtIndex:0];
        }
    }];
    [dynamicView.layer addAnimation:pathAnimation forKey:@"arc"];
    [CATransaction commit];
}


- (void)animateOpening {
    
    for (int i = 0; i < angles.count; i++) {
        [self drawAnimationArcsWithEndAngleAtIndex:i];
    }
}


- (void)animateButtonAtIndex :(int)index; {
    
    BOOL nextItemExist = index + 1 < labels.count ;
    [UIView animateWithDuration:0.08f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        UIButton *button = [labels objectAtIndex:index];
        button.alpha = 1;
        button.center = CGPointMake(button.center.x - 10, button.center.y);
        
    } completion:nextItemExist ? ^(BOOL finished) {
        
        [self animateButtonAtIndex:index + 1];
        
    }:^(BOOL finished) {
        [currentItem setSelected:YES completion:nil];
    }];
}

- (void)animateClosing {
    
    for (PKMenuItemCircle *item in indicators) {
        item.center = arcStart;
        [item setSelected:false completion:nil];
    }
    
    for(UIButton *button in labels){
        [button setAlpha:0];
    }
}

- (IBAction)menuItemSelected:(UIView*)sender {
    NSString* tag = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    int index = ([tag intValue]-1) / 10;
    
    [currentItem setSelected:false completion:nil];

    currentItem = [indicators objectAtIndex:index];
    [currentItem setSelected:YES completion:^(BOOL finished) {
        [self.delegate menuDidSelectItem : tag];
        [self close];
    }];

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
    
    float heightLessBar = self.view.frame.size.height - kMenuBarHeigth;
    [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        CGRect theFrame = [self.toggleItem frame];
        theFrame.origin.x = self.view.frame.size.width;
        self.toggleItem.frame = theFrame;
        self.blurView.frame = CGRectMake(0.0f, kMenuBarHeigth, self.view.frame.size.width, heightLessBar);
        
    } completion:^(BOOL finished) {
        [self animateOpening];
    }];
}

- (void)close {
    isOpen = !isOpen;
    
    float heightLessBar = self.view.frame.size.height - kMenuBarHeigth;
    [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(-self.view.frame.size.width, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        CGRect theFrame = [self.toggleItem frame];
        theFrame.origin.x = 0;
        self.toggleItem.frame = theFrame;
        
        self.blurView.frame = CGRectMake(0.0f, kMenuBarHeigth, 0.0f, heightLessBar);
    } completion:^(BOOL finished) {
        [self animateClosing];
    }];
    
}

@end
