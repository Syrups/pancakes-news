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
#import "MapEmbeddedBlock.h"
#import "DataEmbeddedBlock.h"
#import "DefinitionEmbeddedBlock.h"
#import "ArticleParagraphLayoutManager.h"
#import "Utils.h"
#import "LettrineParagraph.h"

@implementation GenericBlockCell {
    BOOL layouted;
    BOOL loaded;
    NSMutableDictionary* embeddedBlocks;
    NSMutableDictionary* blockIndexPaths;
    NSMutableArray* items;
    NSMutableDictionary* blockLines;
    NSMutableDictionary* blockButtons;
    NSMutableDictionary* closeButtons;
}

- (id)initWithFrame:(CGRect)frame {
    
    layouted = false;
    embeddedBlocks = @{}.mutableCopy;
    blockLines = @{}.mutableCopy;
    blockButtons = @{}.mutableCopy;
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = kArticleViewBlockBackground;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 30.0f, self.frame.size.width, self.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.tableView];
    
    UIView *storyline = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 38.0f, 0.0f, 1.0f, self.frame.size.height)];
    storyline.backgroundColor = RgbColor(180, 180, 180);
    [self addSubview:storyline];
    
    return self;
}

#pragma mark - Block instanciation

- (DefinitionEmbeddedBlock*) instanciateBlockOfType:(NSString*)blockType withFrame:(CGRect)blockFrame {
    DefinitionEmbeddedBlock* blockView = nil;
    
    if ([blockType isEqualToString:@"map"]) {
        blockView = (MapEmbeddedBlock*)[[MapEmbeddedBlock alloc] initWithFrame:blockFrame];
    } else if ([blockType isEqualToString:@"data"]) {
        blockView = (DataEmbeddedBlock*)[[DataEmbeddedBlock alloc] initWithFrame:blockFrame];
    } else {
        blockView = [[DefinitionEmbeddedBlock alloc] initWithFrame:blockFrame];
    }
    
    return blockView;
}

#pragma mark - Content building with block calls for generic content

- (void)loadWithBlock:(Block*)block {
    
    __block CGFloat offsetY = 0.0f;
    
    if (loaded) return;
    
    ContentParser* parser = [[ContentParser alloc] init];
    
    items = @[].mutableCopy;
    
    for (NSString* p in block.paragraphs) {
        
        [parser parseCallsFromString:p withBlock:^(NSArray *calls) {
            NSString* clean = [parser getCleanedString:p];
            NSMutableAttributedString* content = [[NSMutableAttributedString alloc] initWithString:clean];
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            [style setLineSpacing:kArticleViewTextLineSpacing];
            
            UIView* paragraphView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 120.0f)];
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.0f, self.frame.size.width - 140.0f, 120.0f)];
            
            label.numberOfLines = 0;
            label.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
            
            // Set up the label with attributes
            [content addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
            
            label.textColor = RgbColor(52, 52, 52);
            
            // Configure the label height
            CGSize exceptedSize = [content.string sizeWithFont:label.font constrainedToSize:self.frame.size lineBreakMode:label.lineBreakMode];
            CGRect frame = label.frame;
            frame.size.height = exceptedSize.height + 60.0f;
            label.frame = frame;
            
            // For each call, underline the corresponding portion of
            // text and (TODO) add a button for displaying the called block.
            for (NSDictionary* call in calls) {
                NSRange range;
                [(NSValue*)[call objectForKey:@"textRange"] getValue:&range];
                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithFloat:1.0f] range:range];
                [content addAttribute:NSUnderlineColorAttributeName value:[Utils colorWithHexString:self.articleViewController.displayedArticle.color] range:range];
            }
            
            label.attributedText = content;
            
            // Make lettrine if it is the first paragraph
            if ([block.paragraphs indexOfObject:p] == 0) {
                LettrineParagraph* lettrineParagraph = [[LettrineParagraph alloc] initWithFrame:label.frame];
                [lettrineParagraph layoutWithAttributedString:label.attributedText color:[Utils colorWithHexString:self.articleViewController.displayedArticle.color]];
                [paragraphView addSubview:lettrineParagraph];
            } else {
                [paragraphView addSubview:label];
            }
            
            // Confgure now paragraph view height
            frame = paragraphView.frame;
            frame.size.height = label.frame.size.height;
            paragraphView.frame = frame;
            
            [items addObject:paragraphView];
            
            for (NSDictionary* call in calls) {
                NSString* blockId = [call objectForKey:@"blockId"];
                Block* child = [block childWithId:blockId];
                
                CGRect blockFrame = CGRectMake(40.0f, 0.0f, self.frame.size.width-120.0f, 0.0f);
                DefinitionEmbeddedBlock* blockView = [self instanciateBlockOfType:child.type.name withFrame:blockFrame];
                
                
                [blockView layoutWithBlock:child offsetY:0.0f];
                [blockView setClipsToBounds:YES];
                blockView.article = self.articleViewController.displayedArticle;
                
                [embeddedBlocks setObject:blockView forKey:child.id];
                [blockIndexPaths setObject:blockView forKey:[NSIndexPath indexPathForRow:items.count+1 inSection:0]];
                [items addObject:blockView];
                
                UIButton *blockButton = [[UIButton alloc] initWithFrame:CGRectMake(paragraphView.frame.size.width - 67.0f, offsetY + 40.0f, 60, 60)];
                [blockButton setImage:[self blockButtonImageForType:child.type] forState:UIControlStateNormal];
                [blockButton addTarget:self action:@selector(blockButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                blockButton.tag = [child.id integerValue];
                
                [blockButtons setObject:blockButton forKey:child.id];
                
                [self addSubview:blockButton];
                [self bringSubviewToFront:blockButton];
                
                // Storyline on side
                UIView *storylineOpen = [[UIView alloc] initWithFrame:CGRectMake(paragraphView.frame.size.width - 39, blockView.frame.origin.y, 3.0f, 0)];
                storylineOpen.backgroundColor = kOrangeColor;
                [self addSubview:storylineOpen];
                
                [blockLines setObject:storylineOpen forKey:child.id];
                
            }
            
            offsetY += paragraphView.frame.size.height + 20.0f;

        }];
        
    }
    
    loaded = true;
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

