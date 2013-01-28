//
//  HighscoreObject.m
//  GGJ_Vampire
//
//  Created by Gem on 13年1月26日.
//
//

#import "HighscoreObject.h"

@implementation HighscoreObject
@synthesize name;
@synthesize score;
@synthesize grade;

+ (HighscoreObject*)objectWithName:(NSString*) name withScore:(int) score withGrade:(int) grade_{
    return [[[HighscoreObject alloc] initWithName:name withScore:score withGrade:grade_] autorelease];
}

- (id) initWithName:(NSString*) name_ withScore:(int) score_ withGrade:(int) grade_{
    self = [super init];
    if(self != nil){
        self.name = name_;
        self.score = score_;
        self.grade = grade_;
    }
    return self;
}


- (void)dealloc
{
    self.name = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self != nil){
        name = [aDecoder decodeObjectForKey:@"name"];
        score = [aDecoder decodeInt32ForKey:@"score"];
        grade = [aDecoder decodeInt32ForKey:@"grade"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInt32:score forKey:@"score"];
    [aCoder encodeInt32:grade forKey:@"grade"];
}


+(NSData*) encodeWithKeyedArchiver:(HighscoreObject*) object{
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object];
    [archiver finishEncoding];
    return data;
}


+ (HighscoreObject*) decodeWithData:(NSData*) data{
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    HighscoreObject* object = [unarchiver decodeObject];
    [unarchiver finishDecoding];
    return object;
}


@end
