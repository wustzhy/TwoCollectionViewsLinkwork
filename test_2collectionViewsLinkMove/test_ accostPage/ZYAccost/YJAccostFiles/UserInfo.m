//
//  UserInfo.m
//  MeYou
//
//  Created by hower on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserInfo.h"
//#import "U6AppFacade+Proxy.h"
//#import "WeiboType.h"
//#import "U6Common.h"


@interface UserInfo(Private)

/**
	解析微博信息
	@param weibo 微博信息
 */
- (void)parseWeiboInfo:(NSString *)weibo;


@end

@implementation UserInfo

@synthesize userId=_userId;
@synthesize icon=_icon;
@synthesize iAge = _iAge;
@synthesize bOnline = _bOnline;
@synthesize genderString = _genderString;

@synthesize fLat = _fLat;
@synthesize fLng = _fLng;
//@synthesize fDistance = _fDistance;
@synthesize selfTextString = _selfTextString;
@synthesize fLastOnlineTime = _fLastOnlineTime;
@synthesize weiboString = _weiboString;

@synthesize bIsBindSinaWeibo = _bIsBindSinaWeibo;
@synthesize bIsSinaWeiboAuthUser = _bIsSinaWeiboAuthUser;
@synthesize bIsSinaWeiboDaren = _bIsSinaWeiboDaren;
@synthesize bIsSinaWeiboVIP = _bIsSinaWeiboVIP;
@synthesize bIsSinaWeiboEnterprise = _bIsSinaWeiboEnterprise;

//@synthesize fLocalDistance;

@synthesize noteNameString = _noteNameString;
@synthesize originNicknameString = _originNicknameString;
@synthesize iRelation = _iRelation;
@synthesize iTodayPhotoCount = _iTodayPhotoCount;
@synthesize iTotalPhotoCount = _iTotalPhotoCount;
@synthesize iTodayPhotoLimit = _iTodayPhotoLimit;
@synthesize iTotalPhotoLimit = _iTotalPhotoLimit;
@synthesize iUserFindYouType = _iUserFindYouType;
@synthesize iUserConnection = _iUserConnection;

- (id)init
{
	if (self = [super init])
	{
		_userId = 0;
		self.icon = [NSString string];
		self.iVip = 0;
        self.iNewVip = 0;
		self.iAge = 0;
		self.bOnline = NO;
		self.genderString = [NSString string];
        self.fLat = 0.0;
        self.fLng = 0.0;
        self.selfTextString = @"";
        self.fLastOnlineTime = 0.0;
        self.weiboString = @"";
        self.noteNameString = @"";
        self.originNicknameString = @"";
//        self.fDistance = -1;
        _iRelation = 0;
        _bIsForbid = NO;
        _iPhotoNum = 0;
        _iTodayPhotoCount = 0;
        _iTotalPhotoCount = 0;
        _iTodayPhotoLimit = 0;
        _iTotalPhotoLimit = 0;
        _iUserFindYouType = 0;
        _iUserConnection = 0;
//        _chainMiddleInfo = [[MiddleNode alloc] init];
        _isChat = 0;
	}
	return self;
}

