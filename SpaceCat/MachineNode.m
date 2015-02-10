//
//  MachineNode.m
//  SpaceCat
//
//  Created by Timan Rebel on 09/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import "MachineNode.h"

@implementation MachineNode

+ (instancetype)machineAtPosition:(CGPoint)position
{
    MachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
    machine.name = @"Machine";
    machine.position = position;
    machine.anchorPoint = CGPointMake(0.5, 0);
    machine.zPosition = 4;
    
    NSArray *textures = @[ [SKTexture textureWithImageNamed:@"machine_1"],
                           [SKTexture textureWithImageNamed:@"machine_2"] ];

    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    
    [machine runAction:machineRepeat];
    
    return machine;
}

@end
