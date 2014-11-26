//
//  AudioEmbeddedBlock.h
//  Pancakes
//
//  Created by Leo on 26/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "DefinitionEmbeddedBlock.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioEmbeddedBlock : DefinitionEmbeddedBlock

@property (strong, nonatomic) AVAudioPlayer* audioPlayer;

@end