- (void)dealloc
{
    [UserInfo removeUserDataObserver:self userId:_userId];

	self.icon = nil;
	self.genderString = nil;
    self.selfTextString = nil;
    self.weiboString = nil;
    self.noteNameString = nil;
    self.originNicknameString = nil;
    
//    [_chainMiddleInfo release];
//    _chainMiddleInfo = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];

//	[super dealloc];
}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//    UserInfo *userInfo = [super copyWithZone:zone];
//    
//    userInfo.userId = self.userId;
//    userInfo.icon = self.icon;
//    userInfo.iVip = self.iVip;
//    userInfo.iNewVip = self.iNewVip;
//    userInfo.iAge = self.iAge;
//    userInfo.bOnline = self.bOnline;
//    userInfo.genderString = self.genderString;
//    userInfo.fLat = self.fLat;
//    userInfo.fLng = self.fLng;
//    userInfo.fDistance = self.fDistance;
//    userInfo.selfTextString = self.selfTextString;
//    userInfo.fLastOnlineTime = self.fLastOnlineTime;
//    userInfo.weiboString = self.weiboString;
//    userInfo.noteNameString = self.noteNameString;
//    userInfo.originNicknameString = self.originNicknameString;
//    userInfo.iRelation = self.iRelation;
//    userInfo.iTodayPhotoCount = self.iTodayPhotoCount;
//    userInfo.iTotalPhotoCount = self.iTotalPhotoCount;
//    userInfo.iTodayPhotoLimit = self.iTodayPhotoLimit;
//    userInfo.iTotalPhotoLimit = self.iTotalPhotoLimit;
//    userInfo.iUserFindYouType = self.iUserFindYouType;
//    userInfo.iUserConnection = self.iUserConnection;
//
//    MiddleNode* middleInfo = [self.chainMiddleInfo copy];
//    userInfo.chainMiddleInfo = middleInfo;
//    [middleInfo release];
//    
//    userInfo.bIsForbid = self.bIsForbid;
//    userInfo.iPhotoNum = self.iPhotoNum;
//    
//    return userInfo;
//}

- (NSString *)getNormalIconURLStr
{
    if (_icon)
    {
        return [_icon stringByReplacingOccurrencesOfString:@"_s" withString:@""];
    }

    return nil;
}

- (NSString *)nickName
{
    if (self.noteNameString.length > 0)
    {
        return self.noteNameString;
    }

    return self.originNicknameString;
}

