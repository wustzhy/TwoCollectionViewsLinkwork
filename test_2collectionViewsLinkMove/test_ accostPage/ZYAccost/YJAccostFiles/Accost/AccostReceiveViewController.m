//
//  AccostReceiveViewController.m
//  iAround
//
//  Created by 123456 on 8/1/14.
//
//

#import "AccostReceiveViewController.h"
//#import "ZGPageView.h"  //
#import "AccostReceiveView.h"
//#import "BlockAlertView.h"
#import "AccostAvatarsView.h"
//#import "MeYouAppDelegate.h"
#import "YJMessageCell+Accost.h"
#import "YJAudioPlayManager.h"
#import "InfoReportReasonVC.h"
#import "FriendProxy.h"
#import "U6AppFacade+Proxy.h"
#import "UserInfoViewController.h"

#if !__has_feature(objc_arc)
#error no "objc_arc" compiler flag
#endif

#define DELETE_BUTTON_TAG   10086
#define RESTORE_BUTTON_TAG  10087
#define TITLE_VIEW_HEIGHT   YJ_AUTOSIZE_X(74)
#define TOOL_VIEW_HEIGHT    44
#define SETTING_VIEW_HEIGHT 31
#define MIN_FOR_SHOW_SETTING_NO_DISTURB 5
#define SECONDES_FOR_ONE_DAY (60*60*24)

#define WIDTH_PAGE_VIEW (YJ_WIDTH - 50) //每一个页面的宽度

const int pageBaseIndex = 1989;

#define ACCOST_DO_NOT_REMIND_FOREVER @"accostDoNotRemindForever"
#define ACCOST_DO_NOT_REMIND_ONEDAY @"accostDoNotRemindOneday"

@interface AccostReceiveViewController () <AccostAvatarsViewDelegate, InfoReportViewControllerDelegate, UIScrollViewDelegate>

{
    AccostAvatarsView *_avatarView; // 头像tableview
    UIScrollView *_pageView;
    UIView *_settingView;
    NSMutableArray *_greetingUserListArray;
    //U6AppFacade *_facade;
    
    
    NSMutableArray *_visiblePagesArray;
    NSMutableDictionary *_pageContentPool;
    
    BOOL _bIsPrincipal;
    
    UIView *_toolView;
    
    BOOL bShowBottomTipsView;//显示底部提醒View
    
    NSInteger _iCurrentPageIndex;//当前页码
    NSTimer* _iCurrentPageIndexTimer;//计算当前页码的Timer
    
}

@end

@implementation AccostReceiveViewController

#pragma mark - 生命周期
- (void)dealloc
{
    [YJMessageCell closeAccostType];
    
    [_pageView removeFromSuperview];
    _pageView = nil;
    [_greetingUserListArray removeAllObjects];
    _greetingUserListArray = nil;
//    [_facade removeNotification:self];
    [_iCurrentPageIndexTimer invalidate];
    _iCurrentPageIndexTimer = nil;
    [_avatarView removeFromSuperview];
    _avatarView = nil;
}

- (id)init
{
    if (self = [super init]) {
        
        _greetingUserListArray = [[NSMutableArray alloc] init];
        _visiblePagesArray = [[NSMutableArray alloc] init];
        _pageContentPool = [[NSMutableDictionary alloc] init];
        
        
//        _facade  = [U6AppFacade getInstance];
//        [_facade addNotification:NOTIF_COMMON_UPDATE_RECEIVE_GREETING
//                          target:self
//                        selector:@selector(updateGreetingUserListHandler:)];
        
//        [_facade addNotification:NOTIF_COMMON_UPDATE_CONTACT_ACCOST
//                          target:self
//                        selector:@selector(updateGreetingUserListHandler:)];
        
//        [[_facade getFriendProxy] getGreetingUserList];
        
        
    }
    return self;
}



