//
//  EditorsBlockCell.m
//  Pancakes
//
//  Created by Leo on 03/11/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "EditorsBlockCell.h"
#import "Configuration.h"

@implementation EditorsBlockCell

- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    if (self.opened) return;
    CGFloat y = 0;
    
    for (NSDictionary* editor in block.editors) {
        UIImageView* cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, 150.0f  )];
        [cover setImage:[UIImage imageNamed:@"splash"]];
        [self addSubview:cover];
        
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 65, y + 90, 130, 130)];
        [image setImage:[UIImage imageNamed:@"glenn"]];
        image.layer.cornerRadius = 65;
        image.layer.masksToBounds = YES;
        [self addSubview:image];
        
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(30.0, y + 220, self.frame.size.width - 100.0f, 30)];
        title.text = [editor objectForKey:@"title"];
        title.textColor = RgbColor(51, 51, 51);
        title.font = [UIFont fontWithName:kFontBreeBold size:20];
        [self addSubview:title];
        
        UILabel* bio = [[UILabel alloc] initWithFrame:CGRectMake(30.0, y + 250, self.frame.size.width - 100.0f, 200)];
        bio.text = [editor objectForKey:@"bio"];
        bio.textColor = RgbColor(51, 51, 51);
        bio.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
        bio.numberOfLines = 0;
        [self addSubview:bio];
        
        y += 450;
    }
    
    [super layoutWithBlock:block offsetY:offsetY];
}

@end