- (void)importFromServerData:(id)data
{
	NSDictionary * dict = data;
	
	id value = [dict objectForKey:@"userid"];
	if ([value isKindOfClass:[NSNumber class]])
	{
		self.userId = [value longLongValue];
	}
	else
	{
		self.userId = 0;
	}
    
    value = [dict objectForKey:@"nickname"];
    if ([value isKindOfClass:[NSString class]]) 
    {
//        self.originNicknameString = [YJEmoji convertMesToUnicode:value];
    }
    else
    {
        self.originNicknameString = @"";
    }

    value = [dict objectForKey:@"notes"];
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""])
    {
//        self.noteNameString = [YJEmoji convertMesToUnicode:value];
    }
    else
    {
        self.noteNameString = @"";
    }

	
	value = [dict objectForKey:@"icon"];
	if ([value isKindOfClass:[NSString class]])
	{
		self.icon = value;
	}
	else
	{
		self.icon = [NSString string];
	}

	value = [dict objectForKey:@"viplevel"];
	if ([value isKindOfClass:[NSNumber class]])
	{
		self.iVip = [value integerValue];
	}
	else
	{
		self.iVip = 0;
	}
    
    value = [dict objectForKey:@"svip"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iNewVip = [value integerValue];
    }
    else
    {
        self.iNewVip = 0;
    }
	
	value = [dict objectForKey:@"age"];
	if ([value isKindOfClass:[NSNumber class]])
	{
		self.iAge = [value intValue];
	}
	else
	{
		self.iAge = 0;
	}

	value = [dict objectForKey:@"online"];
	if ([value isKindOfClass:[NSString class]])
	{
		if ([value caseInsensitiveCompare:@"y"] == NSOrderedSame)
		{
			self.bOnline = YES;
		}
		else
		{
			self.bOnline = NO;
		}
	}
	else
	{
		self.bOnline = NO;
	}
	
	value = [dict objectForKey:@"gender"];
	if ([value isKindOfClass:[NSString class]])
	{
		self.genderString = value;
	}
	else
	{
		self.genderString = [NSString string];
	}

    value = [dict objectForKey:@"isonline"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        if ([value caseInsensitiveCompare:@"y"] == NSOrderedSame)
		{
			self.bOnline = YES;
		}
		else
		{
			self.bOnline = NO;
		}
    }
    else
    {
        self.bOnline = NO;
    }
    
    value = [dict objectForKey:@"lastonlinetime"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fLastOnlineTime = [value doubleValue] / 1000;
    }
    else
    {
        self.fLastOnlineTime = 0.0;
    }
    
    value = [dict objectForKey:@"selftext"];
    if ([value isKindOfClass:[NSString class]]
        && ![value isEqualToString:@"null"])
    {
//        self.selfTextString = [YJEmoji convertMesToUnicode:value];
    }
    else
    {
        self.selfTextString = @"";
    }

    value = [dict objectForKey:@"weibo"];
    if ([value isKindOfClass:[NSString class]]) 
    {
        self.weiboString = value;
    }
    else
    {
        self.weiboString = @"";
    }
    [self parseWeiboInfo:self.weiboString];
    
    value = [dict objectForKey:@"lat"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fLat = [value doubleValue] / 1000000;
    }
    else
    {
        self.fLat = 0.0;
    }
    
    value = [dict objectForKey:@"lng"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fLng = [value doubleValue] / 1000000;
    }
    else
    {
        self.fLng = 0.0;
    }
    
    value = [dict objectForKey:@"distance"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.fDistance = [value doubleValue] / 1000;
    }
    else
    {
        self.fDistance = 0.0;
    }
    
    value = [dict objectForKey:@"relation"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iRelation = [value integerValue];
    }
    
    value = [dict objectForKey:@"forbid"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        if ([value integerValue] == 1)
        {
            self.bIsForbid = YES;
        }
        else if ([value integerValue] == 0)
        {
            self.bIsForbid = NO;
        }
    }

    value = [dict objectForKey:@"photonum"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iPhotoNum = [value integerValue];
    }
    else
    {
        self.iPhotoNum = 0;
    }
    
    //5.3
    value = [dict objectForKey:@"todayphotos"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iTodayPhotoCount = [value integerValue];
    }
    else
    {
        self.iTodayPhotoCount = 0;
    }
    
    value = [dict objectForKey:@"photouploadleft"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iTotalPhotoCount = [value integerValue];
    }
    else
    {
        self.iTotalPhotoCount = 0;
    }
    
    value = [dict objectForKey:@"todayphotostotal"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iTodayPhotoLimit = [value integerValue];
    }
    else
    {
        self.iTodayPhotoLimit = 0;
    }
    
    value = [dict objectForKey:@"photouploadtotal"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iTotalPhotoLimit = [value integerValue];
    }
    else
    {
        self.iTotalPhotoLimit = 0;
    }
    
    //5.4
    value = [dict objectForKey:@"from"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iUserFindYouType = [value intValue];
    }
    else
    {
        self.iUserFindYouType = 0;
    }
    
    value = [dict objectForKey:@"level"];
	if ([value isKindOfClass:[NSNumber class]])
	{
		self.level = [value intValue];
	}
	else
	{
		self.level = 0;
	}
    value = [dict objectForKey:@"occupation"];
	if ([value isKindOfClass:[NSNumber class]])
	{
		self.occupation = [value intValue];
	}
	else
	{
		self.occupation = 0;
	}
    
    //5.5
    value = [dict objectForKey:@"contact"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iUserConnection = [value intValue];
    }
    
    //6.5
    value = [dict objectForKey:@"charmnum"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.charmNum = [value longValue];
    }
    else
    {
        self.charmNum = 0;
    }
    
    //6.5
    value = [dict objectForKey:@"expire"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.vipExpire = [value doubleValue];
    }
    else
    {
        self.vipExpire = 0;
    }
    
    //6.5.1
    value = [dict objectForKey:@"offerprice"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.offerPrice = [value integerValue];
    }
    else
    {
        self.offerPrice = 0;
    }
    
    value = [dict objectForKey:@"offertime"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.offerTime = [value doubleValue];
    }
    else
    {
        self.offerTime = 0;
    }
    
    value = [dict objectForKey:@"remain"];
    if ([value isKindOfClass:[NSString class]])
    {
        self.remainPrice = [value floatValue];
    }
    else
    {
        self.remainPrice = 0;
    }
}

