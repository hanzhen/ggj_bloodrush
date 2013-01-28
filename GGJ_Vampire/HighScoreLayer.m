//
//  HighScoreLayer.m
//  GGJ_Vampire
//
//  Created by Gem on 13年1月26日.
//
//

#import "HighScoreLayer.h"
#import "cocos2d.h"
#import "HighscoreObject.h"
#import "MainMenuLayer.h"
@implementation HighScoreLayer


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HighScoreLayer *layer = [HighScoreLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        CCSprite* bg = [CCSprite spriteWithFile:@"highscorebg.png"];
        bg.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:bg];
        
        NSMutableArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
        
        if(array != nil){
            
            int startPosY = self.contentSize.height - 183;
            for(int i=0;i<[array count];i++){
                NSData* highScoreData = [array objectAtIndex:i];
                int yPos = startPosY - 25*(i+1);
                
                HighscoreObject* highScoreObject = [HighscoreObject decodeWithData:highScoreData];
                
//                CCLabelTTF* rankLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i.",i+1]
//                                                                 fontName:@"RedFive.ttf"
//                                                                 fontSize:14];
//                rankLabel.color =  ccRED;
//                rankLabel.position = ccp(self.contentSize.width/2 - 90,yPos);
//                [self addChild:rankLabel];

                
                
                CCLabelBMFont* nameStringLabel = [CCLabelBMFont labelWithString:highScoreObject.name
                                                    fntFile:@"modifiedRedFive.fnt"];

                nameStringLabel.scale = 0.25;
                nameStringLabel.position = ccp(self.contentSize.width/2 - 60,yPos);
                [self addChild:nameStringLabel];

                CCLabelBMFont* scoreStringLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%.8i",highScoreObject.score]
                                                                         fntFile:@"modifiedRedFive.fnt"];
                scoreStringLabel.scale = 0.25;
                scoreStringLabel.position = ccp(self.contentSize.width/2 + 40,yPos);
                [self addChild:scoreStringLabel];

//                CCLabelBMFont* gradeStringLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%@",gradeString[highScoreObject.grade]]
//                                                                  fntFile:@"modifiedRedFive.fnt"];
//                gradeStringLabel.scale = 0.35;
//                gradeStringLabel.position = ccp(self.contentSize.width/2 + 120,yPos);
//                [self addChild:gradeStringLabel];
                
                CCSprite* sprite = [CCSprite spriteWithFile:gradeImages[highScoreObject.grade]];
                sprite.scale = 0.5f;
                sprite.position = ccp(self.contentSize.width/2 + 120,yPos);
                [self addChild:sprite];
            }
        }
        
        self.isTouchEnabled = true;
    }
    return self;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}


@end
