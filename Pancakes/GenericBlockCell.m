//
//  GenericBlockCell.m
//  Pancakes
//
//  Created by Leo on 19/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "GenericBlockCell.h"
#import "Macros.h"

@implementation GenericBlockCell {
    BOOL layouted;
}

@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame {
    
    layouted = false;
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[GenericBlockCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

/*
 * Configures and layout the cell with block data from model
 */
- (void)layoutWithBlock:(Block *)block {
    if (layouted) {
        return;
    }
    
    self.block = block;
    
    ContentParser* parser = [[ContentParser alloc] init];
    
    __block NSInteger originY = 0.0f;
    
    // Iterate over each paragraph of the block
    
    for (NSString* p in block.paragraphs) {
        
        __block NSMutableArray* blocksToAppend = [NSMutableArray array];
        
        // Parse eventual block calls
        [parser parseCallsFromString:p withBlock:^(NSArray *calls) {
            
            NSString* clean = [parser getCleanedString:p];
            NSMutableAttributedString* content = [[NSMutableAttributedString alloc] initWithString:clean];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, originY, self.frame.size.width - 80.0f, 120.0f)];
            label.numberOfLines = 0;
            
            // For each call, underline the corresponding portion of
            // text and (TODO) add a button for displaying the called block.
            for (NSDictionary* call in calls) {
                NSRange range;
                [(NSValue*)[call objectForKey:@"textRange"] getValue:&range];
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:range];
                
                NSString* blockId = [call objectForKey:@"blockId"];
                Block* child = [block childWithId:blockId];
                
                if (child != nil) {
                    [blocksToAppend addObject:child];
                }
            }
            
            // Finally set the label with attributes
            label.attributedText = content;
            
            // Configure the label height
            CGSize exceptedSize = [content.string sizeWithFont:label.font constrainedToSize:self.frame.size lineBreakMode:label.lineBreakMode];
            CGRect frame = label.frame;
            frame.size.height = exceptedSize.height + 40.0f;
            label.frame = frame;
            
            
            [self addSubview:label];
            
            // Change the origin Y point for next paragraph
            originY += label.frame.size.height;
            
            // Iterate now over each sub-block called by the current paragraph,
            // and add each of them after it.
            for (Block* block in blocksToAppend) {
                
                // Append each sub-block paragraph
                for (NSString* p in block.paragraphs) {
                    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, originY, self.frame.size.width - 80.0f, 100.0f)];
                    label.numberOfLines = 0;
                    label.text = p;
                    
                    // Configure the label height
                    CGSize exceptedSize = [p sizeWithFont:label.font constrainedToSize:self.frame.size lineBreakMode:label.lineBreakMode];
                    CGRect frame = label.frame;
                    frame.size.height = exceptedSize.height + 40.0f;
                    label.frame = frame;
                    
                    [self addSubview:label];
                    
                    originY += label.frame.size.height;
                    
                }
            }
            
            
            
        }];
        
    }

    
//    UIFont *font=[UIFont fontWithName:@"Arial" size:14.f];
//    NSDictionary *attrsDict=[NSDictionary dictionaryWithObject:font
//                                                        forKey:NSFontAttributeName];
//    NSMutableAttributedString *attribString=[[NSMutableAttributedString alloc] initWithString:self.textLabel.text   attributes:attrsDict];
//    
//    
//    UIFont *fontFirst=[UIFont fontWithName:@"Arial" size:50.f];
//    NSDictionary *attrsDictFirst=[NSDictionary dictionaryWithObject:fontFirst forKey:NSFontAttributeName];
//    NSAttributedString *firstString=[[NSAttributedString alloc] initWithString:[attribString.string substringToIndex:1] attributes:attrsDictFirst];
//    
//    [attribString replaceCharactersInRange:NSMakeRange(0, 1)  withAttributedString:firstString];
//    self.textLabel.attributedText = attribString;
    
    layouted = true;
}


@end