#pragma mark - Block layouting for sections

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
            
            UIView* paragraphView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, originY, self.frame.size.width, 120.0f)];
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.0f, self.frame.size.width - 140.0f, 120.0f)];
            
            label.numberOfLines = 0;
            label.font = [UIFont fontWithName:kFontHeuristicaRegular size:18];
            
            // Finally set the label with attributes
            [content addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, content.length)];
            label.attributedText = content;
            
            label.textColor = RgbColor(52, 52, 52);
            
            // Configure the label height
            CGSize exceptedSize = [content.string sizeWithFont:label.font constrainedToSize:self.frame.size lineBreakMode:label.lineBreakMode];
            CGRect frame = label.frame;
            frame.size.height = exceptedSize.height + 60.0f;
            label.frame = frame;
            
            // Make lettrine if it is the first paragraph
            if ([block.paragraphs indexOfObject:p] == 0 && p.length > 121) {
                LettrineParagraph* lettrineParagraph = [[LettrineParagraph alloc] initWithFrame:label.frame];
                [lettrineParagraph layoutWithAttributedString:label.attributedText color:[Utils colorWithHexString:self.articleViewController.displayedArticle.color]];
                [paragraphView addSubview:lettrineParagraph];
            } else {
                [paragraphView addSubview:label];
            }
            
            [self.contentView addSubview:paragraphView];
            
            // Change the origin Y point for next paragraph
            originY += label.frame.size.height + 10.0f;
            

        }];
        
    }

    layouted = true;
    
//    [self openEmbeddedBlockWithId:@"1" completion:nil];
}

#pragma mark - Actions

- (void)blockButtonTapped:(UIView*)sender {
    NSString* blockId = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    
    [self openEmbeddedBlockWithId:blockId completion:nil];
    
    // Move all the buttons like they're pushed by the opening block
    DefinitionEmbeddedBlock* blockView = [embeddedBlocks objectForKey:blockId];
    
    [blockButtons enumerateKeysAndObjectsUsingBlock:^(id key, UIButton* btn, BOOL *stop) {
        // If this button is ABOVE the tapped button,
        // there's no need to move it down
        if (btn.frame.origin.y > sender.frame.origin.y) {
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect f = btn.frame;
                f.origin.y += blockView.frame.size.height;
                btn.frame = f;
            } completion:^(BOOL finished) {
                [blockButtons setObject:btn forKey:key];
            }];
        }
    }];
}

