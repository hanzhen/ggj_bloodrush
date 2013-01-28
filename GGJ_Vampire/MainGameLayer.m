//
//  HelloWorldLayer.m
//  GGJ_Vimpire
//
//  Created by Gem on 13年1月25日.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "MainGameLayer.h"
#import "StatisticLayer.h"
#import "SimpleAudioEngine.h"
#import "Heart.h"

#define HeartAppearY 298
#define TOUCH_LINE_Y 52
#define NUM_OF_LEVEL 5
#define DISTANCE (TOUCH_LINE_Y - HeartAppearY)

#define TEMPO_TO_TOUCH_LINE 2
#define SPEED_PER_TEMPO (DISTANCE/TEMPO_TO_TOUCH_LINE)

#define NUM_OF_COL 3
#define ROW_END_X 249

#define NUM_OF_TEMPO_FOR_AHEART 1
#define HITINAROW_TO_COMBO 20
#define MISSINAROW_TO_RESETCOMBO 10

#define NUM_OF_BUFF_HEART 20
#define SilenceTimeBetweenLevel 3

#define MAX_COMBO 4
static NSString* comboFileName[MAX_COMBO-1] = {
    @"gfx-combox2.png",
    @"gfx-combox3.png",
    @"gfx-combox4.png"
};

static float tempo[NUM_OF_LEVEL] = {
    60/80.0f,
    60/90.0f,
    60/100.0f,
    60/120.0f,
    60/140.0f
};

//in second
static float gameTime[NUM_OF_LEVEL] = {
    30,
    60,
    90,
    120,
    120
};


static NSString* soundFile[NUM_OF_LEVEL] = {
    @"80bpm_2minute_music.mp3",
    @"90bpm_2minute_music.mp3",
    @"100bpm_2minute_music.mp3",
    @"120bpm_2minute_music.mp3",
    @"140bpm_2minute_music.mp3"
};

typedef enum Performance{
    Performance_Perfect,
    Performance_Good,
    Performance_OK,
    Performance_Miss,
    Performance_Num,
    Performance_NA         //not avaliable if the heart is not in detect range
}Performance;

//record ingame stats
static int performanceStats[Performance_Num] = {
  0,0,0,0
};

static int performanceScore[Performance_Num] = {
    5000/2,
    2500/2,
    1000/2,
    -2000/2
};

static NSString* performanceImageName[Performance_Num] = {
    @"gfx-perfect.png",
    @"gfx-good.png",
    @"gfx-ok.png",
    @"gfx-miss.png"
};

static int performanceRange[Performance_Num] = {
    3,10,20,80
};


@interface MainGameLayer()

- (Performance)getPerformaceForTouchPosition:(CGPoint) touchPosition withNextHeart:(Heart*) heart;
- (float)getColCenterX:(int) col;
- (void) goToLevel:(int) level;
@end

// HelloWorldLayer implementation
@implementation MainGameLayer
@synthesize heartArray;
@synthesize fallingHeartArray;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainGameLayer *layer = [MainGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
//        CCSprite* bg = [CCSprite spriteWithFile:@"bg.png"];
//        [self addChild:bg];
//        
//        CCSprite* baseLine = [CCSprite spriteWithFile:@"baseline.png"];
//        baseLine.position = ccp(ROW_END_X/2,TOUCH_LINE_Y);
//        [self addChild:baseLine];
//
//        for(int i=0;i<NUM_OF_COL;i++){
//            CCSprite* lineSprite  = [CCSprite spriteWithFile:@"line.png"];
//            lineSprite.position = CGPointMake([self getColCenterX:i], 0);
//            [self addChild:lineSprite];
//        }
//
        CCSprite* bg = [CCSprite spriteWithFile:@"maingamebg.png"];
        bg.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:bg];
        
