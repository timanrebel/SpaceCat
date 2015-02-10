//
//  HudNode.m
//  SpaceCat
//
//  Created by Timan Rebel on 10/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import "HudNode.h"
#import "Util.h"

@implementation HudNode

+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame {
    HudNode *hud = [self node];
    hud.name = @"HUD";
    hud.position = position;
    hud.zPosition = 9999;
    hud.lives = MaxLives;
    
    // Add cat head
    SKSpriteNode *catHead = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_cat_1"];
    catHead.position = CGPointMake(position.x + 30, -10);
    
    // Add initial lives
    for(int i = 0; i < hud.lives; i++) {
        SKSpriteNode *liveBar = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_life_1"];
        liveBar.name = [NSString stringWithFormat:@"Life_%d", i+1];
        liveBar.position = CGPointMake(catHead.position.x + catHead.size.width + (10 * i), catHead.position.y);
        
        [hud addChild:liveBar];
    }
    
    // Add scrore
    SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"Future-CondensedExtraBold"];
    score.name = @"Score";
    score.text = @"0";
    score.fontSize = 24;
    score.fontColor = [SKColor whiteColor];
    score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    score.position = CGPointMake(frame.size.width - 20, catHead.position.y);
    
    [hud addChild:catHead];
    [hud addChild:score];
    
    return hud;
}

-(void)addPoints:(NSInteger)points {
    self.score += points;
    
    SKLabelNode *score = (SKLabelNode *) [self childNodeWithName:@"Score"];
    score.text = [NSString stringWithFormat:@"%d points", self.score];
}

-(BOOL)looseLife {
    if(self.lives < 1)
        return YES;
    
    SKNode *lifeToremove = [self childNodeWithName:[NSString stringWithFormat:@"Life_%d", self.lives]];
    [lifeToremove removeFromParent];
    
    self.lives--;
    
    return self.lives < 1;
}

@end
