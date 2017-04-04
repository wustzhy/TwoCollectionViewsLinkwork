//
//  AccostReceiveView.m
//  iAround
//
//  Created by 123456 on 8/1/14.
//
//

#import "AccostReceiveView.h"
#import "GenderView.h"
#import "UserInfo.h"
#import "UserMessageProxy.h"
#import "U6AppFacade.h"
#import "U6AppFacade+Proxy.h"
#import "U6Common.h"
#import "YJAudioPlayManager.h"
#import "YJHDPhotoWindow.h"
#import "YJVideoPlayerVC.h"
#import "U6MapViewController.h"
#import "InfoReportReasonVC.h"
#import "U6CacheStorage.h"
#import "DatabaseProxy.h"
#import "DBNotificationDefinition.h"

#import "YJMessageCell+Accost.h"

#import "ZGP2PTextMessageCell.h"
#import "ZGP2PAudioMessageCell.h"
#import "ZGP2PPictureMessageCell.h"
#import "ZGP2PVideoMessageCell.h"
#import "ZGP2PLocationMessageCell.h"
#import "ZGP2PGiftMessageCell.h"
#import "ZGP2PMapMessageCell.h"
#import "ZGP2PShareMsgCell.h"
#import "PhotoInfo.h"

#import "AccostMessageListView.h"
#import "U6WebViewController.h"

#if !__has_feature(objc_arc)
#error no "objc_arc" compiler flag
#endif

#define AVATAR_SIZE                 75
#define PADDING                     10
#define FORBID_USER_MARK_X          260
#define USERINFO_VIEW_HEIGHT        129
#define PHOTOS_VIEW_HEIGHT          64

@interface AccostReceiveView () <AccostMessageListViewDelegate, ZGImageViewDelegate, YJMessageCellDelegate>
{
    AccostMessageListView       *_contentListView;
    
    UIView                  *_userInfoView;
    UserInfo                *_userInfo;
	UILabel                 *_nameLabel;
    UILabel                 *_wayLabel;
    UIView                  *_photosView;
    UIView                  *_lineView;
    GenderView              *_ageGenderView;
    U6AppFacade             *_facade;
    __weak UIViewController *_superViewController; //强引用
    DatabaseProxy           *_dbProxy;
    
    MessageInfo             *_curPlayMessageInfo;
    NSMutableArray          *_messageArray;
    
    // 更新用户照片
    U6AsyncToken            *_getUserLatestPhotos;
    // 拉黑并举报
    U6AsyncToken            *_addDevilToken;
    
    
    UIImageView             *ivIndicator;//三角指示符
    
    NSMutableArray *_imageArray;//照片大图展示的数组，6.2添加
    NSMutableArray *_arrImages;//消息中是图片消息的数组，6.2添加
}

@property (nonatomic, strong) UIImage *otherUserBGImage;

@end

@implementation AccostReceiveView

+(void)initialize
{
    // 保证swizzling只有在收到搭讪这个类被用到的时候才执行，此方法仅类被使用时执行一次
    [YJMessageCell swizzling];
    
    [ZGP2PTextMessageCell swizzling];
    [ZGP2PAudioMessageCell swizzling];
    [ZGP2PPictureMessageCell swizzling];
    [ZGP2PVideoMessageCell swizzling];
    [ZGP2PLocationMessageCell swizzling];
    [ZGP2PGiftMessageCell swizzling];
    [ZGP2PMapMessageCell swizzling];
    [ZGP2PShareMsgCell swizzling];
}