- (void)initViews
{
    [super initViews];
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"ACCOST_TITLE", nil), _greetingUserListArray.count];
    self.view.backgroundColor = RGBCOLOR(0xe3, 0xe3, 0xe3);
    self.view.clipsToBounds = YES;

    _avatarView = [[AccostAvatarsView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, TITLE_VIEW_HEIGHT)];
    _avatarView.delegate = self;
    [self.view addSubview:_avatarView];

    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                self.viewHeight - TOOL_VIEW_HEIGHT,
                                                                self.viewWidth,
                                                                TOOL_VIEW_HEIGHT)];
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0,self.viewHeight - TOOL_VIEW_HEIGHT,
                                                         self.view.frame.size.width,
                                                         TOOL_VIEW_HEIGHT)];
    _toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_toolView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _toolView.width, 1.0f)];
    lineView.backgroundColor = RGBCOLOR(0xd2, 0xd2, 0xd2);
    [_toolView addSubview:lineView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [deleteBtn setTitle:NSLocalizedString(@"MENU_ITEM_DEL", nil) forState:UIControlStateNormal];
    [deleteBtn setImage:YJ_IMAGE_PNG(@"shanchu@2x") forState:UIControlStateNormal];
    [deleteBtn setImage:YJ_IMAGE_PNG(@"shanchu02@2x") forState:UIControlStateHighlighted];
    [deleteBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [deleteBtn setTitleColor:UIColorFromRGB(0x3399ff) forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(toolButtonClick:)];
    deleteBtn.tag = DELETE_BUTTON_TAG;
    deleteBtn.backgroundColor = [UIColor whiteColor];
    [deleteBtn sizeToFit];
    deleteBtn.frame = CGRectMake(YJ_AUTOSIZE_X(58.0f), 15.0f, 68, 18);
    [_toolView addSubview:deleteBtn];
    
    UIButton *restoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    restoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [restoreBtn setTitle:NSLocalizedString(@"FOCUS_BUTTON_TITLE_REPLY", nil) forState:UIControlStateNormal];
    [restoreBtn setTitleColor:UIColorFromRGB(0x666666)  forState:UIControlStateNormal];
    [restoreBtn setTitleColor:UIColorFromRGB(0x3399ff)  forState:UIControlStateHighlighted];
    [restoreBtn setImage:YJ_IMAGE_PNG(@"huifu@2x") forState:UIControlStateNormal];
    [restoreBtn setImage:YJ_IMAGE_PNG(@"huifu02@2x") forState:UIControlStateHighlighted];
    [restoreBtn addTarget:self action:@selector(toolButtonClick:)];
    restoreBtn.tag = RESTORE_BUTTON_TAG;
    restoreBtn.backgroundColor = [UIColor whiteColor];
    restoreBtn.frame = CGRectMake(YJ_AUTOSIZE_X(200.0f), 15.0f, 68, 18);
    [restoreBtn sizeToFit];
    [_toolView addSubview:restoreBtn];
    
    
    
    self.navigationItem.rightBarButtonItem = [CustomBarButton barButtonWithTitle:NSLocalizedString(@"VIEW_CONTROLLER_TITLE_REPORT", nil)
                                                                          target:self
                                                                          action:@selector(report:)];
    
    _pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(23.0f,
                                                             _avatarView.height,
                                                             self.viewWidth - 46.0f,
                                                             self.viewHeight - _avatarView.height - _toolView.height)];
    _pageView.delegate = self;
    _pageView.clipsToBounds = NO;
    _pageView.scrollsToTop = NO;
    _pageView.showsVerticalScrollIndicator = NO;
    _pageView.showsHorizontalScrollIndicator = NO;
    _pageView.pagingEnabled = YES;
    [self.view addSubview:_pageView];
    [self.view setUserInteractionEnabled:YES];
    
    _bIsPrincipal = YES;
    _avatarView.bIsPrincipal = !_bIsPrincipal;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YJMessageCell openAccostType];
    [_iCurrentPageIndexTimer invalidate];
    _iCurrentPageIndexTimer = nil;
    _iCurrentPageIndexTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setCurrentPageIndex) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [YJMessageCell closeAccostType];
    [[YJAudioPlayManager sharedInstance] stop];
    [_iCurrentPageIndexTimer invalidate];
    _iCurrentPageIndexTimer = nil;
}

#pragma mark - scrollView相关

