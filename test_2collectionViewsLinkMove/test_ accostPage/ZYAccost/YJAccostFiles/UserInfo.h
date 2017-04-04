//
//  UserInfo.h
//  MeYou
//
//  Created by hower on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>   //
//#import "DataObject.h"    //
#import <CoreLocation/CoreLocation.h>
//#import "U6SqliteKit.h" //
//#import "MiddleNode.h"

#define USERINFO_NICK_NAME_MAX_L (14)

#define kUserInfoNoteNameChange @"kUserInfoNoteNameChange"
#define kUserInfoNoteName @"kUserInfoNoteName"
#define kUserInfoNickname @"kUserInfoNickname"

typedef enum
{
    UserFindYouFromTypeUnknown = 0,     //未知途径
    UserFindYouFromTypeIDSearch,        //通过id搜索找到你
    UserFindYouFromTypeNicknameSearch,  //通过昵称搜索找到你
    UserFindYouFromTypeNearbyList,      //通过附近的人找到你
    UserFindYouFromTypeNearbyMap,       //通过地图漫游找到你
    UserFindYouFromTypeGlobalFocus,     //通过全球焦点找到你
    UserFindYouFromTypeNearbyFocus      //通过附近焦点找到你
}UserFindYouFromType;

// 人脉关系来源
typedef enum
{
    UserConnectionTypeUnknown = 0,     //未知（遇见）
    UserConnectionTypeIDSearch,        //id搜索
    UserConnectionTypeNicknameSearch,  //昵称搜索
    UserConnectionTypeNearbyList,      //附近的人
    UserConnectionTypeNearbyMap,       //地图漫游
    UserConnectionTypeGlobalFocus,     //全球焦点
    UserConnectionTypeNearbyFocus,     //附近焦点
    UserConnectionTypeGroup,           //圈子
    UserConnectionTypePhotos,          //精选照片
    UserConnectionTypeRank,            //排行榜
    UserConnectionTypeGamePlayer,      //游戏玩家
    UserConnectionTypeMeetGame,        //邂逅
    UserConnectionTypeRecentVisit,     //最近来访
    
}UserConnectionType;

//用户信息
@interface UserInfo : NSObject// DataObject
{
@private
	long long _userId;
	NSString *_icon;
	NSInteger _iVip;
    NSInteger _iNewVip;
	
	NSInteger _iAge;
	BOOL _bOnline;
	NSString *_genderString;
    
    CLLocationDegrees _fLat;
    CLLocationDegrees _fLng;
    //CGFloat _fDistance;
    
    NSString *_selfTextString;
    NSTimeInterval _fLastOnlineTime;
    
    NSString *_weiboString;

    BOOL _bIsBindSinaWeibo;
    BOOL _bIsSinaWeiboAuthUser;
    BOOL _bIsSinaWeiboDaren;
    BOOL _bIsSinaWeiboVIP;
    BOOL _bIsSinaWeiboEnterprise;
    
    NSString *_noteNameString;
    NSString *_originNicknameString;
    
    /**
     关系标识：0:自己 1：好友 2：陌生人 3：我的关注 4：我的粉丝 5：好友推荐(v5.5)
     */
    NSInteger _iRelation;
    
    BOOL        _bIsForbid; //是否是封停用户
    
    NSInteger _iTodayPhotoCount;    //今日剩余上传照片数
    NSInteger _iTotalPhotoCount;    //用户总剩余上传照片数
    NSInteger _iTodayPhotoLimit;    //每日上传上限数
    NSInteger _iTotalPhotoLimit;    //用户总上传上限
    
    UserFindYouFromType _iUserFindYouType;  //用户通过什么方式找到你
    UserConnectionType _iUserConnection;    //用户与我的人脉关系类型
}

/**
 @since 5.4 用户职业
 */
@property (nonatomic) NSInteger occupation;

/**
 @since 5.4 （小辣椒）一段时间内是否说话
 */
@property (nonatomic) BOOL isSpeakJustNow;

/**
 @since 5.4 圈主
 */
@property (nonatomic) BOOL isGruopMaster;

/**
 @since 5.4 是否开启真心话大冒险
 */
@property (nonatomic) BOOL isChatOn;