-(void)dealloc
{
    if (_messageArray)
    {
        _messageArray = nil;
    }
    
    if (_dbProxy)
    {
        _dbProxy = nil;
    }
    
    [_facade removeNotification:self];
    [[YJAudioPlayManager sharedInstance] removeEventListener:self];
    
    //先把四张图片View去掉
    for (UIView* view in [_photosView subviews])
    {
        [view removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self releaseAddDevilToken];
    [self releaseGetGreetingUserInfoToken];
    
    _arrImages = nil;
    _imageArray = nil;
}

#pragma mark - Public

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
                        frame:(CGRect)frame
               viewController:(UIViewController *)viewController
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier frame:frame])
    {
        self.clipsToBounds = YES;
        _facade = [U6AppFacade getInstance];
        _dbProxy = [_facade getDatabase];
        _messageArray = [[NSMutableArray alloc] init];
        
        _superViewController = viewController;
        
        UIImage *image = [UIImage imageNamed:@"chat_accostview_left"];
        self.otherUserBGImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        
        //监听语音录制情况
        YJAudioPlayManager *audioPlayManager = [YJAudioPlayManager sharedInstance];
        [audioPlayManager addEventListener:notifiChatAudioPlay
                                    target:self
                                  selector:@selector(handleAudioPlayManagerMsg:)];
        
        [self createUserInfoView];
        [self createTableView];
        [self createSanjiao];
        [self createPhotosView];
        [self createUserFindYouWayView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSanjiaoNoti:) name:kNoti_ShowSanJiao object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideSanjiao) name:kNoti_HideSanJiao object:nil];
        
        //照片大图展示的数组，6.2添加
        _imageArray = [[NSMutableArray alloc] init];
        //消息中是图片消息的数组，6.2添加
        _arrImages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)cleanHistory:(FriendProxy *)proxy
{
    UserMessageProxy *messageProxy = [_facade getUserMessageProxyWithUser:_userInfo];
    [messageProxy addRef];
    [messageProxy cleanMessageHistory];
    [messageProxy releaseRef];
    messageProxy = nil;
    
    [proxy removeLinkman:_userInfo];
    [_dbProxy updateLinkmanOfSendAndReceiveInfo];
}

- (void)report
{
    void (^block)() = ^(){
        [self releaseAddDevilToken];
        if (_addDevilToken == nil) {
            _addDevilToken = [_facade addDevil:_userInfo.userId userData:nil];
            [_addDevilToken addNotification:NOTIF_BLL_HTTP_TOKEN_RESULT
                                     target:self
                                   selector:@selector(addDevilResultHandler:)];
            [_addDevilToken addNotification:NOTIF_BLL_HTTP_TOKEN_ERROR
                                     target:self
                                   selector:@selector(addDevilFaultHandler:)];
        }
    };
    
    BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:NSLocalizedString(@"VIEW_CONTROLLER_TITLE_REPORT", nil) message:NSLocalizedString(@"REPORT_AND_BLOCK_USER", nil)];
    [alertView setCancelButtonWithTitle:NSLocalizedString(@"CHATROOM_CANCEL", nil) block:nil];
    [alertView addButtonWithTitle:NSLocalizedString(@"FRIENDS_OK", nil) block:block];
    [alertView show];
}

- (void)restore
{
    MeYouAppDelegate *appDelegate = (MeYouAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate goToUserChatVC:_userInfo vc:_superViewController];
}


- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    
    // 用户资料socket
    [self updateHeadViewInfoFromSocket];
    // 用户照片
    NSDictionary *photoCacheData = [U6CacheStorage getUserLatestPhotosCacheData:[_facade getCurrentUser].info.userId viewUesrId:_userInfo.userId];
    if (photoCacheData)
    {
        [self dealUserPhotos:[photoCacheData objectForKey:KEY_PHOTOS]];
    }
    else
    {
        [self updateGreetingUserInfo];
    }
    // 搭讪记录
    [self updateContentView];
    
}

#pragma mark - HTTP请求
#pragma mark 举报并拉黑
- (void)releaseAddDevilToken
{
    [_addDevilToken removeNotification:NOTIF_BLL_HTTP_TOKEN_RESULT target:self];
    [_addDevilToken removeNotification:NOTIF_BLL_HTTP_TOKEN_ERROR target:self];
    [_addDevilToken cancel];
    _addDevilToken = nil;
}

- (void)addDevilResultHandler:(NSNotification *)notif
{
    [self releaseAddDevilToken];
    
    NSNumber *statusNumber = [[notif userInfo] objectForKey:KEY_RESPONSE_STATUS];
    if ([statusNumber boolValue])
    {
        [self presentSuccessTips:NSLocalizedString(@"MESSAGE_INFO_ADD_BLACKLIST_SUC",@"加入黑名单成功!")];
        
        [self performSelector:@selector(showReportView)
                   withObject:nil
                   afterDelay:1.3];
    }
    else
    {
        NSString *errorString = [[notif userInfo] objectForKey:KEY_ERROR_TEXT];
        if ([[[notif userInfo] objectForKey:KEY_ERROR_CODE] intValue]!=4100)
        {
            [self presentFailureTips:errorString];
        }
    }
}

