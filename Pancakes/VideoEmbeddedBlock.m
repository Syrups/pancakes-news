//
//  VideoEmbeddedBlock.m
//  Pancakes
//
//  Created by Leo on 08/01/2015.
//  Copyright (c) 2015 Gobelins. All rights reserved.
//

#import "VideoEmbeddedBlock.h"
#import "Configuration.h"

@implementation VideoEmbeddedBlock

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    
    
    // Make a URL
    NSURL *url = [NSURL URLWithString:block.url];
    
    self.videoPlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    
    // Add a notification. (It will call a "moviePlayBackDidFinish" method when _videoPlayer finish or stops the plying video)
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:self.videoPlayer];
    
    // Set control style to default
    self.videoPlayer.controlStyle = MPMovieControlStyleDefault;
    
    // Set shouldAutoplay to YES
    self.videoPlayer.shouldAutoplay = YES;
    
    // Add _videoPlayer's view as subview to current view.
    [self addSubview:self.videoPlayer.view];
    
    // Set the screen to full.
    [self.videoPlayer setFullscreen:NO animated:NO];
    self.videoPlayer.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    // Embedded block title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 20.0f, self.frame.size.width - 60.0f, 30.0f)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
    title.textAlignment = NSTextAlignmentRight;
    title.text = @"Video";
    [self addSubview:title];
    [self bringSubviewToFront:title];
}

@end
