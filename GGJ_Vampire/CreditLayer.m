//
//  CreditLayer.m
//  GGJ_Vampire
//
//  Created by Gem on 13年1月27日.
//
//

#import "MainMenuLayer.h"
#import "CreditLayer.h"
#import "cocos2d.h"
@implementation CreditLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditLayer *layer = [CreditLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        CCSprite* sprite = [CCSprite spriteWithFile:@"credit.png"];
        sprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:sprite];
        
        self.isTouchEnabled = YES;
    }
    return self;
}


-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}


@end
