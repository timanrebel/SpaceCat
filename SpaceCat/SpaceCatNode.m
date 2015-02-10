//
//  SpaceCatNode.m
//  SpaceCat
//
//  Created by Timan Rebel on 09/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import "SpaceCatNode.h"

@interface SpaceCatNode ()

@property (nonatomic, strong) SKAction *tapAction;

@end

@implementation SpaceCatNode

+ (instancetype)spaceCatAtPosition:(CGPoint)position
{
    SpaceCatNode *cat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    cat.name = @"SpaceCat";
    cat.position = position;
    cat.anchorPoint = CGPointMake(0.5, 0);
    cat.zPosition = 5;
    
    return cat;
}

- (SKAction *) tapAction {
    // Only initialize once
    if(_tapAction != nil)
        return _tapAction;
    
    NSArray *textures = @[ [SKTexture textureWithImageNamed:@"spacecat_2"],
                           [SKTexture textureWithImageNamed:@"spacecat_1"] ];
    
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];

    return _tapAction;
}

- (void)performTap {
    [self runAction:self.tapAction];
}

@end
