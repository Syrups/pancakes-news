//
//  GenericBlockCell.m
//  Pancakes
//
//  Created by Leo on 19/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "GenericBlockCell.h"
#import "Macros.h"
#import "Configuration.h"
#import "DefinitionEmbeddedBlock.h"

@implementation GenericBlockCell {
    BOOL layouted;
    NSMutableDictionary* embeddedBlocks;
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
    
    self.backgroundColor = kArticleViewBlockBackground;
    
    return self;
}

/*
 * Configures and layout the cell with block data from model
 */
- (void)layoutWithBlock:(Block *)block offsetY:(CGFloat)offsetY {
    if (layouted) {
        return;
    }
    
    self.block = block;
    
    ContentParser* parser = [[ContentParser alloc] init];
    
    // margin top
    __block NSInteger originY = offsetY;
    
    // Iterate over each paragraph of the block
    
    for (NSString* p in block.paragraphs) {
        
        __block NSMutableArray* blocksToAppend = [NSMutableArray array];
        
        // Parse eventual block calls
        [parser parseCallsFromString:p withBlock:^(NSArray *calls) {
            
            NSString* clean = [parser getCleanedString:p];
            NSMutableAttributedString* content = [[NSMutableAttributedString alloc] initWithString:clean];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:kArticleViewTextLineSpacing];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, originY, self.frame.size.width - 140.0f, 120.0f)];
            label.numberOfLines = 0;
            label.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
            
            // For each call, underline the corresponding portion of
            // text and (TODO) add a button for displaying the called block.
            for (NSDictionary* call in calls) {
                NSRange range;
                [(NSValue*)[call objectForKey:@"textRange"] getValue:&range];
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithFloat:1.0f] range:range];
                [content addAttribute:NSUnderlineColorAttributeName value:kOrangeColor range:range];
                
                NSString* blockId = [call objectForKey:@"blockId"];
                Block* child = [block childWithId:blockId];
                
                if (child != nil) {
                    [blocksToAppend addObject:child];
                }
            }
            
            // Finally set the label with attributes
            [content addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
            label.attributedText = content;
            
            label.textColor = RgbColor(52, 52, 52);
            
            // Configure the label height
            CGSize exceptedSize = [content.string sizeWithFont:label.font constrainedToSize:self.frame.size lineBreakMode:label.lineBreakMode];
            CGRect frame = label.frame;
            frame.size.height = exceptedSize.height + 60.0f;
            label.frame = frame;
            
            [self.contentView addSubview:label];
            
            // Change the origin Y point for next paragraph
            originY += label.frame.size.height + 10.0f;
            
            // Iterate now over each sub-block called by the current paragraph,
            // and add each of them after it.
            for (Block* block in blocksToAppend) {
                originY += 20.0f;
                DefinitionEmbeddedBlock* blockView = [[DefinitionEmbeddedBlock alloc] initWithFrame:CGRectMake(40.0f, originY, self.frame.size.width-120.0f, 230.0f)];
                
                [blockView layoutWithBlock:block offsetY:0.0f];
//                [blockView setBounds:blockView.frame];
//                [blockView setClipsToBounds:YES];
                [self.contentView addSubview:blockView];
                
                [embeddedBlocks setObject:blockView forKey:block.id];
                
                originY += blockView.frame.size.height + 20.0f;
            }
            
        }];
        
    }

    layouted = true;
    
    [self openEmbeddedBlockWithId:@"1.2" completion:NULL];
}

- (void)openEmbeddedBlockWithId:(NSString *)blockId completion:(void (^)())completion {
    UIView* blockView = [embeddedBlocks objectForKey:blockId];
    
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect f = blockView.frame;
        f.size.height = 200.0f;
        blockView.bounds = f;
        blockView.frame = f;
    } completion:^(BOOL finished) {
        
    }];
}

@end