- (void)importFromDataReader:(FMResultSet *)reader
{
    id value = [reader objectForColumnIndex:2];
	if ([value isKindOfClass:[NSNumber class]])
	{
        self.userId = [value longValue];
	}
    else
    {
        self.userId = 0;
    }
    
	value = [reader objectForColumnIndex:3];
	if ([value isKindOfClass:[NSString class]])
	{
        self.originNicknameString = [YJEmoji convertMesToUnicode:value];
	}
	else
	{
		self.originNicknameString = @"";
	}
    
	value = [reader objectForColumnIndex:4];
	if ([value isKindOfClass:[NSString class]])
	{
		self.icon = value;
	}
	else
	{
		self.icon = @"";
	}
    
    value = [reader objectForColumnIndex:5];
	if ([value isKindOfClass:[NSNumber class]])
	{
		self.iAge = [value intValue];
	}
	else
	{
		self.iAge = 0;
	}
    
    value = [reader objectForColumnIndex:6];
	if ([value isKindOfClass:[NSString class]])
	{
		self.genderString = value;
	}
	else
	{
		self.genderString = @"";
	}
    
	value = [reader objectForColumnIndex:7];
	if ([value isKindOfClass:[NSNumber class]])
	{
        self.iVip = [value integerValue];
	}
	else
	{
		self.iVip = 0;
	}
    
    value = [reader objectForColumnIndex:20];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iNewVip = [value integerValue];
    }
    else
    {
        self.iNewVip = 0;
    }
    
    value = [reader objectForColumnIndex:8];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.fDistance = [value doubleValue];
    }
    else
    {
        self.fDistance = 0.0;
    }
    
	value = [reader objectForColumnIndex:9];
	if ([value isKindOfClass:[NSNumber class]])
	{
        self.fLastOnlineTime = [value doubleValue];
	}
	else
	{
        self.fLastOnlineTime = 0.0;
	}
    
	value = [reader objectForColumnIndex:10];
	if ([value isKindOfClass:[NSString class]])
	{
        self.selfTextString = [YJEmoji convertMesToUnicode:value];
	}
	else
	{
		self.selfTextString = @"";
	}
    
	value = [reader objectForColumnIndex:11];
	if ([value isKindOfClass:[NSNumber class]])
	{
        if ([value intValue ] == 1) 
        {
            self.bOnline = YES;
        }
        else
        {
            self.bOnline = NO;
        }
	}
	else
	{
		self.bOnline = NO;
	}
    
	value = [reader objectForColumnIndex:12];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fLat = [value doubleValue];
    }
    else
    {
        self.fLat = 0.0;
    }
    
    value = [reader objectForColumnIndex:13];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fLng = [value doubleValue];
    }
    else
    {
        self.fLng = 0.0;
    }
    
    value = [reader objectForColumnIndex:14];
    if ([value isKindOfClass:[NSString class]])
    {
        self.weiboString = value;
    }
    else
    {
        self.weiboString = @"";
    }
    [self parseWeiboInfo:self.weiboString];
    
    value = [reader objectForColumnIndex:15];
    if ([value isKindOfClass:[NSString class]]) 
    {
        self.noteNameString = value;
    }
    else
    {
        self.noteNameString = @"";
    }

    value = [reader objectForColumnIndex:16];
	if ([value isKindOfClass:[NSNumber class]])
	{
        if ([value intValue ] == 1)
        {
            self.bIsForbid = YES;
        }
        else if ([value intValue ] == 0)
        {
            self.bIsForbid = NO;
        }
	}
	else
	{
		self.bIsForbid = NO;
	}
    
    value = [reader objectForColumnIndex:17];
	if ([value isKindOfClass:[NSNumber class]])
	{
        self.iRelation = [value intValue];
	}
	else
	{
		self.iRelation = 1;
	}

    value = [reader objectForColumnIndex:18];
	if ([value isKindOfClass:[NSNumber class]])
	{
        self.iPhotoNum = [value intValue];
	}
	else
	{
		self.iPhotoNum = 0;
	}
    
    value = [reader objectForColumnIndex:19];
	if ([value isKindOfClass:[NSNumber class]])
	{
        self.iUserConnection = [value intValue];
	}
	else
	{
		self.iUserConnection = 0;
	}
}