/**
 @since 5.4 是否绑定相应的社交帐号
 */
@property (nonatomic) BOOL bIsBindQQZone;
@property (nonatomic) BOOL bIsBindFaceBook;
@property (nonatomic) BOOL bIsBindTwiter;
@property (nonatomic) BOOL bIsBindTXWb;

/**
   是否有交流标识,ver5.4
   0表示没有交流
   1表示有交流过
 */
@property (nonatomic) NSInteger isChat;

/**
	用户标识
 */
@property (nonatomic) long long userId;

/**
	用户头像
 */
@property (nonatomic, copy) NSString *icon;

/**
	vip标识 小于于等于0:普通 大于0 vip等级
 */
@property (nonatomic) NSInteger iVip;

/**
	6.0包月制new vip标识 小于于等于0:非vip 大于0 vip等级
 */
@property (nonatomic) NSInteger iNewVip;

/**
 6.0.1是否悄悄查看该用户消息的标识，适用于消息
 */
@property (nonatomic) BOOL isQuietlyToSee;

/**
	年龄
	@since ver2.1.0
 */
@property (nonatomic) NSInteger iAge;

/**
	在线标识
	@since ver2.1.0
 */
@property (nonatomic) BOOL bOnline;

/**
	性别
	@since ver2.1.0
 */
@property (nonatomic,copy) NSString *genderString;

/**
	纬度
    @since ver2.4.0
 */
@property (nonatomic) CLLocationDegrees fLat;

/**
	经度
    @since ver2.4.0
 */
@property (nonatomic) CLLocationDegrees fLng;

/**
	个人介绍
    @since ver2.4.0
 */
@property (nonatomic,copy) NSString *selfTextString;

/**
	最近上线时间
    @since ver2.4.0
 */
@property (nonatomic) NSTimeInterval fLastOnlineTime;


/**
	微博信息
    @since ver2.4.0
 */
@property (nonatomic,copy) NSString *weiboString;

/**
	与该用户的距离(本地计算)
    @since ver2.4.0
 */
//@property (nonatomic,readonly) CGFloat fLocalDistance;


/**
	与该用户的距离（服务器数据）
    @since ver2.4.0
 */
//@property (nonatomic) CGFloat fDistance;

/**
	是否绑定新浪微博
    @since ver2.4.0
 */
@property (nonatomic,readonly) BOOL bIsBindSinaWeibo;


/**
	是否为新浪微博认证用户
    @since ver2.4.0
 */
@property (nonatomic,readonly) BOOL bIsSinaWeiboAuthUser;

/**
 *	@brief	是否为新浪微博达人
 *
 *  @since  ver2.7.0
 */
@property (nonatomic,readonly) BOOL bIsSinaWeiboDaren;

/**
 *	@brief	是否为新浪微博会员
 *
 *  @since  ver2.7.0
 */
@property (nonatomic,readonly) BOOL bIsSinaWeiboVIP;

/**
 *	@brief	是否为新浪微博认证企业
 *
 *  @since  ver2.7.0
 */
@property (nonatomic,readonly) BOOL bIsSinaWeiboEnterprise;


/**
	备注名称
    @since ver2.6.0 仅用于个人信息备注名称显示列，判断是否设置备注名称
 */
@property (nonatomic,copy) NSString *noteNameString;

/**
	原昵称
    @since ver2.6.0 仅用于个人信息备注名称显示列。
 */
@property (nonatomic,copy) NSString *originNicknameString;

/**
	是否为封停用户
	@since ver3.3
 */
@property(nonatomic) BOOL bIsForbid;

@property(nonatomic) NSInteger gameLevel;//游戏达人标识

@property(nonatomic) BOOL isNewFans;//用于粉丝列表 区分是否是新粉丝

/**
 *  用户个人照片数量
 */
@property (nonatomic) NSInteger iPhotoNum;

/**
 关系标识：0:自己 1：好友 2：陌生人 3:我的关注 4：我的粉丝 5：好友推荐
 */
@property(nonatomic) NSInteger iRelation;

/**
 今日剩余上传照片数
 */
@property (nonatomic) NSInteger iTodayPhotoCount;

/**
 用户总剩余上传照片数
 */