//        barBG = [CCSprite spriteWithFile:@"barbg.png"];
//        barBG.anchorPoint = ccp(0.5,0);
//        barBG.position = ccp(self.contentSize.width - barBG.contentSize.width/2,
//                             0);
//        [self addChild:barBG];

        barFG = [CCSprite spriteWithFile:@"fgbar.png"];
        barFG.anchorPoint = ccp(0.5,0);
        barFG.position = ccp(284,0);
        [self addChild:barFG];
        originalFGRect = barFG.boundingBox;
        self.heartArray = [NSMutableArray array];
        for(int i=0;i<NUM_OF_BUFF_HEART;i++){
            Heart* tempSprite = [Heart spriteWithFile:@"heart.png"];
            [heartArray addObject:tempSprite];
            tempSprite.opacity = 0;
            [self addChild:tempSprite];
        }
    
        
        
        CCLabelBMFont* scoreStringLabel = [CCLabelBMFont labelWithString:@"Score:"
                                                      fntFile:@"modifiedRedFive.fnt"];
        scoreStringLabel.scale  = 0.25f;

        scoreStringLabel.anchorPoint = ccp(0.0,0.0);
        scoreStringLabel.position = ccp(10,self.contentSize.height - scoreStringLabel.contentSize.height/2);
        [self addChild:scoreStringLabel];
        
        scoreLabel = [CCLabelBMFont labelWithString:@"Score"
                                                                 fntFile:@"modifiedRedFive.fnt"];
        scoreLabel.scale  = 0.25f;
        scoreLabel.anchorPoint = ccp(0.5,0.5);
        scoreLabel.position = ccp(scoreStringLabel.position.x + scoreStringLabel.contentSize.width*scoreStringLabel.scale + 120/2,
                                  scoreStringLabel.position.y + scoreLabel.contentSize.height/2*scoreLabel.scale);
        [self addChild:scoreLabel];
        
        
//        CCLabelBMFont* comboStringLabel = [CCLabelBMFont labelWithString:@"Combo:"
//                                                                 fntFile:@"modifiedRedFive.fnt"];
//        comboStringLabel.scale  = 0.18f;
//        comboStringLabel.anchorPoint = ccp(0,0);
//        comboStringLabel.position = ccp(scoreLabel.position.x + scoreLabel.contentSize.width*scoreLabel.scale,
//                                        scoreStringLabel.position.y);
//        [self addChild:comboStringLabel];
//

        comboLabel = [CCLabelBMFont labelWithString:@"X1"
                                            fntFile:@"modifiedRedFive.fnt"];
        combo = 1;
        comboLabel.scale  = 0.25f;
        comboLabel.anchorPoint = ccp(0.5f,0.5f);
        comboLabel.position = ccp(scoreLabel.position.x + scoreLabel.contentSize.width*scoreLabel.scale + 30/2,
                                    scoreLabel.position.y);
        [self addChild:comboLabel];

//        readyLabel = [CCLabelBMFont labelWithString:@"READY"
//                                            fntFile:@"modifiedRedFive.fnt"];
//        readyLabel.scale = 0.6;
//        readyLabel.anchorPoint = ccp(0.5f,0.5f);
//        readyLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
//        readyLabel.visible = false;
//        [self addChild:readyLabel];
//
//        goLabel = [CCLabelBMFont labelWithString:@"GO"
//                                            fntFile:@"modifiedRedFive.fnt"];
//        goLabel.scale = 0.7;
//        goLabel.anchorPoint = ccp(0.5f,0.5f);
//        goLabel.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
//        goLabel.visible = false;
//        [self addChild:goLabel];
        
        readySprite = [CCSprite spriteWithFile:@"gfx-ready.png"];
        readySprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        readySprite.visible = false;
        [self addChild:readySprite];
        
        goSprite = [CCSprite spriteWithFile:@"gfx-go.png"];
        goSprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        goSprite.visible = false;
        [self addChild:goSprite];
        
        
        currentLevelLabel = [CCLabelTTF labelWithString:@"1"
                                               fontName:@"RedFive.ttf"
                                               fontSize:28];
        currentLevelLabel.color = ccRED;
        currentLevelLabel.position = ccp(251,293);
        [self addChild:currentLevelLabel];
        
        [self updateResultDisplay];
