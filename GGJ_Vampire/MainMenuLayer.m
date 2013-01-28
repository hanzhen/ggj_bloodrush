//
//  MainMenuLayer.m
//  GGJ_Vampire
//
//  Created by Gem on 13年1月26日.
//
//

#import "MainMenuLayer.h"
#import "CCScene.h"
#import "CCMenu.h"
#import "MainGameLayer.h"
#import "HighScoreLayer.h"
#import "CreditLayer.h"
#import "SimpleAudioEngine.h"

@implementation MainMenuLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


- (id)init
{
    self = [super init];
    if (self) {
        CCSprite* sprite = [CCSprite spriteWithFile:@"menubg.png"];
        sprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:sprite];
        
        
        CCSprite* selectedSprite = [CCSprite spriteWithFile:@"btn-play.png"];
        selectedSprite.scale = 1.1f;
        CCSprite* normalSprite = [CCSprite spriteWithFile:@"btn-play.png"];
        CCMenuItemSprite* menuItemPlay = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(startGame)];
        
        menuItemPlay.position = ccp(0,-self.contentSize.height*5/24);
        
        selectedSprite = [CCSprite spriteWithFile:@"btn-hiscores.png"];
        selectedSprite.scale = 1.1f;
        normalSprite = [CCSprite spriteWithFile:@"btn-hiscores.png"];
        CCMenuItemSprite* menuItemHiScore = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(highScore)];
        menuItemHiScore.position = ccp(0,-self.contentSize.height*8/24);

        
        selectedSprite = [CCSprite spriteWithFile:@"btn-credits.png"];
        selectedSprite.scale = 1.1f;
        normalSprite = [CCSprite spriteWithFile:@"btn-credits.png"];
        CCMenuItemSprite* menuItemCredit = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(goCredit)];
        menuItemCredit.position = ccp(0,-self.contentSize.height*11/24);

        CCMenu* menu = [CCMenu menuWithItems:menuItemPlay,menuItemHiScore,menuItemCredit, nil];
        [self addChild:menu];

        
        {
            CCDelayTime* delay = [CCDelayTime actionWithDuration:0.6f];
            CCScaleTo* scaleTo1 = [CCScaleTo actionWithDuration:0.1f scale:1.4f];
            CCScaleTo* scaleTo2 = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
            CCSequence* sequence = [CCSequence actions:scaleTo1,scaleTo2,delay, nil];
            CCRepeatForever* repeat = [CCRepeatForever actionWithAction:sequence];
            [menuItemPlay runAction:repeat];
        }

        {
            CCDelayTime* delay = [CCDelayTime actionWithDuration:1.8f];
            CCScaleTo* scaleTo1 = [CCScaleTo actionWithDuration:0.1f scale:1.4f];
            CCScaleTo* scaleTo2 = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
            CCSequence* sequence = [CCSequence actions:scaleTo1,scaleTo2,delay, nil];
            CCRepeatForever* repeat = [CCRepeatForever actionWithAction:sequence];
            [menuItemHiScore runAction:repeat];
        }

        {
            CCDelayTime* delay = [CCDelayTime actionWithDuration:3.0f];
            CCScaleTo* scaleTo1 = [CCScaleTo actionWithDuration:0.1f scale:1.4f];
            CCScaleTo* scaleTo2 = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
            CCSequence* sequence = [CCSequence actions:scaleTo1,scaleTo2,delay, nil];
            CCRepeatForever* repeat = [CCRepeatForever actionWithAction:sequence];
            [menuItemCredit runAction:repeat];
        }

        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"100bpm_2minute_titlemusic.mp3"];
        
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"blood_rush.wav"];
    }
    return self;

}

- (void) startGame{
	[[CCDirector sharedDirector] replaceScene: [MainGameLayer scene]];
}

- (void) highScore{
    [[CCDirector sharedDirector] replaceScene: [HighScoreLayer scene]];
}

- (void) goCredit{
    [[CCDirector sharedDirector] replaceScene: [CreditLayer scene]];
}
@end