- (void)importFromAddFriendResponse:(id)data
{
    NSDictionary *dict = data;
    
    id value = [dict objectForKey:@"user"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        [self importFromServerData:value];
    }
    
    value = [dict objectForKey:@"friend"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        id subValue = [value objectForKey:@"lat"];
        if ([subValue isKindOfClass:[NSNumber class]]) 
        {
            self.fLat = [subValue doubleValue] / 1000000;
        }
        else
        {
            self.fLat = 0.0;
        }
        
        subValue = [value objectForKey:@"lng"];
        if ([subValue isKindOfClass:[NSNumber class]]) 
        {
            self.fLng = [subValue doubleValue] / 1000000;
        }
        else
        {
            self.fLng = 0.0;
        }
        
        subValue = [value objectForKey:@"selftext"];
        if ([subValue isKindOfClass:[NSString class]]
            && ![value isEqualToString:@"null"])
        {
            self.selfTextString = [YJEmoji convertMesToUnicode:subValue];
        }
        else
        {
            self.selfTextString = @"";
        }
        
        subValue = [value objectForKey:@"isonline"];
        if ([subValue isKindOfClass:[NSString class]]) 
        {
            if ([subValue caseInsensitiveCompare:@"y"] == NSOrderedSame) 
            {
                self.bOnline = YES;
            }
            else
            {
                self.bOnline = NO;
            }
        }
        else
        {
            self.bOnline = NO;
        }
        
        subValue = [value objectForKey:@"logintime"];
        if ([subValue isKindOfClass:[NSNumber class]]) 
        {
            self.fLastOnlineTime = [subValue doubleValue] / 1000;
        }
        else
        {
            self.fLastOnlineTime = 0.0;
        }
    }
}

- (void)importFromNotification:(id)data
{
    NSDictionary *dict = data;
    
    id value = [dict objectForKey:@"user"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        [self importFromServerData:value];
    }
    
    value = [dict objectForKey:@"friend"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        id subValue = [value objectForKey:@"lat"];
        if ([subValue isKindOfClass:[NSNumber class]]) 
        {
            self.fLat = [subValue doubleValue] / 1000000;
        }
        else
        {
            self.fLat = 0.0;
        }
        
        subValue = [value objectForKey:@"lng"];
        if ([subValue isKindOfClass:[NSNumber class]]) 
        {
            self.fLng = [subValue doubleValue] / 1000000;
        }
        else
        {
            self.fLng = 0.0;
        }
        
        subValue = [value objectForKey:@"sign"];
        if ([subValue isKindOfClass:[NSString class]]) 
        {
            self.selfTextString = [YJEmoji convertMesToUnicode:subValue];
        }
        else
        {
            self.selfTextString = @"";
        }
        
        subValue = [value objectForKey:@"isonline"];
        if ([subValue isKindOfClass:[NSString class]]) 
        {
            if ([subValue caseInsensitiveCompare:@"y"] == NSOrderedSame) 
            {
                self.bOnline = YES;
            }
            else
            {
                self.bOnline = NO;
            }
        }
        else
        {
            self.bOnline = NO;
        }
        
        subValue = [value objectForKey:@"lastlogintime"];
        if ([subValue isKindOfClass:[NSNumber class]]) 
        {
            self.fLastOnlineTime = [subValue doubleValue] / 1000;
        }
        else
        {
            self.fLastOnlineTime = 0.0;
        }
        
        subValue = [value objectForKey:@"weibo"];
        if ([subValue isKindOfClass:[NSString class]]) 
        {
            self.weiboString = subValue;
        }
        else
        {
            self.weiboString = @"";
        }
        [self parseWeiboInfo:self.weiboString];
        
        subValue = [value objectForKey:@"distance"];
        if ([subValue isKindOfClass:[NSNumber class]]) 
        {
            self.fDistance = [subValue doubleValue] / 1000;
        }
        else
        {
            self.fDistance = 0.0;
        }
    }
}

