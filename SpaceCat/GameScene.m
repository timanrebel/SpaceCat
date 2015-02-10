//
//  GameScene.m
//  SpaceCat
//
//  Created by Timan Rebel on 06/02/15.
//  Copyright (c) 2015 Rebelcorp. All rights reserved.
//

#import "GameScene.h"
#import "Util.h"

#import "MachineNode.h"
#import "SpaceCatNode.h"
#import "ProjectileNode.h"
#import "SpaceDogNode.h"
#import "GroundNode.h"
#import "HudNode.h"
#import "GameOverNode.h"

#import <AVFoundation/AVFoundation.h>

@interface GameScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;

// Sounds
@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;

@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL gameOverDisplayed;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    // Game mechanic setup
    self.lastUpdateTimeInterval = 0;
    self.timeSinceEnemyAdded = 0;
    self.totalGameTime = 0;
    self.minSpeed = DogVelocityMin;
    self.addEnemyTimeInterval = 1.5;
    self.gameOver = NO;
    
    // Setup physics
    self.physicsWorld.gravity = CGVectorMake(0, -9.8);
    self.physicsWorld.contactDelegate = self;
    
    // Add HUD
    HudNode *hud = [HudNode hudAtPosition:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame];
    
    // Add background
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    // Add ground
    GroundNode *ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
    
    // Add Machine + cat
    MachineNode *machine = [MachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
    SpaceCatNode *cat = [SpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y-2)];
    
    [self addChild:background];
    [self addChild:machine];
    [self addChild:cat];
    [self addChild:ground];
    [self addChild:hud];
    
    [self setupSounds];
}

- (void)addSpaceDog {
    NSUInteger randomSpaceDog = [Util randomWithMin:0 Max:2];
    
    SpaceDogNode *dog = [SpaceDogNode spaceDogOfType:randomSpaceDog];
    dog.physicsBody.velocity = CGVectorMake(0, [Util randomWithMin:DogVelocityMin Max:DogVelocityMax]);
    
    float x = [Util randomWithMin:10 + dog.size.width Max:self.frame.size.width - 10];
    float y = self.frame.size.height + dog.size.height;
    
    dog.position = CGPointMake(x, y);
    
    [self addChild:dog];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // if game over
    if(self.gameOver) {
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        
        GameScene *gameScene = [GameScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:gameScene];
        
        return;
    }
    
    // If not game over
    for(UITouch *touch in touches) {
        CGPoint position = [touch locationInNode:self];
        
        // Shoot projectile
        [self shootProjectileToPosition:position];
        
        // Animate cat
        SpaceCatNode *cat = (SpaceCatNode *) [self childNodeWithName:@"SpaceCat"];
        [cat performTap];
    }
}

- (void)shootProjectileToPosition:(CGPoint)position {
    MachineNode *machine = (MachineNode *)[self childNodeWithName:@"Machine"];
    ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y + machine.frame.size.height - 15)];
    
    [self addChild:projectile];
    
    [projectile moveTowardsPosition:position];
    
    [self runAction:self.laserSFX];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if(firstBody.categoryBitMask == CollisionCategoryEnemy && secondBody.categoryBitMask == CollisionCategoryProjectile) {
        
        SpaceDogNode *dog = (SpaceDogNode *) firstBody.node;
        ProjectileNode *projectile = (ProjectileNode *) secondBody.node;
        
        [dog removeFromParent];
        [projectile removeFromParent];
        
        [self runAction:self.explodeSFX];
        
        [self addPoints:PointsPerHit];
    } else if(firstBody.categoryBitMask == CollisionCategoryEnemy && secondBody.categoryBitMask == CollisionCategoryGround) {
       
        SpaceDogNode *dog = (SpaceDogNode *) firstBody.node;
        
        [dog removeFromParent];
        
        [self runAction:self.damageSFX];
        
        [self looseLife];
    }
    
    [self createDebrisAtPosition:contact.contactPoint];
}

- (void)createDebrisAtPosition:(CGPoint)position {
    NSInteger numberOfPieces = [Util randomWithMin:5 Max:20];
    
    for(int i = 0; i < numberOfPieces; i++) {
        NSInteger randomPiece = [Util randomWithMin:1 Max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%d", randomPiece];
        
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.name = @"Debris";
        debris.position = position;
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = CollisionCategoryDebris;
        debris.physicsBody.collisionBitMask = CollisionCategoryGround | CollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.velocity = CGVectorMake([Util randomWithMin:-150 Max:150], [Util randomWithMin:150 Max:350]);
        
        [debris runAction:[SKAction waitForDuration:[Util randomWithMin:1 Max:3]] completion:^{
            [debris removeFromParent];
        }];
        
        [self addChild:debris];
    }
    
    // Add Explosion
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"ExplosionParticle" ofType:@"sks"];

    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    explosion.zPosition = 100;
    
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
    
    [self addChild:explosion];
    
    
}

- (void)update:(NSTimeInterval)currentTime {
    if(self.gameOver) {
        [self performGameOver];
        return;
    }
    
    if(self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    if(self.timeSinceEnemyAdded > self.addEnemyTimeInterval) {
        [self addSpaceDog];
        
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    // Increase difficulty
    if(self.totalGameTime > 480) {
        self.addEnemyTimeInterval = 0.5;
        self.minSpeed = -160;
    } else if(self.totalGameTime > 240) {
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    } else if(self.totalGameTime > 120) {
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    } else if(self.totalGameTime > 30) {
        self.addEnemyTimeInterval = 1.0;
        self.minSpeed = -100;
    }
}

- (void)setupSounds {
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
    
    // background sound
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];
    [self.backgroundMusic play];
    
    // gameover sound
    NSURL *gameOverUrl = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@"mp3"];
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverUrl error:nil];
    self.gameOverMusic.numberOfLoops = -1;
    [self.gameOverMusic prepareToPlay];
}

- (void)addPoints:(NSInteger)points {
    HudNode *hud = (HudNode *) [self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}

-(void)looseLife {
    HudNode *hud = (HudNode *) [self childNodeWithName:@"HUD"];
    self.gameOver = [hud looseLife];
}

-(void)performGameOver {
    if(!self.gameOverDisplayed) {
        GameOverNode *gameOver = [GameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidX(self.view.bounds))];
        [self addChild:gameOver];
        
        self.gameOverDisplayed = true;
        
        [self.backgroundMusic stop];
        [self.gameOverMusic play];
    }
}

@end