- (void)recoverVisiblePageContentViews
{
    while (_visiblePagesArray.count)
    {
        ZGPageContentView *contentView = [_visiblePagesArray lastObject];
        [self recoverVisiblePageContentView:contentView];
        [_visiblePagesArray removeLastObject];
    }
}

- (void)recoverVisiblePageContentView:(ZGPageContentView *)pageContentView
{
    NSMutableArray *array = [_pageContentPool objectForKey:pageContentView.reuseIdentifier];
    if (array == nil)
    {
        array = [NSMutableArray array];
        [_pageContentPool setObject:array forKey:pageContentView.reuseIdentifier];
    }
    [array addObject:pageContentView];
    [pageContentView removeFromSuperview];
}

- (ZGPageContentView *)dequeueReusablePageWithIdentifier:(NSString *)identifier
{
    NSMutableArray *viewArray = [_pageContentPool objectForKey:identifier];
    if (viewArray && viewArray.count > 0) {
        ZGPageContentView *view = [viewArray lastObject];
        [viewArray removeLastObject];
        return view;
    }
    return nil;
}

- (void)reloadData
{
    _pageView.contentSize = CGSizeMake(_greetingUserListArray.count * _pageView.width, _pageView.height);
    
    [self recoverVisiblePageContentViews];
    
    [self loadPageContentViewAtIndex:_iCurrentPageIndex];
    [self loadPageContentViewAtIndex:_iCurrentPageIndex - 1];
    [self loadPageContentViewAtIndex:_iCurrentPageIndex  + 1];
}

- (ZGPageContentView *)loadPageContentViewAtIndex:(NSInteger)index
{
    
    if (index < 0 || index >= _greetingUserListArray.count) {
        return nil;
    }
    ZGPageContentView *pageContentView = [self pageForIndexPath:index];
    if (pageContentView)
    {
        // tag用于判断回收和是否已经显示
        pageContentView.tag = pageBaseIndex + index;
        CGRect pageContentRect = pageContentView.frame;
        pageContentRect.origin.x = index * _pageView.width + 6.0f;
        pageContentView.frame = pageContentRect;
        [_pageView insertSubview:pageContentView atIndex:0];
        [_visiblePagesArray addObject:pageContentView];
    }
    return  pageContentView;
}

- (void)scrollToPage:(NSUInteger)pageIndex animated:(BOOL)animated
{
    CGRect rect = CGRectMake(_pageView.width * pageIndex, 0.0, _pageView.width, _pageView.height);
    [_pageView scrollRectToVisible:rect animated:animated];
}

- (ZGPageContentView *)pageForIndexPath:(NSInteger)index
{
    static NSString *pageID = @"accostPageContent";
    AccostReceiveView *view = (AccostReceiveView *)[self dequeueReusablePageWithIdentifier:pageID];
    if (view == nil) {
        view = [[AccostReceiveView alloc] initWithReuseIdentifier:pageID
                                                            frame:CGRectMake(0, 0, _pageView.width - 12.0f, _pageView.height)
                                                   viewController:self];
    }
    ContactInfo *contactInfo = [_greetingUserListArray objectAtIndex:index];
    UserInfo *userInfo = contactInfo.userInfo;
    [view setUserInfo:userInfo];
    
    return view;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger nowPageIndex = floor(scrollView.contentOffset.x / scrollView.width);
    if (nowPageIndex < 0) {
        nowPageIndex = 0;
    }
    
    NSInteger startPageIndex = nowPageIndex - 1;
    NSInteger endPageIndex = nowPageIndex + 2;
    
    //检测是否需要生成显示页面
    for (NSInteger i = startPageIndex; i <= endPageIndex; i++)
    {
        BOOL bHasExists = NO;
        for (int j = 0; j < [_visiblePagesArray count]; j++) {
            ZGPageContentView *contentView = (ZGPageContentView *)[_visiblePagesArray objectAtIndex:j];
            if (contentView.tag - pageBaseIndex == i) {
                bHasExists = YES;
                break;
            }
        }
        
        if (!bHasExists) {
            [self loadPageContentViewAtIndex:i];
        }
    }
    
    //检测是否有需要回收页面
    for (int i = 0; i < [_visiblePagesArray count]; i++)
    {
        ZGPageContentView *pageContentView = [_visiblePagesArray objectAtIndex:i];
        NSInteger pageIndex = pageContentView.tag - pageBaseIndex;
        if (pageIndex < startPageIndex || pageIndex > endPageIndex)
        {
            [self recoverVisiblePageContentView:pageContentView];
            [_visiblePagesArray removeObject:pageContentView];
        }
    }
    
    // 是否让上边的avatarview随自己滚动
    if (_bIsPrincipal) {
        NSInteger quotient = scrollView.contentOffset.x / scrollView.width;
        CGFloat remainder = scrollView.contentOffset.x - quotient * scrollView.width;
        CGFloat percent = remainder / scrollView.width;
        [_avatarView makeScrollToIndex:quotient withOffset:percent];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self snapToGridForPoint:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self snapToGridForPoint:scrollView.contentOffset];
}

