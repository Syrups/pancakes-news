//
//  ArticleMenuViewController.m
//  Pancakes
//
//  Created by Leo on 10/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "ArticleMenuViewController.h"
#import "ArticleViewController.h"
#import "Configuration.h"
#import "PKMenuItemCircle.h"
#import "Utils.h"

#define BUTONS_WIDTH  130
#define BUTONS_HEIGHT 30

@interface ArticleMenuViewController ()

@end



@implementation ArticleMenuViewController {
    NSInteger previousDetailViewTag;
    NSArray *angles;
    
    CGPoint arcStart;
    CGPoint arcCenter;
    CGFloat arcRadius;
    
    PKMenuItemCircle *currentItem;
    
    BOOL flag_arc_loaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flag_arc_loaded = false;
    
    angles = @[@245, @220, @195, @170];
    
    self.detailViewControllers = @{
        @"10": [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuInterestsView"],
        @"20": [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuShareView"],
        @"30": [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuRelatedView"],
        @"40": [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleMenuCommentView"]
    };
}

- (void)viewDidLayoutSubviews {
    [self drawStyleArc];
    
    for (int i = 0; i < angles.count; i++) {
        [self drawAnimationArcForButton:[self.items objectAtIndex:i] withEndAngleAtIndex:i];
    }
}

- (CGMutablePathRef)buildArcBaseWithEndAngle : (float)angle{
    
//    float radius = self.view.frame.size.width * 0.5;
    arcStart = CGPointMake(self.view.bounds.size.width, 35.0f);
    arcCenter = CGPointMake(self.view.bounds.size.width - 25.0f, 0.7 * self.view.bounds.size.height);
    arcRadius =  self.view.frame.size.width * 0.7;
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathMoveToPoint(arcPath, NULL, arcStart.x, arcStart.y);
    CGPathAddArc(arcPath, NULL, arcCenter.x, arcCenter.y, arcRadius, DEGREES_TO_RADIANS(80), DEGREES_TO_RADIANS(angle), NO);
    
    return arcPath;
}

- (void) drawStyleArc{
    
    CGMutablePathRef arcPath = [self buildArcBaseWithEndAngle: -70];
    
    UIView* drawArcView = [[UIView alloc] initWithFrame: self.view.bounds];
    
    //Stroke
    CAShapeLayer* showArcLayer = [[CAShapeLayer alloc] init];
    showArcLayer.frame = drawArcView.layer.bounds;
    showArcLayer.path = arcPath;
    showArcLayer.strokeColor = [[UIColor whiteColor] CGColor];
    showArcLayer.fillColor = nil;
    showArcLayer.lineWidth = 0.5f;
    //[drawArcView.layer addSublayer: showArcLayer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = drawArcView.layer.bounds; //CGRectMake(ARC_CENTER_X,0,arcRadius,self.view.frame.size.height);
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor clearColor].CGColor ];
    gradientLayer.startPoint = CGPointMake(0.3,0.5);
    gradientLayer.endPoint = CGPointMake(0.8,0.5);
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
    [self.view sendSubviewToBack:drawArcView];
    
    CGPathRelease(arcPath);
    flag_arc_loaded = true;
}

- (void) drawAnimationArcForButton:(UIButton*)button withEndAngleAtIndex:(int) index {
    
    float  angle = [[angles objectAtIndex:index] floatValue];
    arcStart = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height+30);
    arcCenter = CGPointMake(self.view.bounds.size.width - 25.0f, 0.7 * self.view.bounds.size.height);
    arcRadius =  self.view.frame.size.width * 0.7;
    
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathMoveToPoint(arcPath, NULL, arcStart.x, arcStart.y);
    CGPathAddArc(arcPath, NULL, arcCenter.x, arcCenter.y, arcRadius, DEGREES_TO_RADIANS(80), DEGREES_TO_RADIANS(angle), NO);
    
    
    // Animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.duration = 0.5f;
    pathAnimation.path = arcPath;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    CGPathRelease(arcPath);
    
    // Add the animation and reset the state so we can run again.
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
    }];
    [button.layer addAnimation:pathAnimation forKey:@"arc"];
    [CATransaction commit];
}


