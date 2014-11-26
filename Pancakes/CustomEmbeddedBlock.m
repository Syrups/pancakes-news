//
//  CustomEmbeddedBlock.m
//  Pancakes
//
//  Created by Leo on 26/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "CustomEmbeddedBlock.h"

@implementation CustomEmbeddedBlock

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 230)];
    self.webview.scrollView.scrollEnabled = YES;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webglmol.sourceforge.jp/glmol/viewer.html"]]];
    
    [self addSubview:self.webview];
}

@end