- (void)addDevilFaultHandler:(NSNotification *)notif
{
    [self releaseAddDevilToken];
    
    NSString *errorString = [[notif userInfo] objectForKey:KEY_ERROR_TEXT];
    if ([[[notif userInfo] objectForKey:KEY_ERROR_CODE] intValue]!=4100)
    {
        [self presentFailureTips:errorString];
    }
}

#pragma mark 更新用户照片
- (void)updateGreetingUserInfo
{
    [self releaseGetGreetingUserInfoToken];
    
    if (_getUserLatestPhotos == nil) {
        _getUserLatestPhotos = [_facade getUserLatestPhotos:_userInfo.userId photoNum:9 userData:nil];
        [_getUserLatestPhotos addNotification:NOTIF_BLL_HTTP_TOKEN_RESULT
                                            target:self
                                          selector:@selector(getUserLatestPhotosResultHandler:)];
        [_getUserLatestPhotos addNotification:NOTIF_BLL_HTTP_TOKEN_ERROR
                                            target:self
                                          selector:@selector(getUserLatestPhotosFaultHandler:)];
    }
    
}

- (void)releaseGetGreetingUserInfoToken
{
    [_getUserLatestPhotos removeNotification:NOTIF_BLL_HTTP_TOKEN_RESULT target:self];
    [_getUserLatestPhotos removeNotification:NOTIF_BLL_HTTP_TOKEN_ERROR target:self];
    [_getUserLatestPhotos cancel];
    _getUserLatestPhotos = nil;
}

- (void)getUserLatestPhotosResultHandler:(NSNotification *)notif
{
    [self releaseGetGreetingUserInfoToken];
    [self dealUserPhotos:[[notif userInfo] objectForKey:KEY_PHOTOS]];
    
}

- (void)getUserLatestPhotosFaultHandler:(NSNotification *)notif
{
    [self releaseGetGreetingUserInfoToken];
    
    NSString *errorString = [[notif userInfo] objectForKey:KEY_ERROR_TEXT];
    if ([[[notif userInfo] objectForKey:KEY_ERROR_CODE] intValue]!=4100)
    {
        [self presentFailureTips:errorString];
    }
}


#pragma mark - AccostMessageListViewDelegate

- (void)listView:(AccostMessageListView *)listView createItemCell:(UITableViewCell *)cell
{
    if ([cell isKindOfClass:[YJMessageCell class]])
    {
        YJMessageCell *theCell = (YJMessageCell *)cell;
        theCell.delegate = self;
        [theCell setBgImg:_otherUserBGImage];
        [theCell updateViewAjustAccost];
    }
}

#pragma mark - Private
- (void)createUserInfoView
{
    _userInfoView = [[UIView alloc] init];
    _userInfoView.backgroundColor = [UIColor whiteColor];
    
    // Name
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18.0f,
                                                           15.0f,
                                                           20.0f,
                                                           13.0f)];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:13.0];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _nameLabel.textColor = [UIColor blackColor];
    [_userInfoView addSubview:_nameLabel];
    
    // Age
    _ageGenderView = [[GenderView alloc] initWithFrame:CGRectZero];
    [_userInfoView addSubview:_ageGenderView];
    
    // 时间轴部分，通过xxx找到你的部分
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _nameLabel.buttom + 12.0f, self.width, 1.0f)];
    _lineView.backgroundColor = RGBCOLOR(0xee, 0xee, 0xf1);
    [_userInfoView addSubview:_lineView];
    
    _userInfoView.frame = CGRectMake(0, 0, self.width, _lineView.buttom);
    
}