//        [self goToLevel:4];
        self.isTouchEnabled = true;

        [self start];        
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ready_go.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"perfect.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"female_1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"female_2.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"male_1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"male_2.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"heart_beat_combo.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"level_up.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"i_suck.wav"];
	}
	return self;
}

- (void) start{
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"ready_go.wav"];
        CCShow* show = [CCShow action];
        CCScaleTo* scaleBy1 = [CCScaleTo actionWithDuration:0.3f scale:1.6f];
        CCScaleTo* scaleBy2 = [CCScaleTo actionWithDuration:0.8f scale:1.0f];
        CCHide* hide = [CCHide action];
        CCSequence* sequnce = [CCSequence actions:show,scaleBy1,scaleBy2,hide, nil];
        [readySprite runAction:sequnce];
    }
    
    {
        CCDelayTime* delayTime = [CCDelayTime actionWithDuration:1.2];
        CCShow* show = [CCShow action];
        CCScaleTo* scaleBy1 = [CCScaleTo actionWithDuration:0.2f scale:1.6f];
        CCScaleTo* scaleBy2 = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
        CCHide* hide = [CCHide action];
        CCCallFuncO* callFunc = [CCCallFuncO actionWithTarget:self selector:@selector(startLevel1)];
        CCSequence* sequnce = [CCSequence actions:delayTime,show,scaleBy1,scaleBy2,hide,callFunc,nil];
        [goSprite runAction:sequnce];
    }    
}


- (void) startLevel1{
    for(int i=0;i<Performance_Num;i++){
        performanceStats[i] = 0;
    }
    totalHeartToPlayed = 0;
    totalHeartPlayed = 0;
    score = 0;
    combo = 1;
    hitInARow = 0;
    missInARow = 0;

    
    [self goToLevel:0];
    
}

- (void) goToLevel:(int) level{
    currentLevel = level;
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:soundFile[currentLevel]];
    accumulatedTime = tempo[level];
    nextHeartIndex = 0;
    speed = SPEED_PER_TEMPO;
    
    currentPercentage = 0;
    timeElapsed = 0;
    
    heartToPlay = [self getNumberOfHeart];
    totalHeartToPlayed += heartToPlay;
    heartMissed = 0;
    heartPlayed = 0;
    
    percentagePerHeart = 100.0f/heartToPlay;
    
    for(int i=0;i<NUM_OF_BUFF_HEART;i++){
        Heart* heart = [heartArray objectAtIndex:i];
        heart.opacity = 0;
    }
    
    currentLevelLabel.string = [NSString stringWithFormat:@"%i",currentLevel+1];
    [self fillUpbarToPercentage:currentPercentage];
    [self schedule:@selector(tick:) interval:1.0f/60.0f];

    self.fallingHeartArray = [NSMutableArray array];
}

- (void)endLevel{
    
    totalScore+=score;
    totalMissed += heartMissed;
    [self unscheduleAllSelectors];
    if(currentLevel >= NUM_OF_LEVEL - 1){
        [self endGame];
    }
    else{
        [self goToLevel:currentLevel+1];
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"gfx-levelup.png"];
        sprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:sprite];
        
        CCMoveBy* moveBy = [CCMoveBy actionWithDuration:1.5f position:ccp(0,80)];
        CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:1.5f];
        CCSpawn* spawnAction = [CCSpawn actions:moveBy,fadeOut, nil];
        CCCallFuncO* callFunc = [CCCallFuncO actionWithTarget:self selector:@selector(removeSpriteFromParent:) object:sprite];
        CCSequence* sequence = [CCSequence actions:spawnAction,callFunc, nil];
        [sprite runAction:sequence];

        [[SimpleAudioEngine sharedEngine] playEffect:@"level_up.wav"];
        
    }
    
}

