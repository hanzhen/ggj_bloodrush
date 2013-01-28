//
//  StatisticLayer.m
//  GGJ_Vampire
//
//  Created by Gem on 13年1月27日.
//
//

#import "StatisticLayer.h"
#import "cocos2d.h"
#import "MainMenuLayer.h"
#import "MainGameLayer.h"



@implementation StatisticLayer
@synthesize score;
@synthesize notes;
@synthesize miss;
@synthesize OK;
@synthesize good;
@synthesize perfect;
@synthesize percentage;
@synthesize totalscore;
@synthesize rating;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StatisticLayer *layer = [StatisticLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        CCSprite* sprite = [CCSprite spriteWithFile:@"statbg.png"];
        sprite.position = ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:sprite];
        
        
        CCSprite* selectedSprite = [CCSprite spriteWithFile:@"btn-back.png"];
        selectedSprite.scale = 1.1f;
        CCSprite* normalSprite = [CCSprite spriteWithFile:@"btn-back.png"];
        CCMenuItemSprite* menuItemBack = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(backToMainMebu)];
        
        menuItemBack.position = ccp(-80,-self.contentSize.height*10/24);
        
        selectedSprite = [CCSprite spriteWithFile:@"btn-retry.png"];
        selectedSprite.scale = 1.1f;
        normalSprite = [CCSprite spriteWithFile:@"btn-retry.png"];
        CCMenuItemSprite* menuItemRetry = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(retryGame)];
        menuItemRetry.position = ccp(+80,-self.contentSize.height*10/24);
        
        
        CCMenu* menu = [CCMenu menuWithItems:menuItemBack,menuItemRetry, nil];
        [self addChild:menu];
        
        
//        score = 902730123;
//        notes = 500;
//        miss = 50;
//        OK = 23;
//        perfect = 100;
//        good = 50;
//        totalscore = 1209312099;
//        rating = 0;
//        percentage = 93;
//        
//        [self showupStat];
//
    }
    return self;
}


- (void) showupStat{
    {
//        CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",score]
//                                               fontName:@"RedFive.ttf" fontSize:16];
//        
        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",score]
                                                      fntFile:@"modifiedRedFive.fnt"];
        label.scale  = 0.25f;
        label.position = ccp(245,340);
        [self addChild:label];
    }

    {
        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",notes]
                                                      fntFile:@"modifiedRedFive.fnt"];
        label.scale  = 0.25f;
        label.position = ccp(245,316);
        [self addChild:label];
    }

    {
        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",miss]
                                                      fntFile:@"modifiedRedFive.fnt"];
        label.scale  = 0.25f;

        label.position = ccp(245,290);
        [self addChild:label];
    }
    
    {
        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",OK]
                                                      fntFile:@"modifiedRedFive.fnt"];
        label.scale  = 0.25f;

        label.position = ccp(245,266);
        [self addChild:label];
    }
    
    {
        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",good]
                                                      fntFile:@"modifiedRedFive.fnt"];
        label.scale  = 0.25f;
        label.position = ccp(245,242);
        [self addChild:label];
    }
    
    {

        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",perfect]
                                                      fntFile:@"modifiedRedFive.fnt"];
        label.scale  = 0.25f;

        label.position = ccp(245,215);
        [self addChild:label];
    }
    
    {
        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",totalscore]
                                                      fntFile:@"modifiedRedFive.fnt"];
        label.scale  = 0.25f;

        label.position = ccp(245,180);
        [self addChild:label];
    }

    
    {
        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i%%",percentage]
                                                      fntFile:@"modifiedRedFive.fnt"];
        label.scale  = 0.32f;

        label.position = ccp(185,124);
        [self addChild:label];
    }

    
    {
//        CCLabelBMFont* label = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%@",gradeString[rating]]
//                                                      fntFile:@"modifiedRedFive.fnt"];
//        label.scale  = 0.6f;
//
//        label.position = ccp(264,124);
//        [self addChild:label];
        CCSprite* sprite = [CCSprite spriteWithFile:gradeImages[rating]];
        sprite.scale = 0.9f;
        sprite.position = ccp(262,124);
        [self addChild:sprite];

    }

    
    NSMutableArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    BOOL isTop10 = false;
    for(int i=0;i<[array count];i++){
        NSData* highScoreData = [array objectAtIndex:i];
        HighscoreObject* highScoreObject = [HighscoreObject decodeWithData:highScoreData];
        
        if(totalscore >= highScoreObject.score){
            isTop10 = true;
            break;
        }
    }
    
    if(isTop10){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Congratulations!\nYou are Top 10." message:@"Please enter you name." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].delegate = self;
        [av show];
        
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField.text length] < 6){
        return true;
    }
    return false;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
   
    NSMutableArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    for(int i=0;i<[array count];i++){
        NSData* highScoreData = [array objectAtIndex:i];
        HighscoreObject* highScoreObject = [HighscoreObject decodeWithData:highScoreData];
        if(totalscore >= highScoreObject.score){
            HighscoreObject* newHighScoreObject = [HighscoreObject objectWithName:textField.text
                                                                        withScore:totalscore
                                                                        withGrade:rating];
            
            NSMutableArray* newArray = [NSMutableArray arrayWithArray:array];
            [newArray insertObject:[HighscoreObject encodeWithKeyedArchiver:newHighScoreObject] atIndex:i];
            if([newArray count] > 10){
                [newArray removeLastObject];
            }
            [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"highscore"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
    }
    
    
}


- (void)backToMainMebu{
    [[CCDirector sharedDirector] replaceScene:[MainMenuLayer scene]];
}


- (void)retryGame{
    [[CCDirector sharedDirector] replaceScene:[MainGameLayer scene]];
}




@end