- (void)createTableView
{
    _contentListView = [[AccostMessageListView alloc] initWithFrame:CGRectMake(0.0, 10.0f, self.width, self.height - 10.0f)];
    _contentListView.delegate = self;
    _contentListView.backgroundColor = [UIColor whiteColor];

    _contentListView.textMessageItemType = [ZGP2PTextMessageCell class];
    _contentListView.videoMessageItemType = [ZGP2PVideoMessageCell class];
    _contentListView.audioMessageItemType = [ZGP2PAudioMessageCell class];
    _contentListView.locationMessageItemType = [ZGP2PLocationMessageCell class];
    _contentListView.imageMessageItemType = [ZGP2PPictureMessageCell class];
    _contentListView.giftMessageItemType = [ZGP2PGiftMessageCell class];
    _contentListView.mapMessageItemType = [ZGP2PMapMessageCell class];
    _contentListView.shareMessageItemType = [ZGP2PShareMsgCell class];
    
    _contentListView.tableHeaderView = _userInfoView;
    
    [self addSubview:_contentListView];
    
    // 上端圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentListView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _contentListView.bounds;
    maskLayer.path = maskPath.CGPath;
    _contentListView.layer.mask = maskLayer;
}

- (void)createPhotosView
{
    _photosView = [[UIView alloc] initWithFrame:CGRectMake(12.0f, _nameLabel.buttom + 12.0f, self.width - 24.0f, PHOTOS_VIEW_HEIGHT)];
}
-(void)setPhotosView:(NSArray *)photoArray_
{
    if ([photoArray_ count] > 0)
    {
        NSInteger photoCount = [photoArray_ count];
        if (photoCount > 4)
        {
            photoCount = 4;
        }
        for(NSInteger i = 0; i < photoCount; i++)
        {
            ZGImageView *imageView = [[ZGImageView alloc] initWithFrame:CGRectMake(6.0f + i * (52.0f + 6.0f),
                                                                                   0,
                                                                                   52.0f,
                                                                                   52.0f)];
            imageView.defaultImage = nil;
            [_photosView addSubview:imageView];
            
            PhotoInfo *photoInfo = (PhotoInfo *)[photoArray_ objectAtIndex:i];
            [imageView loadImageByUrlString:photoInfo.thumbImage];
        }
    }
}

- (void)createUserFindYouWayView
{
    _wayLabel = [[UILabel alloc] initWithFrame:CGRectMake(23.0f,
                                                          _lineView.buttom + 11.0f,
                                                          self.width - 15.0f,
                                                          9.0f)];
    _wayLabel.font = [UIFont systemFontOfSize:9.0f];
    _wayLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _wayLabel.textColor = RGBCOLOR(0xa9,0xa9,0xa9);
    _wayLabel.backgroundColor = [UIColor clearColor];
}

#pragma mark -三角指示符相关方法
- (void)createSanjiao
{
    ivIndicator = [[UIImageView alloc] initWithImage:UIIMAGE(@"sanjiao.png")];
    [ivIndicator sizeToFit];
    ivIndicator.center = CGPointMake(self.width / 2, YJ_AUTOSIZE_X(20.0f) - YJ_AUTOSIZE_X(ivIndicator.height) / 2);
    [self addSubview:ivIndicator];
}
-(void)showSanjiao
{
    [UIView animateWithDuration:0.25 animations:
     ^{
         ivIndicator.center = CGPointMake(self.width / 2, YJ_AUTOSIZE_X(10.0f) - YJ_AUTOSIZE_X(ivIndicator.height) / 2);
     }];
}
-(void)hideSanjiao
{
    [UIView animateWithDuration:0.25 animations:
     ^{
         ivIndicator.center = CGPointMake(self.width / 2, YJ_AUTOSIZE_X(20.0f) - YJ_AUTOSIZE_X(ivIndicator.height) / 2);
     }];
}
-(void)showSanjiaoNoti:(NSNotification *)notification_
{
    ContactInfo* contactInfo = notification_.object;
    UserInfo*    userInfo = contactInfo.userInfo;
    
    if (_userInfo.userId == userInfo.userId) {
        [self showSanjiao];
    }
    else
    {
        [self hideSanjiao];
    }
}