//- (void) layoutButtonAtinddex : (int) index {
//    float  angle = [[angles objectAtIndex:index] floatValue];
//    
//    CGPoint point = [Utils pointOnCircleWithCenter:arcCenter withRadius:arcRadius withAngle:DEGREES_TO_RADIANS(angle)];
//    point.x += (BUTONS_WIDTH * 0.5) + 20;
//    
//    UIButton *menuButton = [labels objectAtIndex:index];
//    menuButton.frame = CGRectMake(0, 0, BUTONS_WIDTH, BUTONS_HEIGHT);
//    menuButton.center = point;
//    menuButton.titleLabel.font = [UIFont fontWithName:@"Heuristica-Italic" size:15.5];
//    
//    [menuButton setTitle: NSLocalizedString(menuNames[index], nil) forState:UIControlStateNormal];
//    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    
//    [self.view addSubview: [indicators objectAtIndex:index]];
//    [self.view addSubview:menuButton];
//    
//}

//- (void)animateOpen {
//    // Set up path movement
//    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    pathAnimation.calculationMode = kCAAnimationPaced;
//    pathAnimation.fillMode = kCAFillModeForwards;
//    pathAnimation.removedOnCompletion = NO;
//    
//    CGPoint startPoint = CGPointMake(120.0f, 15.0f);
//    CGPoint endPoint = CGPointMake(59.0f, 252.0f);
//    CGPoint arcCenter = CGPointMake(226.0f, 194.0f);
//    
//    CGMutablePathRef curvedPath = CGPathCreateMutable();
//    CGPathMoveToPoint(curvedPath, NULL, startPoint.x, startPoint.y);
//    CGPathAddArcToPoint(curvedPath, NULL, startPoint.x, startPoint.y, endPoint.x, endPoint.y, startPoint.y-arcCenter.y);
//    pathAnimation.path = curvedPath;
//    CGPathRelease(curvedPath);
//    
//    pathAnimation.duration = 2.0f;
//
//    for (UIView* v in self.view.subviews) {
//        if (v.class == [UIButton class]) {
//            [v.layer addAnimation:pathAnimation forKey:@"rotateAnimation"];
//        }
//    }
//
//}

- (IBAction)didSelectItem:(UIButton*)sender {
    NSString* tag = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    UIViewController* destination = [self.detailViewControllers objectForKey:tag];
    ArticleViewController* parent = (ArticleViewController*)self.parentViewController;
    
    // remove selected state for other items
    for (UIView* v in self.view.subviews) {
        if (v.class == [UIButton class]) {
            [(UIButton*)v setSelected:NO];
        }
    }
    
    // set this item selected
    sender.selected = YES;
    
    if (destination != nil) {
        if (sender.tag == 40) { // to comment view
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [parent.menuDetailViewController.view setFrame:parent.view.frame];
                [self.view setFrame:CGRectMake(parent.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
                [self.view setBackgroundColor:[UIColor clearColor]];
            } completion:nil];
        } else if (previousDetailViewTag == 40) { // from comment view
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [parent.menuDetailViewController.view setFrame:CGRectMake(0.0f, 0.0f, parent.view.frame.size.width/2, parent.view.frame.size.height)];
                [self.view setFrame:CGRectMake(parent.view.frame.size.width/2, 0, self.view.frame.size.width, self.view.frame.size.height)];
                [self.view setBackgroundColor:RgbaColor(0, 0, 0, 0.6f)];
            } completion:nil];
        }
        
        previousDetailViewTag = sender.tag;
        [parent.menuDetailViewController setViewControllers:@[destination] animated:NO];
        [parent.view bringSubviewToFront:self.view];
    }
}

- (IBAction)closeMenu:(id)sender {
    ArticleViewController* parent = (ArticleViewController*)self.parentViewController;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x = parent.view.frame.size.width;
        self.view.frame = frame;
        
        frame = parent.menuDetailViewController.view.frame;
        frame.origin.y = self.view.frame.size.height;
        parent.menuDetailViewController.view.frame = frame;
    } completion:nil];
}

@end
