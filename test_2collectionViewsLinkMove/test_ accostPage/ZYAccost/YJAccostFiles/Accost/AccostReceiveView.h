//
//  AccostReceiveView.h
//  iAround
//
//  Created by 123456 on 8/1/14.
//
//

#define kNoti_ShowSanJiao @"kNoti_ShowSanJiao"//通知显示三角指示器
#define kNoti_HideSanJiao @"kNoti_HideSanJiao"//通知隐藏三角指示器

#import "ZGPageContentView.h"

@class UserInfo;
@class FriendProxy;

@interface AccostReceiveView : ZGPageContentView

/**
 *	@brief	初始化视图
 *
 *	@param 	reuseIdentifier 	复用标志
 *	@param 	frame 	显示区域
 *	@param 	viewController 	视图控制器
 *
 *	@return	视图对象
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame
               viewController:(UIViewController *)viewController;
/**
 *  清除聊天记录
 */
- (void)cleanHistory:(FriendProxy *)proxy;
/**
 *  举报并拉黑
 */
- (void)report;
/**
 *  去回复
 */
- (void)restore;
/**
 *  复用的时候更新userinfo,更新messagelistview的高度，用于搭讪设置的提示框消失后更新UI
 *
 *  @param userInfo 用户信息
 *  @param height   更新后的高度
 */
- (void)setUserInfo:(UserInfo *)userInfo;

@end
