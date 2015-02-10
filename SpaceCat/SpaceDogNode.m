//
//  SpaceDogNode.m
//  SpaceCat
//
//  Created by Timan Rebel on 09/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import "SpaceDogNode.h"
#import "Util.h"

@implementation SpaceDogNode

+ (instancetype) spaceDogOfType:(SpaceDogType)type {
    SpaceDogNode *dog;
    NSArray *textures;
    
    if(type == SpaceDogTypeA) {
        dog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[ [SKTexture textureWithImageNamed:@"spacedog_A_1"],
                      [SKTexture textureWithImageNamed:@"spacedog_A_2"],
                      [SKTexture textureWithImageNamed:@"spacedog_A_3"]];
    } else {
        dog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[ [SKTexture textureWithImageNamed:@"spacedog_B_1"],
                      [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                      [SKTexture textureWithImageNamed:@"spacedog_B_3"],
                      [SKTexture textureWithImageNamed:@"spacedog_B_4"]];
    }
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *forever = [SKAction repeatActionForever:animation];
    
    float scale = [Util randomWithMin:85 Max:100] / 100.0f;
    dog.xScale = scale;
    dog.yScale = scale;
    
    [dog runAction:forever];
    [dog setupPhysicsBody];
    
    return dog;
}

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryProjectile | CollisionCategoryGround;
}

@end