@property (nonatomic) NSInteger iTotalPhotoCount;

/**
 每日上传上限数
 */
@property (nonatomic) NSInteger iTodayPhotoLimit;

/**
 用户总上传上限
 */
@property (nonatomic) NSInteger iTotalPhotoLimit;

/**
 用户通过什么方式找到你
 */
@property (nonatomic) UserFindYouFromType iUserFindYouType;
/**
 *  用户等级
 *  @since ver5.4
 */
@property (nonatomic, assign) NSInteger level;

/**
 *  用户与我的人脉关系
 *  @since ver5.5
 *  @brief 这个参数有一部分跟iUserFindYouType重合，不过互不干扰
 *         iUserFindYouType只用于用户找到我的途径，跟人脉关系无关
 */
@property (nonatomic, assign) UserConnectionType iUserConnection;

/**
 *  用户与我的人脉关系的中间节点信息
 *  @since ver5.5
 *  @brief 这个参数目前只有从游戏，圈子进个人资料会用到，其余情况为nil
 *         作用：显示关系链中间结点的信息
 */
//@property (nonatomic, retain) MiddleNode *chainMiddleInfo;

/**
 *  用户魅力值
 *  @since ver6.5
 */
@property (nonatomic, assign) long charmNum;

/**
 *  用户vip到期时间
 *  @since ver6.5
 */
@property (nonatomic, assign) NSTimeInterval vipExpire;

/**
 *  用户竞价出价金额
 *  @since ver6.5.1
 */
@property (nonatomic, assign) NSInteger offerPrice;

/**
 *  用户竞价出价时间
 *  @since ver6.5.1
 */
@property (nonatomic, assign) NSTimeInterval offerTime;

/**
 *  用户竞价当前剩余金额
 *  @since ver6.5.1
 */
@property (nonatomic, assign) float remainPrice;

/**
    一般大小的头像
 */
- (NSString *)getNormalIconURLStr;

/**
    用户昵称
 */
- (NSString *)nickName;

/**
	从在线用户列表回复中导入数据
    @since ver2.4.0
	@param data 数据对象
 */
- (void)importFromOnlineUsersResponse:(id)data;

/**
	从附近用户列表回复中导入数据
    @since ver2.4.0
	@param data 数据对象
 */
- (void)importFromNearbyUsersResponse:(id)data;

/**
	从粉丝列表中导入数据
    @since ver2.4.0
	@param data 数据对象
 */
- (void)importFromFansResponse:(id)data;

/**
	从关注列表中导入数据
    @since ver2.4.0
	@param data 数据对象
 */
- (void)importFromFollowsResponse:(id)data;

/**
	从好友列表中导入数据
    @since ver2.4.0
	@param data 数据对象
 */
- (void)importFromFriendsResponse:(id)data;


/**
    从数据读取器中导入数据
    @since ver2.4.0 从FriendInfo中迁移过来
    @param reader 数据读取器
 */
- (void)importFromDataReader:(FMResultSet *)reader;

/**
    从添加好友回复中导入数据
    @since ver2.4.0 从FriendInfo中迁移过来
    @param data 回复数据
 */
- (void)importFromAddFriendResponse:(id)data;

/**
    从好友通知中导入数据
    @since ver2.4.0 从FriendInfo中迁移过来
    @param data 通知数据
 */
- (void)importFromNotification:(id)data;

/**
	从话题喜欢用户列表中导入数据
    @since ver2.6.0 
	@param data 回复数据
 */
- (void)importFromTopicLikeUsersResponse:(id)data;

/**
 *  注册监听数据变化
 *
 *  @param obj         监听者
 *  @param callBackSel 回调Sel
 *  @param userId      用户id
 */
+ (void)addUserDataObserver:(id)obj callBackSel:(SEL)callBackSel userId:(long long)userId;

/**
 *  注销监听数据变化
 *
 *  @param obj         监听者
 *  @param userId      用户id
 */
+ (void)removeUserDataObserver:(id)obj userId:(long long)userId;

/**
 *  派发数据变化消息
 *
 *  @param userId      用户id
 *  @param changeData  修改数据
 */
+ (void)postUserDataChange:(long long)userId changeData:(NSDictionary *)changeData;

@end
