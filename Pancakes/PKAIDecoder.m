//
//  PKAIDecoder.m
//  Pancakes
//
//  Created by Glenn Sonna on 10/12/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

@import UIKit;
#import "PKAIDecoder.h"
#import "PKAIDecoder.h"


@implementation PKAIDecoder


- (UIImage *) buildUIImageWithBase64: (NSString *)base64String{
    
    
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    UIImage* image = [UIImage imageWithData:data];
    
    return image;
}

+ (UIImage *) decodeImageFromString: (NSString *)base64String{
    
    NSData* data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    UIImage* image = [UIImage imageWithData:data];
    
    return image;
}

+ (NSArray *) decodeImageFromFile: (NSString *)file{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:file ofType:@"pkai"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    NSArray *bas64Images = [content componentsSeparatedByString:@"===PANCAKES==="];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSString *base64String in bas64Images) {
        
        if(base64String != nil && base64String.length > 3){
            //NSLog(@"%@",base64String);
            
            NSArray* words = [base64String componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString* nospacestring = [words componentsJoinedByString:@""];
            
            //NSURL *url = [NSURL URLWithString:[@"data:image/png;base64," stringByAppendingString:nospacestring]];
            //NSData *imageData = [NSData dataWithContentsOfURL:url];
            
            //NSLog(@"%@",imageData);
            
            NSData* data = [[NSData alloc] initWithBase64EncodedString:nospacestring options:0];
            //NSLog(@"%lu",(unsigned long)base64String.length);
           
            
            if(data != nil ){
                UIImage* image = [UIImage imageWithData:data];
                [images addObject:image];
                
                // NSLog(@"%@",image);
            }
        }
    }
    
     //NSLog(@"%@",path);
    
    
    
    return  images;
}

+ (void) builAnimatedImageIn:(UIImageView *) imageView  fromFile:(NSString *)file{
    
    NSArray *images = [PKAIDecoder decodeImageFromFile:file];
    imageView.animationImages = images;
    imageView.animationDuration = 1.5f;
    [imageView setTintColor:[UIColor blackColor]];
    [imageView startAnimating];
}

+ (void) builAnimatedImageInButton:(UIButton *) button  fromFile:(NSString *)file{
    
    NSArray *images = [PKAIDecoder decodeImageFromFile:file];
    
    [button setImage:[images objectAtIndex:0] forState:UIControlStateNormal];
    
    [button.imageView setAnimationImages:[images copy]];
    [button.imageView setAnimationDuration:1.5f];
    [button.imageView startAnimating];
}

@end
