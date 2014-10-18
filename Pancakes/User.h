//
//  User.h
//  Pancakes
//
//  Created by Leo on 17/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#import "JSONModel.h"

@protocol User <NSObject>
@end

@interface User : JSONModel

@property (strong, nonatomic) NSString* username;

@end
