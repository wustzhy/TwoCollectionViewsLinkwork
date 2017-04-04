//
//  UserBasicInfo.h
//  MeYou
//
//  Created by hower on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataObject.h"
#import "WantsUserInfo.h"
#import "UserSchoolInfo.h"

#define USER_NAME_MAX_L (14)
#define USER_SIGNATURE_MAX_L (140)
#define BASIC_HOBBY_MAX_L (140)
#define BASIC_SCHOOL_MAX_L (30)
#define BASIC_COMPANY_MAX_L (30)

typedef enum{
	FanstatusNone=0,   // 未关注
	FanstatusFollowing=1,  // 关注别人
	FanstatusFollowed=2,  // 被关注
	FanstatusEachOther=3,  // 互相关注
}Fanstatus;

//用户基本信息
@interface UserBasicInfo : DataObject 
{
    
	NSInteger _iRelation;           //关系标识：0:自己 ，1：好友 ，2：陌生人 3:我的关注 4：我的粉丝
	NSInteger _iFansNum;            //粉丝数量
	NSString *_birthdayString;      //生日
	NSString *_bloodString;         //血型
	NSInteger _iHoroscope;          //星座
	Fanstatus _fansStatus;          //关注状态
    NSString *_thinkTextString;     //交友目的
    NSInteger _iWithWho;            //交友对象
    NSInteger _iBeginAge;           //交友起始年龄
	NSInteger _iEndAge;             //交友结束年龄
	NSInteger _iLove;               //婚恋状态
    
    NSInteger _iVisitNum;           //访问数量
    NSInteger _iSalary;             //月薪
    NSInteger _iHeight;             //身高
    NSString *_hobbiesString;       //兴趣爱好
    NSString *_homePageString;      //个人主页
    
    NSInteger _iOccupationType;     //职业类型
    NSString *_addressString;       //地址
    
    //ver3.0 新增
    NSInteger   _iWeight;           //体重 KG
    NSInteger   _iBodyType;         //体型
    
    WantsUserInfo        *_wantInfo;//想要认识人的资料
    
    // 6.0新增
    NSString *_iFavoritesids; //交友喜好ids (1,2)
    NSString *_iFavorites; //交友喜好名称
    NSInteger _iLoveExp; //恋爱经历
    NSInteger _iIncome; //收入
    NSInteger _iHouse; //住房情况
    NSInteger _iCar; //购车情况
}

/**
	关系标识：0:自己 ，1：好友 ，2：陌生人 3:我的关注 4：我的粉丝
 */
@property (nonatomic) NSInteger iRelation;

/**
	粉丝数量
 */
@property (nonatomic) NSInteger iFansNum;

/**
	生日
 */
@property (nonatomic,copy) NSString *birthdayString;

/**
    生日
 */
@property (nonatomic, retain) NSDate *birthdayDate;

/**
	血型
 */
@property (nonatomic,copy) NSString *bloodString;

/**
	星座
 */
@property (nonatomic) NSInteger iHoroscope;

/**
	关注状态
 */
@property (nonatomic ) Fanstatus fansStatus;

/**
	交友目的
 */
@property (nonatomic,copy) NSString *thinkTextString;

/**
	交友对象
 */
@property (nonatomic) NSInteger iWithWho;

/**
	交友起始年龄
 */
@property (nonatomic) NSInteger iBeginAge;

/**
	交友结束年龄
 */
@property (nonatomic) NSInteger iEndAge;

/**
	婚恋状态
 */
@property (nonatomic) NSInteger iLove;


/**
	访问数量
 */
@property (nonatomic) NSInteger iVisitNum;

/**
	月薪
 */
@property (nonatomic) NSInteger iSalary;

/**
	身高
 */
@property (nonatomic) NSInteger iHeight;

/**
	职业类型
 */
@property (nonatomic) NSInteger iOccupationType;


/**
	兴趣爱好ID组合字符串 id之间用逗号分隔 //ver3.0 1,2,3
 */
@property (nonatomic,copy) NSString *hobbiesString; 

/**
	个人主页
 */
@property (nonatomic,copy) NSString *homePageString;

/**
	地址
 */
@property (nonatomic,copy) NSString *addressString;


/**
 体重
 */
@property (nonatomic) NSInteger iWeight;

/**
 体型
 */
@property (nonatomic) NSInteger iBodyType;

/**
 用户想
 */
@property (nonatomic, copy) WantsUserInfo* wantInfo;

// 6.0新增
/**
 交友喜好ids
 */
@property (nonatomic, retain) NSString *iFavoritesids;

/**
 交友喜好名称
 */
@property (nonatomic, retain) NSString *iFavorites;

/**
 恋爱经历
 */
@property (nonatomic, assign) NSInteger iLoveExp;

/**
 收入
 */
@property (nonatomic, assign) NSInteger iIncome;

/**
 住房情况
 */
@property (nonatomic, assign) NSInteger iHouse;

/**
 购车情况
 */
@property (nonatomic, assign) NSInteger iCar;

 //ver5.0
@property(nonatomic, copy) NSString*  turnoffsString;//”111” 第一位（微博开关）第二位(最后位置开关) 第三位(手机信息开关)
@property (nonatomic) NSInteger iLocationFlag;//位置公开 //1：显示 0：不显示
@property (nonatomic) NSInteger  iShowSNS;//1：显示微博 0：不显示
@property (nonatomic) NSInteger  iShowPhoneInfo;//1 显示 0不显示

@property(nonatomic, copy) NSString* hometownString;
@property(nonatomic, copy) NSString* companyString;//所在公司

@property(nonatomic, copy) NSString* languagesString;//”1,13”//掌握语言的编码
@property(nonatomic, copy) NSString* dialectsNameString;//掌握的语言描述
@property(nonatomic, readonly) NSArray* languageArray;//掌握的语言ID数组

/**
    学校信息 since 5.6
 */
@property(nonatomic, retain) UserSchoolInfo *schoolInfo;

- (NSString *)getBirthplaceFormateStr;

@end
