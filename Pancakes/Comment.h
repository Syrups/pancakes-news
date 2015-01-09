//
//  Comment.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "JSONModel.h"
#import "User.h"

@protocol Comment <NSObject>
@end

@interface Comment : JSONModel

@property (strong, nonatomic) NSString* _id;
@property (strong, nonatomic) NSString* author;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString<Optional>* authorImage;

@end