#pragma mark 复用的信息
- (void)reloadTableViewHeadView
{
    CGFloat viewHeight = 0;
    NSArray *subviews = [_userInfoView subviews];
    
    //名字
    viewHeight = _nameLabel.buttom + 14;
    _lineView.frame = CGRectMake(0, _nameLabel.buttom + 12.0f, self.width, 1.0f);
    //照片
    if ([[_photosView subviews] count] > 0)
    {
        _lineView.frame = CGRectMake(0, _photosView.buttom, self.width, 1.0f);
        viewHeight += 66;
    }
    //从xx找到你
    if ([subviews containsObject:_wayLabel])
    {
        [_wayLabel sizeToFit];
        _wayLabel.frame = CGRectMake(23.0f,_lineView.buttom + 11.0f, _wayLabel.width, _wayLabel.height);
        viewHeight += 8 + _wayLabel.height;
    }
    //分割线
    viewHeight += 1;
    _userInfoView.frame = CGRectMake(0, 0, self.width, viewHeight);
    
    _contentListView.tableHeaderView = nil;
    _contentListView.tableHeaderView = _userInfoView;
    _contentListView.tableHeaderView.frame = CGRectMake(_contentListView.left,
                                                        _contentListView.top,
                                                        _contentListView.width,
                                                        viewHeight);
}

// 取到聊天记录后更新认识方式
- (void)dealUserFindYouWay:(UserInfo *)userInfo
{
    if (userInfo.iUserFindYouType == UserFindYouFromTypeUnknown) {
        return;
        
    }
    
    NSDictionary *dic = @{@(UserFindYouFromTypeGlobalFocus): NSLocalizedString(@"FOUND_YOU_THROUGH_GLOBAL_FOCUS", nil),
                          @(UserFindYouFromTypeIDSearch):NSLocalizedString(@"FOUND_YOU_THROUGH_IAROUND_ID", nil),
                          @(UserFindYouFromTypeNearbyFocus):NSLocalizedString(@"FOUND_YOU_THROUGH_NEARBY_FOCUS", nil),
                          @(UserFindYouFromTypeNearbyList):NSLocalizedString(@"FOUND_YOU_THROUGH_NEARBY_PEOPLE", nil),
                          @(UserFindYouFromTypeNearbyMap):NSLocalizedString(@"FOUND_YOU_THROUGH_IAROUND_MAP", nil),
                          @(UserFindYouFromTypeNicknameSearch):NSLocalizedString(@"FOUND_YOU_THROUGH_NICKNAME_SEARCH", nil)};
    _wayLabel.text = dic[@(userInfo.iUserFindYouType)]?:nil;
    
    [_userInfoView addSubview:_wayLabel];
    
    [self reloadTableViewHeadView];
    
}

// http请求后更新用户照片
- (void)dealUserPhotos:(NSArray *)userPhotos_
{
    if ([userPhotos_ count] > 0)
    {
        [self setPhotosView:userPhotos_];
        [_userInfoView addSubview:_photosView];
    }
    [self reloadTableViewHeadView];
}

// 复用的时候更新名字和性别年龄
- (void)updateHeadViewInfoFromSocket
{
    _nameLabel.text = _userInfo.originNicknameString;
    [_nameLabel sizeToFit];
    _nameLabel.frame = CGRectMake(18.0f,
                                  15.0f,
                                  _nameLabel.width,
                                  _nameLabel.height);
    
    BOOL bIsM = [_userInfo.genderString isEqualToString:@"m"];
    [_ageGenderView setAge:_userInfo.iAge male:bIsM?YES:NO];
    [_ageGenderView sizeToFit];
    _ageGenderView.frame = CGRectMake(_nameLabel.right + 12.0f,
                                      _nameLabel.top,
                                      26.0f,
                                      12.0f);
    
    for (UIView* view in [_photosView subviews])
    {
        [view removeFromSuperview];
    }
    [_photosView removeFromSuperview];
    [_wayLabel removeFromSuperview];
    
    [self reloadTableViewHeadView];
}


// 取聊天记录
- (void)updateContentView
{
    [_dbProxy getReceiveGreetingMessageList:_userInfo];
    [_facade removeNotification:self];
    [_facade addNotification:NOTIF_DB_GET_GREETING_MESSAGE_LIST_SUC
                      target:self
                    selector:@selector(messageListUpdateHandler:)];
    
}

#pragma mark 举报聊天信息
- (void)showReportView
{
    InfoReportReasonVC *controller = [[InfoReportReasonVC alloc] initWithUserInfo:_userInfo];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    controller.delegate = (id)_superViewController;
    MeYouAppDelegate* appDelegate = (MeYouAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate presentModalViewController:navController animated:YES];
    
}

