//
//  AccostSendView.h
//  iAround
//
//  Created by 123456 on 8/13/14.
//
//

#import "ZGPageContentView.h"
#import "UserInfo.h"


@protocol AccostSendViewDelegate;

@interface AccostSendView : ZGPageContentView

{
    id<AccostSendViewDelegate> _delegate;
}

@property (nonatomic, assign) id<AccostSendViewDelegate> delegate;

@end

@protocol AccostSendViewDelegate <NSObject>
/**
 *  查看某用户信息
 *
 *  @param view     联系人列表视图
 *  @param userInfo 用户信息
 */
- (void)accostSendView:(AccostSendView *)view
             showUserInfo:(UserInfo *)userInfo;

/**
 *  与某用户进行私聊
 *
 *  @param view 联系人列表视图
 *  @param userInfo    用户信息
 */
- (void)accostSendView:(AccostSendView *)view
             chatWithUser:(UserInfo *)userInfo;
/**
 *  发出搭讪删空了
 *
 *  @param view 自己
 */
- (void)accostSendViewisEmpty:(AccostSendView *)view;

@end
