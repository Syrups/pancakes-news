//
//  Block.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "JSONModel.h"
#import "BlockType.h"

@protocol Block <NSObject>
@end

@interface Block : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) BlockType* type;
@property (strong, nonatomic) NSString<Optional>* content;
@property (strong, nonatomic) NSString<Optional>* title;
@property (strong, nonatomic) NSString<Optional>* latitude;
@property (strong, nonatomic) NSString<Optional>* longitude;
@property (strong, nonatomic) NSString<Optional>* image;
@property (strong, nonatomic) NSArray<Optional>* paragraphs;
@property (strong, nonatomic) NSArray<Block, Optional>* children;
@property (strong, nonatomic) NSArray<Optional>* editors;
@property (strong, nonatomic) NSString<Optional>* url;

- (Block*)childWithId:(NSString*)blockId;

@end
