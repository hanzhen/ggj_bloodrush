//
//  HelloWorldLayer.h
//  GGJ_Vimpire
//
//  Created by Gem on 13年1月25日.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface MainGameLayer : CCLayer<CCStandardTouchDelegate>
{
    NSMutableArray* heartArray;
    NSMutableArray* fallingHeartArray;
    int nextHeartIndex;
    
    int currentLevel;

    float accumulatedTime;
    float speed;
    
    //score for all levels
    int totalScore;
    int score;
    int combo;
    CCLabelBMFont* scoreLabel;
    CCLabelBMFont* comboLabel;
    CCLabelBMFont* currentLevelLabel;
    
    //heart played for all levels
    int totalHeartToPlayed;
    int totalHeartPlayed;
    int totalMissed;
    
    int heartToPlay;
    int heartMissed;
    int heartPlayed;
    
    int hitInARow;
    int missInARow;
    float currentPercentage;
    float percentagePerHeart;
    float timeElapsed;
    
    CCSprite* barFG;
    
    CGRect originalFGRect;
    
//    CCLabelBMFont* readyLabel;
//    CCLabelBMFont* goLabel;
    CCSprite* readySprite;
    CCSprite* goSprite;
}
@property(nonatomic,retain)NSMutableArray* heartArray;
@property(nonatomic,retain)NSMutableArray* fallingHeartArray;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@end