#pragma mark 语音消息
-(void)playSoundWithMessage:(MessageInfo*)messageInfo
{
    if ([[messageInfo attachment] length] == 0)
    {
        return;
    }
    if ([messageInfo isPlaySound] || [messageInfo isDownloadSound])
    {
        [[YJAudioPlayManager sharedInstance] stop];
        _curPlayMessageInfo = nil;
    }
    else
    {
        if (_curPlayMessageInfo != nil)
        {
            [[YJAudioPlayManager sharedInstance] stop];
        }
        
        _curPlayMessageInfo = messageInfo;
        
        [[YJAudioPlayManager sharedInstance] playChatAudio:messageInfo.attachment];
    }
}

#pragma mark 图片消息
- (void)pictureMessageCell:(YJMessageCell *)pictureMessageCell
              touchPicture:(MessageInfo *)messageInfo
{
    if ([messageInfo.attachment isKindOfClass:[NSString class]]
        && ![messageInfo.attachment isEqualToString:@""])
    {
        ZGP2PPictureMessageCell* cell = (ZGP2PPictureMessageCell*)pictureMessageCell;
        [_arrImages removeAllObjects];
        [_imageArray removeAllObjects];
        NSInteger index = 0;
        for (MessageInfo *msgInfo in _messageArray)
        {
            if(msgInfo.type == MessageTypePicture && msgInfo.attachment != nil)
            {
                [_arrImages addObject:msgInfo.attachment];
            }
        }
        for (NSInteger i = 0; i < _arrImages.count; i++)
        {
            NSString *imageUrl = _arrImages[i];
            if ([messageInfo.attachment isEqualToString:imageUrl])
            {
                index = i;
                break;
            }
        }
        for (int i = 0; i < _arrImages.count; i++)
        {
            YJHDPhotoBean *bean = [[YJHDPhotoBean alloc] initWithThumbImg:nil
                                                            hdImageURLStr:_arrImages[i]
                                                          srcRectInScreen:[U6Common getViewRectInWindow:[cell getAttachmentImageView]]];
            
            [_imageArray addObject:bean];
        }
        YJHDPhotoBean *bean = [_imageArray objectAtIndex:index];
        bean.srcRectInScreen = [U6Common getViewRectInWindow:self];
        
        YJHDPhotoWindow *hdPhotoWindow = [[YJHDPhotoWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [hdPhotoWindow setHDImageBeanArr:_imageArray showAtIndex:index];
        [hdPhotoWindow setDotHidden:YES];
        [hdPhotoWindow show];
    }
}

#pragma mark 视频消息
- (void)videoMessageCell:(YJMessageCell *)videoMessageCell
              touchVideo:(MessageInfo *)messageInfo
{
    if ([messageInfo.attachment isKindOfClass:[NSString class]]
        && ![messageInfo.attachment isEqualToString:@""])
    {
        YJVideoPlayerVC *vc = [[YJVideoPlayerVC alloc] initWithVideoPath:messageInfo.attachment];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
        MeYouAppDelegate* appDelegate = (MeYouAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate presentModalViewController:navController animated:YES];
    }
}

#pragma mark 位置消息
- (void)locationMessageCell:(YJMessageCell *)locationMessageCell
         touchLocationImage:(MessageInfo *)messageInfo
{
    NSArray *location = [messageInfo.attachment componentsSeparatedByString:@","];
    if ([location count] < 2)
    {
        return;
    }
    
    CLLocationCoordinate2D coord = [U6Common makeLocationCoordinate2DByLatitude:[[location objectAtIndex:0] doubleValue]/1000000
                                                                      longitude:[[location objectAtIndex:1] doubleValue]/1000000];
    U6MapViewController *mapController = [[U6MapViewController alloc] initWithCoordinate:coord];
    [mapController showUserLocation:YES];
    [_superViewController.navigationController pushViewController:mapController animated:YES];
}

- (void)didSharedMessageClick:(MessageInfo *)info
{
 
    NSString* url = info.snsShareInfo.linkStr;
    if ([url hasPrefix:@"http://"] ||[url hasPrefix:@"https://"])
    {
        U6WebViewController *controller=[[U6WebViewController alloc] initWithUrl:url];
        controller.bIsActivity = NO;
        [_superViewController.navigationController pushViewController:controller animated:YES];
        
    }
}

#pragma mark - YJAudioPlayManager Notification

- (void)handleAudioPlayManagerMsg:(NSNotification *)notifi
{
    NSString *urlStr = [[notifi userInfo] stringForKey:kNotifChatAudioPlayURL];
    if (![urlStr isEqualToString:_curPlayMessageInfo.attachment])
        return;
    
    NSNumber *stateNum = [[notifi userInfo] numberForKey:kNotifChatAudioPlayState];
    switch (stateNum.integerValue)
    {
        case ChatAudioPlayStateLoading:
        {
            [self audioLoading];
            break;
        }
        case ChatAudioPlayStateLoadError:
        {
            [self audioStoped];
            
            NSString *noteStr = NSLocalizedString(@"MESSAGE_NET_ERROR", @" 您的网络好像有点问题哦，\n请检查一下再来试试吧~");
            [self presentFailureTips:noteStr];
            break;
        }
        case ChatAudioPlayStateLoadCanceled:
        case ChatAudioPlayStatePlayFinished:
        case ChatAudioPlayStateBeginInterruption:
        {
            [self audioStoped];
            break;
        }
        case ChatAudioPlayStatePlaying:
        {
            [self audioPlay];
            break;
        }
        case ChatAudioPlayStatePlayError:
        {
            [self audioStoped];
            
            NSString *noteStr = NSLocalizedString(@"AUDIO_PLAY_ERROR", @"播放出错");
            [self presentFailureTips:noteStr];
            break;
        }
        default:
            break;
    }
}


-(void)audioLoading
{
    if (_curPlayMessageInfo == nil)
    {
        return;
    }
    _curPlayMessageInfo.isDownloadSound = YES;
    NSInteger index = [_messageArray indexOfObject:_curPlayMessageInfo];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    UITableViewCell* cell = [_contentListView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ZGP2PAudioMessageCell class]])
    {
        [(ZGP2PAudioMessageCell *)cell setLoadingStart];
    }
}

