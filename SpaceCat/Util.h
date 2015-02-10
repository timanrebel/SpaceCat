//
//  Util.h
//  SpaceCat
//
//  Created by Timan Rebel on 09/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int ProjectileSpeed = 400.0;
static const int DogVelocityMin = -100.0;
static const int DogVelocityMax = -50.0;

static const int MaxLives = 3;
static const int PointsPerHit = 50;

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryEnemy          = 1 << 0, // 0001
    CollisionCategoryProjectile     = 1 << 1, // 0010
    CollisionCategoryDebris         = 1 << 2, // 0100
    CollisionCategoryGround         = 1 << 3  // 1000
};

@interface Util : NSObject

+ (NSInteger)randomWithMin:(NSInteger) min Max:(NSInteger) max;

@end