- (void)snapToGridForPoint:(CGPoint)proposedContentOffset
{
//    NSInteger quotient = proposedContentOffset.x / _pageView.width;
//    CGFloat remainder = proposedContentOffset.x - quotient * _pageView.width;
//    
//    CGRect targetRect = CGRectZero;
//    if (remainder <= _pageView.width / 2) {
//        _iCurrentPageIndex = quotient;
//        targetRect = CGRectMake(_iCurrentPageIndex * _pageView.width, 0, _pageView.width, _pageView.height);
//    } else {
//        _iCurrentPageIndex = quotient + 1;
//        targetRect = CGRectMake(_iCurrentPageIndex * _pageView.width, 0, _pageView.width, _pageView.height);
//    }
    
    CGRect targetRect = CGRectZero;
    _iCurrentPageIndex = [self calCurrentPageIndex];
    targetRect = CGRectMake(_iCurrentPageIndex * _pageView.width, 0, _pageView.width, _pageView.height);
    [_pageView scrollRectToVisible:targetRect animated:YES];
    if (_iCurrentPageIndex < _greetingUserListArray.count)
    {
        ContactInfo *contactInfo = [_greetingUserListArray objectAtIndex:_iCurrentPageIndex];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNoti_ShowSanJiao object:contactInfo];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _bIsPrincipal = YES;
    _avatarView.bIsPrincipal = !_bIsPrincipal;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNoti_HideSanJiao object:nil];
}

#pragma mark - Private
- (AccostReceiveView *)findAccostReceiveView
{
    _iCurrentPageIndex = [self calCurrentPageIndex];
    for (ZGPageContentView *contentView in _visiblePagesArray) {
        if (contentView.tag - pageBaseIndex == _iCurrentPageIndex) {
            return (AccostReceiveView *)contentView;
        }
    }
    return nil;
}

- (void)report:(id)sender
{
    [[self findAccostReceiveView] report];
}