- (void)audioPlay
{
    if (_curPlayMessageInfo == nil)
        return;
    
    _curPlayMessageInfo.isPlaySound = YES;
    _curPlayMessageInfo.isDownloadSound = NO;
    
    NSInteger index = [_messageArray indexOfObject:_curPlayMessageInfo];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell* cell = [_contentListView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ZGP2PAudioMessageCell class]])
    {
        [(ZGP2PAudioMessageCell*)cell setLoadingOver];
        [[(ZGP2PAudioMessageCell*)cell soundPlayer] showAnimationView];
    }
}

-(void)audioStoped
{
    if (_curPlayMessageInfo == nil)
        return;
    
    _curPlayMessageInfo.isPlaySound = NO;
    _curPlayMessageInfo.isDownloadSound = NO;
    NSInteger index = [_messageArray indexOfObject:_curPlayMessageInfo];
    
    _curPlayMessageInfo = nil;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    UITableViewCell* cell = [_contentListView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ZGP2PAudioMessageCell class]])
    {
        [(ZGP2PAudioMessageCell*)cell setLoadingOver];
        [[(ZGP2PAudioMessageCell*)cell soundPlayer] hideAnimationView];
    }
}

#pragma mark - UserMessageProxy Notification
- (void)messageListUpdateHandler:(NSNotification *)notif
{
    UserInfo *postUserInfo = [[notif userInfo] objectForKey:KEY_USER_INFO];
    if (postUserInfo.userId == _userInfo.userId)
    {
        [_facade removeNotification:self];
        
        [_messageArray removeAllObjects];
        NSArray *msgList = [[notif userInfo] objectForKey:KEY_MESSAGE_LIST];
        [_messageArray addObjectsFromArray:msgList];
        
        if ([_messageArray count] > 0)
        {
            //更新认识的途径
            MessageInfo *messageInfo = [_messageArray firstObject];
            if (messageInfo)
            {
                UserInfo *userInfo = messageInfo.user;
                [self dealUserFindYouWay:userInfo];
            }
        }
        _contentListView.userInfo = _userInfo;
        _contentListView.messageArray = _messageArray;
    }
}

@end