- (void)goStatistic{
    
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StatisticLayer *layer = [StatisticLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];

    layer.score = totalScore;
    layer.notes = totalHeartToPlayed;
    layer.OK = performanceStats[Performance_OK];
    layer.miss = performanceStats[Performance_Miss];
    layer.good = performanceStats[Performance_Good];
    layer.perfect = performanceStats[Performance_Perfect];
    layer.percentage = 100.0f*totalHeartPlayed/totalHeartToPlayed;
    layer.totalscore = layer.score + performanceStats[Performance_Perfect]*(combo-1)*performanceScore[Performance_Perfect];

    for(int i=0;i<Grade_Num;i++){
        if(layer.percentage >= gradePercentage[i]){
            layer.rating = i;
            break;
        }
    }
    [layer showupStat];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (int)getNumberOfHeart{
    return (int)floorf(gameTime[currentLevel]/(tempo[currentLevel]*NUM_OF_TEMPO_FOR_AHEART));
}

- (void)endGame{
    CCSprite* sprite = [CCSprite spriteWithFile:@"gfx-welldone.png"];
    sprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:sprite];
    sprite.opacity = 0;
    
    CCMoveBy* moveBy = [CCMoveBy actionWithDuration:1.5f position:ccp(0,80)];
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:1.5f];
    CCSpawn* spawnAction = [CCSpawn actions:moveBy,fadeIn, nil];
    CCCallFuncO* callFunc = [CCCallFuncO actionWithTarget:self selector:@selector(goStatistic)];
    CCSequence* sequence = [CCSequence actions:spawnAction,callFunc, nil];
    [sprite runAction:sequence];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"i_made_it.wav"];
}


- (void)failedGame{
    
    totalScore += score;
    totalMissed += heartMissed;
    [self unscheduleAllSelectors];
    CCSprite* sprite = [CCSprite spriteWithFile:@"gfx-gameover.png"];
    sprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
    [self addChild:sprite];
    sprite.opacity = 0;
    
    CCMoveBy* moveBy = [CCMoveBy actionWithDuration:1.5f position:ccp(0,80)];
    CCFadeIn* fadeIn = [CCFadeIn actionWithDuration:1.5f];
    CCSpawn* spawnAction = [CCSpawn actions:moveBy,fadeIn, nil];
    CCCallFuncO* callFunc = [CCCallFuncO actionWithTarget:self selector:@selector(goStatistic)];
    CCSequence* sequence = [CCSequence actions:spawnAction,callFunc, nil];
    [sprite runAction:sequence];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"i_suck.wav"];
}

- (void)tick:(float) timeTicked{
    
    timeElapsed += timeTicked;
    if([fallingHeartArray count] == 0 && heartPlayed >= heartToPlay){
        
        if(timeElapsed > gameTime[currentLevel] + SilenceTimeBetweenLevel){
            [self endLevel];
        }
        return;
    }
    
    
    accumulatedTime += timeTicked;
    int col = arc4random()%3;
    
    float currentTempo = tempo[currentLevel];
    
    if(heartPlayed < heartToPlay && accumulatedTime > currentTempo*NUM_OF_TEMPO_FOR_AHEART){
        accumulatedTime -= currentTempo*NUM_OF_TEMPO_FOR_AHEART;
        
        Heart* tempHeartSprite = [heartArray objectAtIndex:nextHeartIndex];
        tempHeartSprite.col = col;
        tempHeartSprite.opacity = 255;
        tempHeartSprite.position = CGPointMake([self getColCenterX:col], HeartAppearY);
        [fallingHeartArray addObject:tempHeartSprite];
        
        nextHeartIndex ++;
        heartPlayed ++;
        if(nextHeartIndex > [heartArray count] - 1){
            nextHeartIndex = 0;
        }
        
    }
    
    
    for(int i=0;i<[fallingHeartArray count];i++){
        Heart* tempHeartSprite = [fallingHeartArray objectAtIndex:i];
        tempHeartSprite.position = ccpAdd(tempHeartSprite.position, ccp(0, speed*timeTicked/currentTempo));
    
        if(tempHeartSprite.position.y - tempHeartSprite.contentSize.height/2 < TOUCH_LINE_Y - performanceRange[Performance_Miss]){
            [self processWithPerformance:Performance_Miss withHeart:tempHeartSprite];
            i--;
        }
    }
    

}