- (void)importFromOnlineUsersResponse:(id)data
{
    NSDictionary *dict = data;
    id value = [dict objectForKey:@"user"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        [self importFromServerData:value];
    }
    
    value = [dict objectForKey:@"distance"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fDistance = [value doubleValue] / 1000;
    }
    else
    {
        self.fDistance = 0.0;
    }
}

- (void)importFromNearbyUsersResponse:(id)data
{
    NSDictionary *dict = data;
    id value = [dict objectForKey:@"user"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        [self importFromServerData:value];
    }
    
    value = [dict objectForKey:@"distance"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fDistance = [value doubleValue] / 1000;
    }
    else
    {
        self.fDistance = 0.0;
    }
}

- (void)importFromFansResponse:(id)data
{
    NSDictionary *dict = data;
    id value = [dict objectForKey:@"user"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        [self importFromServerData:value];
    }
    
    value = [dict objectForKey:@"distance"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fDistance = [value doubleValue] / 1000;
    }
    else
    {
        self.fDistance = 0.0;
    }
    
    value = [dict objectForKey:@"relation"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iRelation = [value integerValue];
    }
    
    value = [dict objectForKey:@"newflag"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.isNewFans = [value integerValue] == 1;
    }
    
    //5.5
    value = [dict objectForKey:@"contact"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iUserConnection = [value intValue];
    }
}

- (void)importFromFollowsResponse:(id)data
{
    NSDictionary *dict = data;
    id value = [dict objectForKey:@"user"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        [self importFromServerData:value];
    }
    
    value = [dict objectForKey:@"distance"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fDistance = [value doubleValue] / 1000;
    }
    else
    {
        self.fDistance = 0.0;
    }
    
    value = [dict objectForKey:@"relation"];
    if ([value isKindOfClass:[NSNumber class]])
    {
        self.iRelation = [value integerValue];
    }
}

- (void)importFromFriendsResponse:(id)data
{
    NSDictionary *dict = data;
    id value = [dict objectForKey:@"user"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        [self importFromServerData:value];
    }
    
    value = [dict objectForKey:@"distance"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fDistance = [value doubleValue] / 1000;
    }
    else
    {
        self.fDistance = 0.0;
    }
}

- (void)importFromTopicLikeUsersResponse:(id)data
{
    NSDictionary *dict = data;
    id value = [dict objectForKey:@"user"];
    if ([value isKindOfClass:[NSDictionary class]]) 
    {
        [self importFromServerData:value];
    }
    
    value = [dict objectForKey:@"distance"];
    if ([value isKindOfClass:[NSNumber class]]) 
    {
        self.fDistance = [value doubleValue] / 1000;
    }
    else
    {
        self.fDistance = 0.0;
    }
}

- (CGFloat)fLocalDistance
{
    if (_userId <= 1000 && _userId > 0)//114
    {
        return 0;
    }
    
    return [[[U6AppFacade getInstance] getLocationInfo] getDistanceWithLat:_fLat lng:_fLng] / 1000;
}

+ (void)addUserDataObserver:(id)obj callBackSel:(SEL)callBackSel userId:(long long)userId
{
    if (userId <= 0)
    {
        return;
    }

    NSString *notifiName = [NSString stringWithFormat:@"%@%lld", kUserInfoNoteNameChange, userId];

    [[NSNotificationCenter defaultCenter] addObserver:obj selector:callBackSel name:notifiName object:nil];
}

+ (void)removeUserDataObserver:(id)obj userId:(long long)userId
{
    if (userId <= 0)
    {
        return;
    }

    NSString *notifiName = [NSString stringWithFormat:@"%@%lld", kUserInfoNoteNameChange, userId];
 
    [[NSNotificationCenter defaultCenter] removeObserver:obj name:notifiName object:nil];
}