- (void)closeButtonTapped:(UIView*)sender {
    NSString* blockId = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    
    DefinitionEmbeddedBlock* blockView = [embeddedBlocks objectForKey:blockId];

    CGFloat h = blockView.frame.size.height;
    
    [self closeEmbeddedBlockWithId:blockId];
    
    [sender removeFromSuperview];
    
    // Move all the buttons to their initial position
    
    [blockButtons enumerateKeysAndObjectsUsingBlock:^(id key, UIButton* btn, BOOL *stop) {
        // If this button is ABOVE the tapped button,
        // there's no need to move it up
        if (btn.frame.origin.y > sender.frame.origin.y) {
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect f = btn.frame;
                f.origin.y -= h;
                btn.frame = f;
            } completion:nil];
        }
    }];
}

#pragma mark - Helpers

- (UIImage*)blockButtonImageForType:(BlockType*)type {
//    return [UIImage imageNamed:[@"article-block-button-" stringByAppendingString:type.name]];
    return [UIImage imageNamed:[@"article-block-button-" stringByAppendingString:@"map"]];

}

- (void)openEmbeddedBlockWithId:(NSString *)blockId completion:(void (^)())completion {
    DefinitionEmbeddedBlock* blockView = [embeddedBlocks objectForKey:blockId];

    [self.tableView beginUpdates];
    CGRect f = blockView.frame;
    f.size.height = blockView.block.paragraphs.count * 100.0f + 230.0f;
    blockView.frame = f;
    if (blockView.class == [MapEmbeddedBlock class]) {
        [blockView layoutWithBlock:blockView.block offsetY:0.0f];
    }
    [self.tableView endUpdates];
    
    CGRect cellFrame = [self.tableView rectForRowAtIndexPath:blockView.cellIndexPath];
    
    // Close button
    UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 56, cellFrame.origin.y + 100.0f, 40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"block-close"] forState:UIControlStateNormal];
    closeButton.backgroundColor = [Utils colorWithHexString:self.articleViewController.displayedArticle.color];
    closeButton.layer.cornerRadius = 20;
    closeButton.tag = blockId.integerValue;
    [closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    [closeButtons setObject:closeButton forKey:blockId];
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIView* line = [blockLines objectForKey:blockId];
        CGRect frame = line.frame;

        NSLog(@"%@", blockView.cellIndexPath);
        frame.size.height = blockView.frame.size.height;
        frame.origin.y = cellFrame.origin.y + 30.0f;
        line.frame = frame;
        
        [self.articleViewController.collectionView setContentOffset:CGPointMake(0, self.frame.origin.y + frame.origin.y - 40) animated:YES];
        
    } completion:nil];
    
}

- (void)closeEmbeddedBlockWithId:(NSString*)blockId {
    DefinitionEmbeddedBlock* blockView = [embeddedBlocks objectForKey:blockId];
    
    [self.tableView beginUpdates];
    CGRect f = blockView.frame;
    f.size.height = 0;
    blockView.frame = f;
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIView* line = [blockLines objectForKey:blockId];
        CGRect frame = line.frame;
        
        frame.size.height = 0;
        line.frame = frame;
        
        [self.articleViewController.collectionView setContentOffset:CGPointMake(0, self.frame.origin.y + frame.origin.y - 200) animated:YES];

    } completion:nil];
    
}

- (Block*) blockWithId:(NSString*)blockId {
    Block* block = nil;
    for (Block* b in self.block.children) {
        if ([b.id isEqualToString:blockId]) {
            block = b;
        }
    }
    
    return block;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat h = [(UIView*)[items objectAtIndex:indexPath.row] frame].size.height;
    
    if (h > 0.0f) {
        return h + 20.0f;
    }
    
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UIView* v = [items objectAtIndex:indexPath.row];
    
    [cell.contentView addSubview:v];
    
    if ([v.class isSubclassOfClass:[DefinitionEmbeddedBlock class]]) {
        [(DefinitionEmbeddedBlock*)v setCellIndexPath:indexPath];
    }
    
    return cell;
}

@end
