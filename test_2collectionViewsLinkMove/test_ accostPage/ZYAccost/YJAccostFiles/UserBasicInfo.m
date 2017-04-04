//
//  UserBasicInfo.m
//  MeYou
//
//  Created by hower on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserBasicInfo.h"
#import "NSDate+Additions.h"
#import "U6Common.h"
#import "YJEmoji.h"

@implementation UserBasicInfo

@synthesize iRelation = _iRelation;
@synthesize iLove = _iLove;
@synthesize fansStatus = _fansStatus;
@synthesize iFansNum = _iFansNum;
@synthesize iWithWho = _iWithWho;
@synthesize iBeginAge = _iBeginAge;
@synthesize iEndAge = _iEndAge;
@synthesize iHoroscope = _iHoroscope;
@synthesize birthdayString = _birthdayString;
@synthesize thinkTextString = _thinkTextString;
@synthesize bloodString = _bloodString;

@synthesize iVisitNum = _iVisitNum;
@synthesize iSalary = _iSalary;
@synthesize iHeight = _iHeight;
@synthesize iOccupationType = _iOccupationType;
@synthesize hobbiesString = _hobbiesString;
@synthesize homePageString = _homePageString;
@synthesize addressString = _addressString;

@synthesize iFavoritesids = _iFavoritesids;
@synthesize iFavorites = _iFavorites;
@synthesize iLoveExp = _iLoveExp;
@synthesize iIncome = _iIncome;
@synthesize iHouse = _iHouse;
@synthesize iCar = _iCar;

- (id)init
{
    if (self = [super init]) 
    {
        self.iRelation = 2;
        self.birthdayString = @"";
        self.thinkTextString = @"";
        self.bloodString = @"";
        self.hobbiesString = @"";
        self.homePageString = @"";
        self.addressString = @"";
        self.wantInfo = nil;
        self.schoolInfo = nil;
    }
    return self;
}

- (void)dealloc
{
	self.birthdayString = nil;
	self.bloodString = nil;
	self.thinkTextString = nil;
    self.homePageString = nil;
    self.hobbiesString = nil;
    self.addressString = nil;
    self.wantInfo = nil;
    self.companyString = nil;
    self.turnoffsString = nil;
    self.hometownString = nil;
    self.languagesString = nil;
    self.dialectsNameString = nil;
    self.schoolInfo = nil;
    
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    UserBasicInfo *basicInfo = [super copyWithZone:zone];
    
    basicInfo.iRelation = self.iRelation;
    basicInfo.iFansNum = self.iFansNum;
    basicInfo.birthdayString = self.birthdayString;
    basicInfo.bloodString = self.bloodString;
    basicInfo.iHoroscope = self.iHoroscope;
    basicInfo.fansStatus = self.fansStatus;
    basicInfo.thinkTextString = self.thinkTextString;
    basicInfo.iWithWho = self.iWithWho;
    basicInfo.iBeginAge = self.iBeginAge;
    basicInfo.iEndAge = self.iEndAge;
    basicInfo.iLove = self.iLove;
    basicInfo.iVisitNum = self.iVisitNum;
    basicInfo.iSalary = self.iSalary;
    basicInfo.iHeight = self.iHeight;
    basicInfo.iOccupationType = self.iOccupationType;
    basicInfo.hobbiesString = self.hobbiesString;
    basicInfo.homePageString = self.homePageString;
    basicInfo.addressString = self.addressString;
    basicInfo.iBodyType =self.iBodyType;
    basicInfo.iWeight = self.iWeight;
    basicInfo.dialectsNameString = self.dialectsNameString;
    basicInfo.languagesString = self.languagesString;
    basicInfo.hometownString = self.hometownString;
    basicInfo.companyString = self.companyString;
    basicInfo.turnoffsString = self.turnoffsString;
    
    basicInfo.iFavoritesids = self.iFavoritesids;
    basicInfo.iFavorites = self.iFavorites;
    basicInfo.iLoveExp = self.iLoveExp;
    basicInfo.iIncome = self.iIncome;
    basicInfo.iHouse = self.iHouse;
    basicInfo.iCar = self.iCar;
    
    WantsUserInfo* wantsInfo = [self.wantInfo copy];
    basicInfo.wantInfo = wantsInfo;
    [wantsInfo release];
    
    basicInfo.turnoffsString = self.turnoffsString;
    basicInfo.languagesString = self.languagesString;
    
    basicInfo.hometownString = self.hometownString;
    basicInfo.companyString = self.companyString;
    
    UserSchoolInfo* schoolInfo = [self.schoolInfo copy];
    basicInfo.schoolInfo = schoolInfo;
    [schoolInfo release];
    
    return basicInfo;
}

