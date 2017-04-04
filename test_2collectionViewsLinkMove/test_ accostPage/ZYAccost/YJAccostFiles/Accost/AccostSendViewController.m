//
//  AccostSendViewController.m
//  iAround
//
//  Created by 123456 on 8/13/14.
//
//

#import "AccostSendViewController.h"
#import "AccostSendView.h"
//#import "UserInfoViewController.h"

@interface AccostSendViewController () <AccostSendViewDelegate>

@end

@implementation AccostSendViewController

- (void)initViews
{
    //[super initViews];
    
    self.title = NSLocalizedString(@"LINKMAN_TITLE_SEND_GREETING", nil);
    
    AccostSendView *contentView = [[AccostSendView alloc] initWithReuseIdentifier:@"ACCOST_RECEIVE_VIEW"
                                                                                  frame:CGRectMake(0.0,
                                                                                                   0.0,
                                                                                                   self.view.width,
                                                                                                   self.view.height)];
    contentView.delegate = self;
    [self.view addSubview:contentView];
//    [contentView release];
}

#pragma mark - AccostReceiveViewDelegate
- (void)accostSendView:(AccostSendView *)view
             showUserInfo:(UserInfo *)userInfo
{
    UserInfoViewController *viewController = [[UserInfoViewController alloc] initWithUserInfo:userInfo];
    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
}

- (void)accostSendView:(AccostSendView *)view
             chatWithUser:(UserInfo *)userInfo
{
    [_appDelegate goToUserChatVC:userInfo vc:self];
}

- (void)accostSendViewisEmpty:(AccostSendView *)view
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
