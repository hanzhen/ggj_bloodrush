//
//  HighscoreObject.h
//  GGJ_Vampire
//
//  Created by Gem on 13年1月26日.
//
//

#import <Foundation/Foundation.h>


typedef enum Grade{
    Grade_S,
    Grade_AAA,
    Grade_AA,
    Grade_A,
    Grade_B,
    Grade_C,
    Grade_D,
    Grade_E,
    Grade_F,
    Grade_Num
}Grade;

static NSString* gradeString [Grade_Num] ={
    @"S",
    @"AAA",
    @"AA",
    @"A",
    @"B",
    @"C",
    @"D",
    @"E",
    @"F"
};

static NSString* gradeImages [Grade_Num] = {
    @"gfx-rank-s.png",
    @"gfx-rank-aaa.png",
    @"gfx-rank-aa.png",
    @"gfx-rank-a.png",
    @"gfx-rank-b.png",
    @"gfx-rank-c.png",
    @"gfx-rank-d.png",
    @"gfx-rank-e.png",
    @"gfx-rank-f.png"
};

static int gradePercentage [Grade_Num] ={
    100,
    99,
    95,
    90,
    85,
    75,
    65,
    50,
    0
};

@interface HighscoreObject : NSObject<NSCoding>{
    NSString* name;
    int score;
    Grade grade;
}
@property(nonatomic,retain)NSString* name;
@property(nonatomic)int score;
@property(nonatomic)Grade grade;


+ (HighscoreObject*)objectWithName:(NSString*) name withScore:(int) score withGrade:(int) grade_;
- (id) initWithName:(NSString*) name_ withScore:(int) score_ withGrade:(int) grade_;

+(NSData*) encodeWithKeyedArchiver:(HighscoreObject*) object;
+ (HighscoreObject*) decodeWithData:(NSData*) data;
@end
