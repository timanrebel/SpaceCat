//
//  ProjectileNode.m
//  SpaceCat
//
//  Created by Timan Rebel on 09/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import "ProjectileNode.h"
#import "Util.h"

@implementation ProjectileNode

+ (instancetype) projectileAtPosition:(CGPoint) position {
    ProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    [projectile setupAnimation];
    [projectile setupPhysicsBody];
    
    return projectile;
}

- (void)setupAnimation {
    NSArray *textures = @[ [SKTexture textureWithImageNamed:@"projectile_1"],
                           [SKTexture textureWithImageNamed:@"projectile_2"],
                           [SKTexture textureWithImageNamed:@"projectile_3"] ];
    
    SKAction *projectileAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *projectileRepeat = [SKAction repeatActionForever:projectileAnimation];
    
    [self runAction:projectileRepeat];
}

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = CollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryEnemy;
}

- (void)moveTowardsPosition:(CGPoint)position {
    // slope = (Y3 - Y1) / (X3 - X1)
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    
    // slope = (Y2 - Y1) / (X2 - X1)
    // Y2 = slope * X2 - slope * X1 + Y1
    float offscreenX = position.x <= self.position.x ? -10 : self.parent.frame.size.width + 10;
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    
    CGPoint pointOffscreen = CGPointMake(offscreenX, offscreenY);
    
    float distanceA = pointOffscreen.y - self.position.y;
    float distanceB = pointOffscreen.x - self.position.x;
    float distanceC = sqrtf(powf(distanceA, 2) + powf(distanceB, 2));
    
    // distance = speed * time
    // time = distance / speed
    float time = distanceC / ProjectileSpeed;
    float waitTime = time * 0.6;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffscreen duration:time];
    SKAction *waitAction = [SKAction waitForDuration:waitTime];
    SKAction *fadeAction = [SKAction fadeOutWithDuration:time - waitTime];

    [self runAction:moveProjectile];
    [self runAction:[SKAction sequence:@[waitAction, fadeAction, [SKAction removeFromParent]]]];
}

@end