+ (void)postUserDataChange:(long long)userId changeData:(NSDictionary *)changeData
{
    if (userId <= 0)
    {
        return;
    }
    NSString *notifiName = [NSString stringWithFormat:@"%@%lld", kUserInfoNoteNameChange, userId];

    [[NSNotificationCenter defaultCenter] postNotificationName:notifiName object:nil userInfo:changeData];
}

#pragma mark - Private
#pragma mark - Private
- (void)parseWeiboInfo:(NSString *)weibo
{
    NSArray *weiboArray = [weibo componentsSeparatedByString:@","];
    
    _bIsBindSinaWeibo = NO;
    _bIsSinaWeiboAuthUser = NO;
    _bIsSinaWeiboDaren = NO;
    _bIsSinaWeiboVIP = NO;
    _bIsSinaWeiboEnterprise = NO;
    _bIsBindFaceBook = NO;
    _bIsBindQQZone = NO;
    _bIsBindTwiter = NO;
    _bIsBindTXWb = NO;
    //解析新浪微博
    for (int i = 0; i < [weiboArray count]; i++)
    {
        NSString *weiboString = [weiboArray objectAtIndex:i];
        if ([weiboString rangeOfString:[NSString stringWithFormat:@"%d",WeiboTypeSina]].location == 0)
        {
            _bIsBindSinaWeibo = YES;
            if ([weiboString length] > 2 && [weiboString characterAtIndex:2] == '1')
            {
                _bIsSinaWeiboAuthUser = YES;
            }
            if ([weiboString length] > 3 && [weiboString characterAtIndex:3] == '1')
            {
                _bIsSinaWeiboDaren = YES;
            }
            if ([weiboString length] > 4 && [weiboString characterAtIndex:4] == '1')
            {
                _bIsSinaWeiboVIP = YES;
            }
            if ([weiboString length] > 5 && [weiboString characterAtIndex:5] == '1')
            {
                _bIsSinaWeiboEnterprise = YES;
            }
        }
        else if ([weiboString rangeOfString:@"991"].location == 0)
        {
            self.gameLevel = 1;
        }
        //since 5.4 上线前检查    圈主：981      小辣椒：982      真心话大冒险：992
        else if ([weiboString rangeOfString:@"981"].location== 0)
        {
            self.isGruopMaster = YES;
        }
        else if ([weiboString rangeOfString:@"982"].location== 0)
        {
            self.isSpeakJustNow = YES;
        }
        else if ([weiboString rangeOfString:@"992"].location== 0)
        {
            self.isChatOn = YES;
        }
        else if ([weiboString rangeOfString:[NSString stringWithFormat:@"%d",WeiboTypeTencentQQ]].location == 0)
        {
            self.bIsBindQQZone = YES;
        }
        else if ([weiboString rangeOfString:[NSString stringWithFormat:@"%d",WeiboTypeTwitter]].location == 0)
        {
            self.bIsBindTwiter = YES;
        }
        else if ([weiboString rangeOfString:[NSString stringWithFormat:@"%d",WeiboTypeTencent]].location == 0)
        {
            self.bIsBindTXWb = YES;
        }
        else if ([weiboString rangeOfString:[NSString stringWithFormat:@"%d",WeiboTypeFaceBook]].location == 0)
        {
            self.bIsBindFaceBook = YES;
        }
        
    }
}

- (void)setIRelation:(NSInteger)iRelation
{
    _iRelation = iRelation;
}

- (void)setUserId:(long long)userId
{
    [UserInfo removeUserDataObserver:self userId:_userId];
    [UserInfo addUserDataObserver:self callBackSel:@selector(onUserDataChange:) userId:userId];

    _userId = userId;
}

#pragma mark - Selector

- (void)onUserDataChange:(NSNotification *)notifi
{
    NSString *noteNameStr = [[notifi userInfo] objectForKey:kUserInfoNoteName];
    if (![noteNameStr isEqualToString:self.noteNameString])
    {
        self.noteNameString = noteNameStr;
    }
}

@end
