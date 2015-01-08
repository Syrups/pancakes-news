//
//  VideoEmbeddedBlock.h
//  Pancakes
//
//  Created by Leo on 08/01/2015.
//  Copyright (c) 2015 Gobelins. All rights reserved.
//

#import "DefinitionEmbeddedBlock.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoEmbeddedBlock : DefinitionEmbeddedBlock

@property (strong, nonatomic) MPMoviePlayerController *videoPlayer;

@end
