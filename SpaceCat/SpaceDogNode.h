//
//  SpaceDogNode.h
//  SpaceCat
//
//  Created by Timan Rebel on 09/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, SpaceDogType) {
    SpaceDogTypeA,
    SpaceDogTypeB
};

@interface SpaceDogNode : SKSpriteNode

+ (instancetype) spaceDogOfType:(SpaceDogType)type;

@end
