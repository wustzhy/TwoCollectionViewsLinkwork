//
//  SuperViewController.h
//  TestChat
//
//  Created by  XXX on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MeYouAppDelegate.h"
#import "GlobalData.h"
#import "U6ImagePool.h"
#import "CustomBarButton.h"
#import "UIBarButtonItem+Extension.h"
#import "BlockActionSheet.h"
#import "BlockAlertView.h"
#import "EGORefreshTableHeaderView.h"

#import "NotifyClass.h"
#import "ShareClass.h"
#import "U6AppFacade.h"
#import "YJTipsView.h"
#import "YJViewController.h"
#import "YJNoDataView.h"

#import "SettingViewConfig3_0.h"

@interface SuperViewController : YJViewController <ShareClassDelegate>
{
//	MeYouAppDelegate        *_appDelegate;
	NSObject                *_initObject;
	
	GlobalData              *_globalData; //全局数据
	
	NotifyClass             *_notifyObject;
    __block U6AppFacade     *_facade;
    
    id _shareDelegateRegister;//分享回调监听对象
}

@property (nonatomic, assign) id requestDelegate;
//@property (nonatomic, assign) MeYouAppDelegate *appDelegate;
@property (nonatomic, retain) NSObject *initObject;
@property (nonatomic, assign) GlobalData *globalData;
@property (nonatomic, retain) NotifyClass * notifyObject;

- (id) initWithObj:(NSObject*)obj;

- (void)drawView;
- (void)startNotify:(BOOL)value;
- (ShareClass *)getShareObject;

-(void)showLoadingView;
-(void)showLoadingViewNoTips;
-(void)hideLoadingView;
- (void)showLoadingActivity;
- (void)hideLoadingActivity;

- (void)registShareDelegate:(id)shareDelegate;
- (void)resignShareDelegate:(id)shareDelegate;

- (void)showLoadingViewWithTips:(NSString *)tips;

//左导航按钮默认处理函数。
//当 (self.navigationController != nil && [self.navigationController.viewControllers count] > 1) 时popViewControllerAnimated 否则 dismissModalViewControllerAnimated

// 子类可重写此函数， 改变返回时的行为
-(void)leftBarButtonClick;

@end
