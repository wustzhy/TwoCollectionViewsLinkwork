//
//  AccostSendView.m
//  iAround
//
//  Created by 123456 on 8/13/14.
//
//

#import "AccostSendView.h"
#import "YJTableView.h"
#import "EGORefreshTableHeaderView.h"
#import "U6AppFacade+Proxy.h"
#import "FriendProxy.h"
#import "U6LoadingMoreInfoCell.h"
#import "MeetManViewCell.h"

@interface AccostSendView () <UITableViewDataSource, UITableViewDelegate, ZGImageViewDelegate>

{
    YJTableView *_listTableView;
    NSMutableArray *_listArray;
    U6AppFacade *_facade;
}

@end

@implementation AccostSendView

@synthesize delegate = _delegate;

- (void)dealloc
{
    _delegate = nil;
    
    [_facade removeNotification:self];
    
    [_listArray release];
    _listArray = nil;
    
    [_listTableView release];
    _listTableView = nil;
    
    [super dealloc];
}


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier frame:frame]) {
        
        _listArray = [[NSMutableArray alloc] init];
        
        _listTableView = [[YJTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.width, self.height)
                                                      style:UITableViewStylePlain];
        _listTableView.rowHeight = 74.0f;
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //获取手势//ios7以前版本 防止和框架手势冲突
        if (!IOS7_OR_LATER)
        {
            Class otherCls = NSClassFromString(@"UISwipeGestureRecognizer");
            UIGestureRecognizer * gestureRecognizer = nil;
            for (int i = 0; i < [_listTableView.gestureRecognizers count]; i++)
            {
                gestureRecognizer = [_listTableView.gestureRecognizers objectAtIndex:i];
                if ([gestureRecognizer isKindOfClass:otherCls])
                {
                    ((UISwipeGestureRecognizer*)gestureRecognizer).direction = UISwipeGestureRecognizerDirectionLeft;
                    break;
                }
            }
        }
        [self addSubview:_listTableView];
        
        _facade = [U6AppFacade getInstance];
        [_facade addNotification:NOTIF_COMMON_UPDATE_SEND_GREETING
                          target:self
                        selector:@selector(updateAccostSendHandler:)];

        [[_facade getFriendProxy] getAllSendGreetingToUsers];
    }
    return self;
}

#pragma mark - private


- (void)reloadAccostSendList
{
    [_listArray removeAllObjects];
    
    for (ContactInfo *contactInfo in [_facade getFriendProxy].sendGreetingToArray)
    {
        [_listArray addObject:contactInfo];
    }
    
    [self updateLinkmanListView];
    
}

- (void)updateLinkmanListView
{
    [_listTableView reloadData];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellId = NSStringFromClass([MeetManViewCell class]);;
    
    MeetManViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[MeetManViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userAvatar.delegate = self;
        [cell showCustomSeperator:YES];
    }
    
    ContactInfo *contactInfo = [_listArray objectAtIndex:indexPath.row];
    [cell updateViewWithContactInfo:contactInfo];
    
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [_listArray count])
    {
        ContactInfo *contactInfo = [_listArray objectAtIndex:indexPath.row];
        if ([_delegate conformsToProtocol:@protocol(AccostSendViewDelegate)] &&
            [_delegate respondsToSelector:@selector(accostSendView:chatWithUser:)])
        {
            contactInfo.iUnreadMsgCount = 0;
            contactInfo.userInfo.fDistance *= 1000;
            [_delegate accostSendView:self chatWithUser:contactInfo.userInfo];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL result = NO;
    if (indexPath.row < _listArray.count)
    {
        result = YES;
    }
    
    return result;
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    YJTableViewCell * cell = (YJTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell chatViewCellWillEditing];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    YJTableViewCell * cell = (YJTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell chatViewCellWillEndEditing];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.row < [_listArray count])
	{
        ContactInfo *contactInfo = [_listArray objectAtIndex:indexPath.row];
        [_listArray removeObjectAtIndex:indexPath.row];
        
		//删除联系人信息
        [_listTableView beginUpdates];
		[_listTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
		[_listTableView endUpdates];
        
        //删除本地消息记录
        UserMessageProxy *messageProxy = [[_facade getUserMessageProxyWithUser:contactInfo.userInfo] retain];
        [messageProxy addRef];
        [messageProxy cleanMessageHistory];
        [messageProxy releaseRef];
        [messageProxy release];
        
        [[_facade getFriendProxy] removeLinkman:contactInfo.userInfo];
        [[_facade getDatabase] updateLinkmanOfSendAndReceiveInfo];
        
        // 无数据返回上一页
        if (_listArray.count <= 0)
        {
            if ([_delegate conformsToProtocol:@protocol(AccostSendViewDelegate)] &&
                [_delegate respondsToSelector:@selector(accostSendViewisEmpty:)])
            {
                [_delegate accostSendViewisEmpty:self];
            }
        }
	}
}

#pragma mark - U6UserAvatarDelegate
- (void)onClick:(ZGImageView *)sender
{
    if (!_listTableView.editing)
    {
        if ([_delegate conformsToProtocol:@protocol(AccostSendViewDelegate)] &&
            [_delegate respondsToSelector:@selector(accostSendView:showUserInfo:)])
        {
            [_delegate accostSendView:self showUserInfo:((ZGAvatarView*)sender).userInfo];
        }
    }
}

#pragma mark - friendProxy Notification
- (void)updateAccostSendHandler:(NSNotification *)notif
{
    [self reloadAccostSendList];
}

@end