//col start at 0
- (float) getColCenterX:(int) col{
    if(col == 0){
        return 55;
    }
    else if(col == 1){
        return 126;
    }
    else{
        return 198;
    }
}

//col start at 0
- (int) getColForPosition:(CGPoint) position{

    float colWidth = ROW_END_X/(NUM_OF_COL+1);
    if(position.x < [self getColCenterX:0] + ([self getColCenterX:1] - [self getColCenterX:0])/2){
        return 0;
    }

    if(position.x > [self getColCenterX:1] + ([self getColCenterX:2] - [self getColCenterX:1])/2){
        return NUM_OF_COL-1;
    }
    
    int col = (position.x - colWidth/2)/colWidth;
    return col;
}

- (Performance)getPerformaceForTouchPosition:(CGPoint) touchPosition withNextHeart:(Heart*) heart{
    
    if(heart.position.y > TOUCH_LINE_Y + performanceRange[Performance_Miss]){
        return Performance_NA;
    }
    
    //check column
    int pressCol = [self getColForPosition:touchPosition];
    if(pressCol != heart.col){
        return Performance_Miss;
    }
    
    for(int i=0;i<Performance_Num;i++){
        if(heart.position.y > TOUCH_LINE_Y - performanceRange[i] && heart.position.y < TOUCH_LINE_Y + performanceRange[i]){
            return i;
        }
    }
    
    return Performance_NA;
}


- (void) processWithPerformance:(Performance) performance withHeart:(Heart*) heart{
    if(performance != Performance_NA){
        [fallingHeartArray removeObject:heart];
        [self animateHeartDisappear:heart];
        
        CCSprite* sprite = [CCSprite spriteWithFile:performanceImageName[performance]];
        sprite.position = ccpAdd(ccp(heart.position.x,TOUCH_LINE_Y), ccp(0,60));
        [self addChild:sprite];
        
        CCMoveBy* moveBy = [CCMoveBy actionWithDuration:1.0f position:ccp(0,50)];
        CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:1.0f];
        CCSpawn* spawnAction = [CCSpawn actions:moveBy,fadeOut, nil];
        CCCallFuncO* callFunc = [CCCallFuncO actionWithTarget:self selector:@selector(removeSpriteFromParent:) object:sprite];
        CCSequence* sequence = [CCSequence actions:spawnAction,callFunc, nil];
        [sprite runAction:sequence];
        
        
        if(performance != Performance_Miss){
            hitInARow ++;
            missInARow = 0;
            if(hitInARow >= HITINAROW_TO_COMBO && combo < MAX_COMBO){
                hitInARow = 0;
                combo ++;
                [self animatedLabel:comboLabel];
                [[SimpleAudioEngine sharedEngine] playEffect:@"heart_beat_combo.wav"];
                [self animateHeartBeatCombo];
            }
            
            score += combo*performanceScore[performance] + performanceScore[performance];
            score = MAX(0,score);
            totalHeartPlayed ++;
            
            currentPercentage += percentagePerHeart;
            currentPercentage = fmin(100.0f,currentPercentage);
            if(performance == Performance_Perfect){
                [[SimpleAudioEngine sharedEngine] playEffect:@"perfect.wav"];
            }
            
        }
        else if(performance == Performance_Miss){
            score += combo*performanceScore[performance] + performanceScore[performance];
            score = MAX(0,score);
            hitInARow = 0;
            missInARow ++;
            if(missInARow >= MISSINAROW_TO_RESETCOMBO){
                combo = 1;
            }
            
            
            int random = arc4random()%2;
            if(random == 0){
               [[SimpleAudioEngine sharedEngine] playEffect:@"female_1.wav"];
            }
            else{
               [[SimpleAudioEngine sharedEngine] playEffect:@"female_2.wav"]; 
            }
           
            heartMissed++;
        if((heartMissed+totalMissed)*100.0f/totalHeartToPlayed > 25.0f){
            [self failedGame];
        }
            
        }
        [self animatedLabel:scoreLabel];
        [self updateResultDisplay];
        
        performanceStats[performance]++;
    }
}

