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
#import "DefinitionEmbeddedBlock.h"

@implementation GenericBlockCell {
    BOOL layouted;
    BOOL loaded;
    NSMutableDictionary* embeddedBlocks;
    NSMutableDictionary* blockIndexPaths;
    NSMutableArray* items;
}

- (id)initWithFrame:(CGRect)frame {
    
    layouted = false;
    embeddedBlocks = @{}.mutableCopy;
    self = [super initWithFrame:frame];
    
    self.backgroundColor = kArticleViewBlockBackground;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.tableView];
    
    UIView *storyline = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 39.0f, 0.0f, 1.0f, self.frame.size.height)];
    storyline.backgroundColor = RgbColor(180, 180, 180);
    [self addSubview:storyline];
    
    return self;
}

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
                [content addAttribute:NSUnderlineColorAttributeName value:kOrangeColor range:range];
            }
            
            label.attributedText = content;
            
            [paragraphView addSubview:label];
            
            // Confgure now paragraph view height
            frame = paragraphView.frame;
            frame.size.height = label.frame.size.height;
            paragraphView.frame = frame;
            
            [items addObject:paragraphView];
            
            offsetY += label.frame.size.height;
            
            for (NSDictionary* call in calls) {
                NSString* blockId = [call objectForKey:@"blockId"];
                Block* child = [block childWithId:blockId];
                
                DefinitionEmbeddedBlock* blockView = nil;
                
//                CGRect blockFrame = CGRectMake(40.0f, 0.0f, self.frame.size.width-120.0f, 230.0f + child.paragraphs.count * 100.0f);
                CGRect blockFrame = CGRectMake(40.0f, 0.0f, self.frame.size.width-120.0f, 0.0f);

                if ([child.type.name isEqualToString:@"map"]) {
                    blockView = (MapEmbeddedBlock*)[[MapEmbeddedBlock alloc] initWithFrame:blockFrame];
                } else {
                    blockView = [[DefinitionEmbeddedBlock alloc] initWithFrame:blockFrame];
                }
                
                NSLog(@"%@", block.type);
                
                [blockView layoutWithBlock:child offsetY:0.0f];
                [blockView setClipsToBounds:YES];
                
                [embeddedBlocks setObject:blockView forKey:child.id];
                [blockIndexPaths setObject:blockView forKey:[NSIndexPath indexPathForRow:items.count+1 inSection:0]];
                [items addObject:blockView];
                
                UIButton *blockButton = [[UIButton alloc] initWithFrame:CGRectMake(paragraphView.frame.size.width - 67.0f, offsetY, 60, 60)];
                [blockButton setImage:[UIImage imageNamed:@"article-block-button-map"] forState:UIControlStateNormal];
                [blockButton addTarget:self action:@selector(blockButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                blockButton.tag = [child.id integerValue];
                
                [self addSubview:blockButton];
                [self bringSubviewToFront:blockButton];
                
            }

        }];
        
    }
    
    loaded = true;
}

- (void)reloadTableView {
    [self.tableView reloadData];
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
            
//             Iterate now over each sub-block called by the current paragraph,
//             and add each of them after it.
            for (Block* block in blocksToAppend) {
                originY += 20.0f;
                
                CGRect blockFrame = CGRectMake(40.0f, originY, self.frame.size.width-120.0f, 230.0f + block.paragraphs.count * 100.0f);
//                CGRect blockFrame = CGRectMake(40.0f, originY, self.frame.size.width-120.0f, 0.0f);
                
                DefinitionEmbeddedBlock* blockView = nil;
                
                if ([block.type.name isEqualToString:@"map"]) {
                    blockView = (MapEmbeddedBlock*)[[MapEmbeddedBlock alloc] initWithFrame:blockFrame];
                } else {
                    blockView = [[DefinitionEmbeddedBlock alloc] initWithFrame:blockFrame];
                }
                
                [blockView layoutWithBlock:block offsetY:0.0f];
                [blockView setClipsToBounds:YES];
                [self.contentView addSubview:blockView];
                
                [embeddedBlocks setObject:blockView forKey:block.id];
                
                originY += blockView.frame.size.height + 20.0f;
            }
            
        }];
        
    }

    layouted = true;
    
//    [self openEmbeddedBlockWithId:@"1" completion:nil];
}

#pragma mark - Actions

- (void)blockButtonTapped:(UIView*)sender {
    NSString* blockId = [NSString stringWithFormat:@"%d", sender.tag];
    
    [self openEmbeddedBlockWithId:blockId completion:^{
        // stuff
    }];
}

#pragma mark - Helpers

- (void)openEmbeddedBlockWithId:(NSString *)blockId completion:(void (^)())completion {
    DefinitionEmbeddedBlock* blockView = [embeddedBlocks objectForKey:blockId];

    [self.tableView beginUpdates];
    CGRect f = blockView.frame;
    f.size.height = blockView.block.paragraphs.count * 100.0f + 230.0f;
    blockView.frame = f;
    [blockView layoutWithBlock:blockView.block offsetY:0.0f];
    [self.tableView endUpdates];
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
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d", indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UIView* v = [items objectAtIndex:indexPath.row];
    
    [cell.contentView addSubview:v];
    
    return cell;
}

@end
