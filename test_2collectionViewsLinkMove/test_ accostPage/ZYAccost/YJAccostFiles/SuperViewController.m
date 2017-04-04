//
//  SuperViewController.m
//  TestChat
//
//  Created by  XXX on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SuperViewController.h"
#import "UserConfig.h"
#import "YJStatusBar.h"
#import "U6AppFacade+Proxy.h"
#import "CustomBarButton.h"
#import "IAroundUrlHandler.h"

@implementation SuperViewController


- (void)dealloc
{
    _appDelegate = nil;
    [self getShareObject].controllerDelegate = nil;
    [_facade removeNotification:self];

    YJ_RELEASE(_initObject);
	YJ_RELEASE(_notifyObject);

    [self dismissTips];

	//回收图片缓存
	[[U6ImagePool shareInstance] gc];

	[super dealloc];
}

-(id) initWithObj:(NSObject*)obj
{
    self = [super init];
	if (self)
    {
		self.initObject = obj;
	}
	return self;
}

-(void)initSelf
{
    [super initSelf];

    _appDelegate = (MeYouAppDelegate *)[[UIApplication sharedApplication] delegate];
	_globalData = [GlobalData getInstance];
    _facade = [U6AppFacade getInstance];
    
    _notifyObject = [[NotifyClass alloc] initWithObj:self];
    [self startNotify:YES];    
    [self getShareObject].controllerDelegate = self;
}


-(void)initViews
{
    [super initViews];
    
    if (self.navigationItem.leftBarButtonItem == nil)
    {
//        self.navigationItem.leftBarButtonItem =
//        [CustomBarButton barButtonWithImage:[UIImage imageNamed:@"back_arrow.png"]
//                                     target:self
//                                     action:@selector(leftBarButtonClick)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backItem;
        [btn release];
        [backItem release];
    }
    
    [self drawView];
}

- (void)drawView
{	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//在过滤器里监听推送通知
	[self.notifyObject startNotify];
	
    [self getShareObject];
    
    //统计
    StatProxy *statProxy = [_facade getStatProxy];
    [statProxy beginLogViewController:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	//在过滤器里移除推送通知
	[self.notifyObject stopNotify];
    
    //统计
    StatProxy *statProxy = [_facade getStatProxy];
    [statProxy endLogViewController:self];
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    [super presentModalViewController:modalViewController animated:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [super dismissModalViewControllerAnimated:animated];
}

- (void)startNotify:(BOOL)value
{
	self.notifyObject.canKick = value;
}

- (ShareClass *)getShareObject
{
    ShareClass *shareClass = nil;
    
	@synchronized(self)
	{
        shareClass = [ShareClass getSharedInstance];
        
        if (_shareDelegateRegister)
        {
            shareClass.controllerDelegate = _shareDelegateRegister;
        }
        else
        {
            shareClass.controllerDelegate = self;
        }
    }
    return shareClass;
}

#pragma mark LoadingView
-(void)showLoadingView
{
    self.view.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self presentLoadingTips:nil];
}

-(void)showLoadingViewNoTips
{
    self.view.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)hideLoadingView
{
    self.view.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
   [self dismissTips];
}

- (void)showLoadingActivity
{
    self.view.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hideLoadingActivity
{
    self.view.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)registShareDelegate:(id)shareDelegate
{
    _shareDelegateRegister = shareDelegate;
    
    [self getShareObject];
}

- (void)resignShareDelegate:(id)shareDelegate
{
    if (shareDelegate == _shareDelegateRegister)
    {
        _shareDelegateRegister = nil;
        [self getShareObject];
    }
}

- (void)showLoadingViewWithTips:(NSString *)tips
{
    self.view.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self presentLoadingTips:tips];
}

#pragma mark - Mothed
-(void)leftBarButtonClick
{
    [self.view endEditing:YES];

    if (self.view.window == [IAroundUrlHandler sharedInstance].window)
    {
        if ([self.navigationController.viewControllers indexOfObject:self] == 0)
        {
            if (self.navigationController == [IAroundUrlHandler sharedInstance].window.rootViewController)
            {
                [[IAroundUrlHandler sharedInstance] goBack];
            }
            else
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        if (self.navigationController != nil
            && [self.navigationController.viewControllers count] > 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

@end