- (void) updateResultDisplay{
    scoreLabel.string = [NSString stringWithFormat:@"%.8i",score];
    comboLabel.string = [NSString stringWithFormat:@"X%i",combo];
    [self fillUpbarToPercentage:currentPercentage];
}

- (void) animatedLabel:(CCLabelBMFont*) label{
    
    float originalScale = label.scale;
    CCScaleTo* scaleTo1 = [CCScaleTo actionWithDuration:0.05f scale:originalScale*1.4f];
    CCScaleTo* scaleTo2 = [CCScaleTo actionWithDuration:0.3f scale:originalScale];
    CCSequence* sequence = [CCSequence actions:scaleTo1,scaleTo2, nil];
    
    [label runAction:sequence];
}

- (void)removeSpriteFromParent:(CCSprite*) sprite{
    [self removeChild:sprite cleanup:YES];
}

- (void) animateHeartDisappear:(Heart*) heart{
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:0.5];
    CCScaleBy* scaleby = [CCScaleBy actionWithDuration:0.5f scale:2.0f];
    CCSpawn* spawn = [CCSpawn actions:fadeOut,scaleby,nil];

    CCCallFuncN* callFunc = [CCCallFuncND actionWithTarget:self selector:@selector(resetHeart:) data:heart];
    CCSequence* sequnce = [CCSequence actions:spawn,callFunc, nil];
    [heart runAction:sequnce];
}


- (void)animateHeartBeatCombo{
    
    CCSprite* sprite = [CCSprite spriteWithFile:comboFileName[combo-2]];
    sprite.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [self addChild:sprite];
    
    CCMoveBy* moveBy = [CCMoveBy actionWithDuration:1.0f position:ccp(0,50)];
    CCFadeOut* fadeOut = [CCFadeOut actionWithDuration:1.0f];
    
    CCScaleTo* scaleTo1 = [CCScaleTo actionWithDuration:0.2f scale:1.5f];
    CCScaleTo* scaleTo2 = [CCScaleTo actionWithDuration:0.3f scale:1.0f];
    CCSequence* scaleSequence = [CCSequence actions:scaleTo1,scaleTo2, nil];
    
    CCSpawn* spawnAction = [CCSpawn actions:moveBy,fadeOut,scaleSequence, nil];
    
    CCCallFuncO* callFunc = [CCCallFuncO actionWithTarget:self selector:@selector(removeSpriteFromParent:) object:sprite];
    CCSequence* sequence = [CCSequence actions:spawnAction,callFunc, nil];
    [sprite runAction:sequence];

}


- (void) resetHeart:(Heart*) heart{
    heart.scale = 1.0f;
}



- (void)fillUpbarToPercentage:(float) percentage{

    CGRect newFrame = CGRectMake(0,0,
                               originalFGRect.size.width, originalFGRect.size.height*percentage/100.0f);
    
    [barFG setTextureRect:newFrame];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSArray* array = [touches allObjects];
    for (int i=0; i<[array count];i++ ) {
        UITouch* touch = [array objectAtIndex:i];
        CGPoint convertedPt = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
        
        
        if(convertedPt.y < TOUCH_LINE_Y + performanceRange[Performance_Miss] && convertedPt.y > TOUCH_LINE_Y - performanceRange[Performance_Miss]){
            
            if([fallingHeartArray count] > 0){
                Heart* nextHeart = [fallingHeartArray objectAtIndex:0];
                Performance performance = [self getPerformaceForTouchPosition:convertedPt withNextHeart:nextHeart];
                
                [self processWithPerformance:performance withHeart:nextHeart];
            }
        }
    }
}


- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
