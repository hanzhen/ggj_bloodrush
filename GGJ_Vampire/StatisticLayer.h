//
//  StatisticLayer.h
//  GGJ_Vampire
//
//  Created by Gem on 13年1月27日.
//
//

#import "CCLayer.h"
#import "HighscoreObject.h"

@interface StatisticLayer : CCLayer<UITextFieldDelegate>{
    int score;
    int notes;
    int miss;
    int OK;
    int good;
    int perfect;
    int percentage;
    int totalscore;
    Grade rating;
}
@property(nonatomic)int score;
@property(nonatomic)int notes;
@property(nonatomic)int miss;
@property(nonatomic)int OK;
@property(nonatomic)int good;
@property(nonatomic)int perfect;
@property(nonatomic)int percentage;
@property(nonatomic)int totalscore;
@property(nonatomic)Grade rating;
+(CCScene *) scene;
- (void) showupStat;
@end
