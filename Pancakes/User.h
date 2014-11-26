//
//  User.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "JSONModel.h"
#import "SubThemeInterest.h"

@protocol User <NSObject>
@end

@interface User : JSONModel

//@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString<Optional>* _id;
@property (strong, nonatomic) NSString<Optional>* facebookId;
@property (strong, nonatomic) NSString* phantomId;
@property (strong, nonatomic) NSMutableArray<Optional>* interests;


@end

