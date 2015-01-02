//
//  PKSyrupButton.m
//  Pancakes
//
//  Created by Glenn Sonna on 12/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "PKSyrupButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation PKSyrupButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        
    }
    
    return self;
}


-(void)awakeFromNib {
    [self setUp];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
  
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Lines
    CGContextSetStrokeColorWithColor(context, self.innerImageColor.CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.f);
    
    
    if(self.switchMode){
        self.innerImageType = self.isOn ? PKSyrupButtonTypePlus : PKSyrupButtonTypeX;
    }
    
    [self drawButtonType:rect withContext:context];

    /*if(!self.switchMode){
        [self drawButtonType:rect withContext:context];
        
    }else{
        
        if(self.isOn){
            [self drawButtonTypePlus:rect withContext:context];
        }else{
            [self drawButtonTypeX:rect withContext:context];
        }
    }*/
}


-(void)setUp{
    
    _innerImageType = PKSyrupButtonTypePlus;
    
    self.innerColor = [UIColor clearColor];
    self.innerImageColor = RGB(255, 109, 12);
    self.borderColor = RGB(255, 109, 12);
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.borderWidth = 2.f;
    
    self.clipsToBounds = YES;
    self.switchMode = YES;
    
    [self setOpaque:NO];
    [self setNeedsDisplay];
}


- (void) setInnerImageType:(PKSyrupButtonType )innerImageType{
    
    _innerImageType = innerImageType;
    [self setNeedsDisplay];
}

-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    
    self.layer.borderColor = self.borderColor.CGColor;
    [self setNeedsDisplay];
}


- (void)setInnerColor:(UIColor *)innerColor{
    
    _innerColor = innerColor;
    
    [self setBackgroundColor:self.innerColor];
    [self setNeedsDisplay];
}


-(void)drawButtonType:(CGRect)rect withContext: (CGContextRef) context {
    switch (self.innerImageType) {
            
        case PKSyrupButtonTypePlus:
            [self drawButtonTypePlus:rect withContext:context];
            break;
            
        case PKSyrupButtonTypeX:
            [self drawButtonTypeX:rect withContext:context];
            break;
            
        default:
            [self drawButtonTypePlus:rect withContext:context];
            break;
    }
}

-(void)drawButtonTypeX:(CGRect)rect withContext: (CGContextRef) context {

    //First Line
    CGContextMoveToPoint(context, kInnerPadding, kInnerPadding); //start at this point
    CGContextAddLineToPoint(context, rect.size.width - kInnerPadding, rect.size.height - kInnerPadding);
    
    //Second Line
    CGContextMoveToPoint(context, rect.size.width - kInnerPadding, kInnerPadding); //start at this point
    CGContextAddLineToPoint(context, kInnerPadding, rect.size.height - kInnerPadding); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}


-(void)drawButtonTypePlus:(CGRect)rect withContext: (CGContextRef) context{
   
    //First Line : vertical
    CGContextMoveToPoint(context, rect.size.width * 0.5, kInnerPadding); //start at this point
    CGContextAddLineToPoint(context, rect.size.width * 0.5, rect.size.height - kInnerPadding);
    
    //Second Line : horizontal
    CGContextMoveToPoint(context, kInnerPadding, rect.size.height * 0.5); //start at this point
    CGContextAddLineToPoint(context, rect.size.width - kInnerPadding, rect.size.height * 0.5); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isTouchDown = YES;
    
    
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = .4;
         [self setNeedsDisplay];
    } completion:nil];
    
}*/


-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = .4;
        [self setNeedsDisplay];
    } completion:nil];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(self.switchMode){
        self.isOn = !self.isOn;
        self.innerImageType = self.isOn ? PKSyrupButtonTypeX : PKSyrupButtonTypePlus;
    }
    
    self.isTouchDown = NO;
    
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        [self setNeedsDisplay];
    } completion:nil];
    
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Triggered if touch leaves view
    if (self.isTouchDown) {
        self.isTouchDown = NO;
    }
}


@end
