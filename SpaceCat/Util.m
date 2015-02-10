//
//  Util.m
//  SpaceCat
//
//  Created by Timan Rebel on 09/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSInteger)randomWithMin:(NSInteger) min Max:(NSInteger) max {
    return arc4random()%(max-min)+min;
}

@end
