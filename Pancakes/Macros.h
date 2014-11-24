//
//  Macros.h
//  Pancakes
//
//  Created by Leo on 23/10/2014.
//  Copyright (c) 2014 Gobelins. All rights reserved.
//

#ifndef Pancakes_Macros_h
#define Pancakes_Macros_h

#define RgbColor(r, g, b) [UIColor colorWithRed:r/255.0f \
green:g/255.0f \
blue:b/255.0f \
alpha:1.0f]

#define RgbaColor(r, g, b, a) [UIColor colorWithRed:r/255.0f \
green:g/255.0f \
blue:b/255.0f \
alpha:a]

// pi is approximately equal to 3.14159265359.
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

#endif
