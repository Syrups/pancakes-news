//
//  AudioEmbeddedBlock.m
//  Pancakes
//
//  Created by Leo on 26/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "AudioEmbeddedBlock.h"
#import "Configuration.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AudioEmbeddedBlock

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    
    UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 230)];
    [background sd_setImageWithURL:[NSURL URLWithString:self.article.coverImage]];
    
    [self addSubview:background];
    
    UIView* overlay = [[UIView alloc] initWithFrame:background.frame];
    overlay.backgroundColor = RgbaColor(0, 0, 0, 0.7f);
    [self addSubview:overlay];
        
    // Embedded block title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 20.0f, self.frame.size.width - 60.0f, 30.0f)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
    title.textAlignment = NSTextAlignmentRight;
    title.text = block.title;
    [self addSubview:title];
    
    [self loadAudioPlayer];
    
    UIButton* playButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 30, 100, 60, 30)];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    [self bringSubviewToFront:playButton];
}

- (void)loadAudioPlayer {
    // Construct URL to sound file
//    NSString *path = [NSBundle pathForResource:@"test_audio" ofType:@"mp3" inDirectory:nil];
    NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:@"test_audio" withExtension:@"mp3"];
    
    NSError* err = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&err];
    
    if (err != nil) {
        NSLog(@"%@", err);
    }
}

- (IBAction)play:(id)sender {
    [self.audioPlayer play];
}

@end
