//
//  HudNode.h
//  SpaceCat
//
//  Created by Timan Rebel on 10/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;

-(void)addPoints:(NSInteger)points;
-(BOOL)looseLife;

@end