- (void)importFromServerData:(id)data
{
    NSDictionary *dict = data;
    
    id value = [dict objectForKey:@"relation"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iRelation = [value intValue];
    }
    else
    {
        self.iRelation = 2;
    }
    
    value = [dict objectForKey:@"visitnum"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iVisitNum = [value intValue];
    }
    else
    {
        self.iVisitNum = 0;
    }
    
    value = [dict objectForKey:@"fansnum"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iFansNum = [value intValue];
    }
    else
    {
        self.iFansNum = 0;
    }
    
    value = [dict objectForKey:@"birthday"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        self.birthdayString = value;
    }
    else
    {
        self.birthdayString = @"";
    }
    
    value = [dict objectForKey:@"blood"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        self.bloodString = value;
    }
    else
    {
        self.bloodString = @"";
    }
    
    value = [dict objectForKey:@"horoscope"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iHoroscope = [value intValue];
    }
    else
    {
        self.iHoroscope = 0;
    }
    
    
    value = [dict objectForKey:@"thinktext"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        self.thinkTextString = [YJEmoji convertMesToUnicode:value];
    }
    else
    {
        self.thinkTextString = @"";
    }
    
    value = [dict objectForKey:@"withwho"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iWithWho = [value intValue];
    }
    else
    {
        self.iWithWho = 0;
    }
    
    value = [dict objectForKey:@"beginage"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iBeginAge = [value intValue];
    }
    else
    {
        self.iBeginAge = 0;
    }
    
    value = [dict objectForKey:@"endage"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iEndAge = [value intValue];
    }
    else
    {
        self.iEndAge = 0;
    }
    
    value = [dict objectForKey:@"salary"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iSalary = [value intValue];
    }
    else
    {
        self.iSalary = 0;
    }
    
    value = [dict objectForKey:@"height"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iHeight = [value intValue];
    }
    else
    {
        self.iHeight = -1;
    }
    
    value = [dict objectForKey:@"love"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.iLove = [value intValue];
    }
    else
    {
        self.iLove = 0;
    }
    
    UserSchoolInfo* schoolInfo = [[UserSchoolInfo alloc] init];
    value = [dict objectForKey:@"school"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        schoolInfo.schoolName = [YJEmoji convertMesToUnicode:value];
    }
    else
    {
        schoolInfo.schoolName = @"";
    }
    
    value = [dict objectForKey:@"department"];
    if ([value isKindOfClass:[NSString class]])
    {
        schoolInfo.departmentName = [YJEmoji convertMesToUnicode:value];
    }
    else
    {
        schoolInfo.departmentName = @"";
    }
    
    value = [dict objectForKey:@"schoolid"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        schoolInfo.iSchoolId = [value integerValue];
    }
    else
    {
        schoolInfo.iSchoolId = 0;
    }
    
    value = [dict objectForKey:@"departmentid"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        schoolInfo.iDepartmentId = [value integerValue];
    }
    else
    {
        schoolInfo.iDepartmentId = 0;
    }
    self.schoolInfo = schoolInfo;
    [schoolInfo release];
    
    value = [dict objectForKey:@"occupation"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iOccupationType = [value integerValue];
    }
    else 
    {
        self.iOccupationType = 0;
    }
    
    value = [dict objectForKey:@"hobbies"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        self.hobbiesString = [YJEmoji convertMesToUnicode:value];
    }
    else
    {
        self.hobbiesString = @"";
    }
    
    value = [dict objectForKey:@"homepage"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        self.homePageString = [YJEmoji convertMesToUnicode:value];
    }
    else
    {
        self.homePageString = @"";
    }
    
    value = [dict objectForKey:@"address"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        self.addressString = [U6Common convertAddressFromServerData:value];
    }
    else
    {
        self.addressString = @"";
    }
    
    value = [dict objectForKey:@"weight"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iWeight = [value integerValue];
    }
    
    value = [dict objectForKey:@"bodytype"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iBodyType = [value integerValue];
    }
    
    value = [dict objectForKey:@"wantinfo"];
    if ([value isKindOfClass:[NSString class]])
    {
        WantsUserInfo* wantInfo = [[WantsUserInfo alloc]init];
        [wantInfo importFromServerData:value];
        self.wantInfo = wantInfo;
        [wantInfo release];
    }
    
    value = [dict objectForKey:@"hometown"];
    if ([value isKindOfClass:[NSString class]])
    {
        self.hometownString = value;
    }
    
    value = [dict objectForKey:@"dialects"];
    if ([value isKindOfClass:[NSString class]])
    {
        self.languagesString = value;
    }
    
    value = [dict objectForKey:@"dialectsname"];
    if ([value isKindOfClass:[NSString class]])
    {
        self.dialectsNameString = value;
    }
    
    value = [dict objectForKey:@"company"];
    if ([value isKindOfClass:[NSString class]])
    {
        self.companyString = [YJEmoji convertMesToUnicode:value];
    }
    
    value = [dict objectForKey:@"turnoffs"];
    if ([value isKindOfClass:[NSString class]])
    {
        NSString *serverStr = (NSString *)value;
        NSMutableString *text = [NSMutableString string];
        for (int i = 0; i < 3; i ++)
        {
            if (serverStr.length >= i)
            {
                [text appendString:[serverStr substringWithRange:NSMakeRange(i, 1)]];
            }
            else
            {
                [text appendString:@"1"];
            }
        }
        self.turnoffsString = value;
    }
    
    value = dict[@"favoritesids"];
    if ([value isKindOfClass:[NSString class]])
    {
        self.iFavoritesids = value;
    }
    else
    {
        self.iFavoritesids = @"";
    }
    
    value = dict[@"favorites"];
    if ([value isKindOfClass:[NSString class]])
    {
        self.iFavorites = value;
    }
    else
    {
        self.iFavorites = @"";
    }

    value = dict[@"loveexp"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iLoveExp = [value integerValue];
    }
    else
    {
        self.iLoveExp = 0;
    }

    value = dict[@"income"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iIncome = [value integerValue];
    }
    else
    {
        self.iIncome = 0;
    }

    value = dict[@"house"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iHouse = [value integerValue];
    }
    else
    {
        self.iHouse = 0;
    }

    value = dict[@"car"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iCar = [value integerValue];
    }
    else
    {
        self.iCar = 0;
    }
}

