//
//  AudioEmbeddedBlock.m
//  Pancakes
//
//  Created by Leo on 26/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "AudioEmbeddedBlock.h"
#import "Configuration.h"
#import <SDWebImage/SDWebImageManager.h>
#import "StackBlur/UIImage+StackBlur.h"

@implementation AudioEmbeddedBlock {
    NSTimer* playTimer;
    BOOL isPlaying;
}

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    
    isPlaying = NO;
    
    self.block = block;
    
    UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 230)];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.article.coverImage] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            [background setImage:[image stackBlur:8.0f]];
        }
    }];
    
    [self addSubview:background];
    
    UIView* overlay = [[UIView alloc] initWithFrame:background.frame];
    overlay.backgroundColor = RgbaColor(0, 0, 0, 0.7f);
    [self addSubview:overlay];
        
    // Embedded block title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 20.0f, self.frame.size.width - 60.0f, 30.0f)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:kFontBreeBold size:24.0f];
    title.textAlignment = NSTextAlignmentRight;
    title.text = @"Audio";
    [self addSubview:title];
    [self bringSubviewToFront:title];
    
    NSURL *soundUrl = [NSURL URLWithString:self.block.url];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
     [self loadAudioPlayerWithUrl:soundUrl];
//    });
    
}

- (void)loadAudioPlayerWithUrl:(NSURL*)url {
    // Construct URL to sound file
//    NSString *path = [NSBundle pathForResource:@"test_audio" ofType:@"mp3" inDirectory:nil];
//    NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:@"test_audio" withExtension:@"mp3"];
    
    
    AVPlayerItem* item = [[AVPlayerItem alloc] initWithURL:url];
    
    self.audioPlayer = [[AVPlayer alloc] initWithPlayerItem:item];

        AudioPlayer* player = [[AudioPlayer alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 80, 45, 160, 160) totalDuration:CMTimeGetSeconds(self.audioPlayer.currentItem.asset.duration)];
        [self addSubview:player];
        self.playerView = player;
        
        [self setNeedsDisplay];
        
        [self togglePlayPause:nil];
    
}

- (IBAction)togglePlayPause:(id)sender {
    if (playTimer) {
        [self.audioPlayer pause];
        [playTimer invalidate];
        playTimer = nil;
    } else {
        NSLog(@"PLAY");
        [self.audioPlayer play];
        playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateAudioPlayer) userInfo:nil repeats:YES];
    }
}

- (void)updateAudioPlayer {
    [self.playerView update];
}

- (void)willClose {
    [self togglePlayPause:nil];
}

@end