- (void)toolButtonClick:(UIButton *)btn
{
    if (!([_greetingUserListArray count] > 0))
    {
        return;
    }
    
    switch (btn.tag)
    {
        case DELETE_BUTTON_TAG:
        {
            _iCurrentPageIndex = [self calCurrentPageIndex];
            [_greetingUserListArray removeObjectAtIndex:_iCurrentPageIndex];
//            [[self findAccostReceiveView] cleanHistory:[_facade getFriendProxy]];
            if (_greetingUserListArray.count > 0)
            {
                [self reloadData];
                [_avatarView reloadData];
                self.title = [NSString stringWithFormat:NSLocalizedString(@"ACCOST_TITLE", nil), _greetingUserListArray.count];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
        case RESTORE_BUTTON_TAG:
        {
            _iCurrentPageIndex = [self calCurrentPageIndex];
            ContactInfo *info = _greetingUserListArray[_iCurrentPageIndex];
            info.userInfo.fDistance *= 1000;
//            MeYouAppDelegate *appDelegate = (MeYouAppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate goToUserChatVC:info.userInfo vc:self];
            break;
        }
        default:
            break;
    }
}

#pragma mark - InfoReportViewControllerDelegate
-(void)onReportSuccess
{
//    [_iCurrentPageIndexTimer invalidate];
//    _iCurrentPageIndexTimer = nil;
//    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - AccostAvatarsViewDelegate

- (void)accostAvatarsView:(AccostAvatarsView *)view seleteAvatarAtIndex:(NSInteger)index
{
    [self scrollToPage:index animated:YES];
    _iCurrentPageIndex = [self calCurrentPageIndex];
    if (_iCurrentPageIndex == index && _iCurrentPageIndex < _greetingUserListArray.count) {
        ContactInfo *info = _greetingUserListArray[index];
        UserInfoViewController *viewController = [[UserInfoViewController alloc] initWithUserInfo:info.userInfo];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)accostAvatarsViewWillBeginDragging:(AccostAvatarsView *)view
{
    _bIsPrincipal = NO;
}

- (void)accostAvatarsView:(AccostAvatarsView *)view didEndScrollAtIndex:(NSInteger)index
{
    _iCurrentPageIndex = [self calCurrentPageIndex];
}


- (void)accostAvatarsView:(AccostAvatarsView *)view didScrollToIndex:(NSInteger)index withOffset:(CGFloat)offset
{
    CGFloat transitionOffset = offset * _pageView.width;
    [_pageView setContentOffset:CGPointMake((index * _pageView.width + transitionOffset), 0)];
}

#pragma mark - FriendProxy Notification
- (void)updateGreetingUserListHandler:(NSNotification *)notif
{
    
//    [_facade removeNotification:NOTIF_COMMON_UPDATE_RECEIVE_GREETING target:self];
    
    // 刷新收到搭讪分组列表的用户数据
    [_greetingUserListArray removeAllObjects];
    
    //对从数据库中取出的数据按时间排序
    NSMutableArray *arr = [NSMutableArray array];
//    [arr addObjectsFromArray:[_facade getFriendProxy].greetingUserArray];
    NSMutableArray *greetingArray = [NSMutableArray array];
    
    NSMutableArray *msgIdArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i++)
    {
        id info = arr[i];
        if ([info isKindOfClass:[ContactInfo class]])
        {
            long long msgId = ((ContactInfo *)info).llMsgId;
            [msgIdArr addObject:[NSNumber numberWithLongLong:msgId]];
        }
    }
    [msgIdArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 longLongValue] < [obj2 longLongValue];
    }];
    
    for (int i = 0; i < msgIdArr.count; i++)
    {
        NSNumber *msgId = msgIdArr[i];
        for (int j = 0; j < arr.count; j++)
        {
            id info = arr[j];
            if ([info isKindOfClass:[ContactInfo class]])
            {
                long long msId = ((ContactInfo *)info).llMsgId;
                if (msgId.longLongValue == msId)
                {
                    [greetingArray addObject:info];
                }
            }
        }
    }
    
    [_greetingUserListArray addObjectsFromArray:greetingArray];
    
    if (_greetingUserListArray.count == 0) {
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [mArray removeObject:self];
        NSArray *array = [NSArray arrayWithArray:mArray];
        [self.navigationController setViewControllers:array animated:YES];
        return;
    }
    
    [_avatarView setUsers:_greetingUserListArray];
    [self reloadData];
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"ACCOST_TITLE", nil), _greetingUserListArray.count];
    
    
    ContactInfo* contactInfo = [_greetingUserListArray objectAtIndex:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNoti_ShowSanJiao object:contactInfo];

    
}

-(void)setCurrentPageIndex
{
    
//    NSLog(@"计算前：%d",_iCurrentPageIndex);
//    NSLog(@"计算后:%d",(int)_pageView.contentOffset.x/WIDTH_PAGE_VIEW);
//    NSLog(@"test:%f\n\n",_pageView.contentOffset.x);
    _iCurrentPageIndex = _pageView.contentOffset.x/WIDTH_PAGE_VIEW;
}
-(NSInteger)calCurrentPageIndex
{
    return _pageView.contentOffset.x/WIDTH_PAGE_VIEW;
}
@end