-(NSInteger)iLocationFlag
{
    if ([self.turnoffsString length] >= 2)
    {
        NSString* str = [self.turnoffsString substringWithRange:NSMakeRange(1, 1)];
        return [str integerValue];
    }
    
    return 0;
}

- (void)setILocationFlag:(NSInteger)iLocationFlag
{
    if (_turnoffsString.length >= 2)
    {
        NSString *newStr = [[_turnoffsString stringByReplacingCharactersInRange:NSMakeRange(1, 1)
                                                                     withString:[NSString
                                                                                 stringWithFormat:@"%ld", (long)iLocationFlag]] retain];
        [_turnoffsString release]; _turnoffsString = newStr;
    }
}

-(NSInteger)iShowSNS
{
    if (_turnoffsString.length >= 1)
    {
        NSString* str = [self.turnoffsString substringWithRange:NSMakeRange(0, 1)];
        return [str integerValue];
    }
    
    return 0;
}

- (void)setIShowSNS:(NSInteger)iShowSNS
{
    if (_turnoffsString.length >= 1)
    {
        NSString *newStr = [[_turnoffsString stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                                     withString:[NSString stringWithFormat:@"%ld", (long)iShowSNS]] retain];
        [_turnoffsString release]; _turnoffsString = newStr;
    }
}

-(NSInteger)iShowPhoneInfo
{
    if ([self.turnoffsString length] >= 3)
    {
        NSString* str = [self.turnoffsString substringWithRange:NSMakeRange(2, 1)];
        return [str integerValue];
    }
    return 0;
}

- (void)setIShowPhoneInfo:(NSInteger)iShowPhoneInfo
{
    if (_turnoffsString.length >= 3)
    {
        NSString *newStr = [[_turnoffsString stringByReplacingCharactersInRange:NSMakeRange(2, 1)
                                                                     withString:[NSString stringWithFormat:@"%ld", (long)iShowPhoneInfo]] retain];
        [_turnoffsString release]; _turnoffsString = newStr;
    }
}

- (NSArray*)languageArray
{
    if ([self.languagesString length] > 0)
    {
        NSArray* array = [self.languagesString componentsSeparatedByString:@","];
        
        return array;
    }
    
    return nil;
}

- (NSDate *)birthdayDate
{
    if (_birthdayString)
    {
        return [NSDate dateByStringFormat:@"yyyy-M-d" dateString:_birthdayString];
    }
    return nil;
}

- (void)setBirthdayDate:(NSDate *)birthdayDate
{
    if (birthdayDate)
    {
        [_birthdayString release];
        _birthdayString = [[NSDate stringByStringFormat:@"yyyy-M-d" data:birthdayDate] retain];
    }
}

- (NSString *)getBirthplaceFormateStr
{
    if (self.hobbiesString)
    {
        return [U6Common getBirthplace:self.hobbiesString];
    }
    return nil;
}

@end
