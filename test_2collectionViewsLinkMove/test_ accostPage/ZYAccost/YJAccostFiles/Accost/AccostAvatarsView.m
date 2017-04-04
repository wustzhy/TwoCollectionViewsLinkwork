//
//  AccostAvatarsView.m
//  iAround
//
//  Created by 123456 on 8/1/14.
//
//

#import "AccostAvatarsView.h"
#import "ZGAvatarView.h"
#import "AccostReceiveView.h"

#if !__has_feature(objc_arc)
#error no "objc_arc" compiler flag
#endif

#define AVATAR_SIZE     YJ_AUTOSIZE_X(65)
#define AVATAR_OFFSET   YJ_AUTOSIZE_X(5)
#define AVATAR_VIEW_TAG 998877

@interface AccostAvatarsView () <UITableViewDataSource, UITableViewDelegate>

{
    // 底层scrollview
    UITableView *_avatarScrollView;
    // 头像数据数组
    NSMutableArray *_userArray;
    BOOL _bBeginTransition;
}

@end

@implementation AccostAvatarsView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _avatarScrollView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.height, self.width)
                                                      style:UITableViewStylePlain];
        _avatarScrollView.center = CGPointMake(self.center.x, self.top + self.height / 2);
        _avatarScrollView.backgroundColor = RGBCOLOR(0xe3, 0xe3, 0xe3);
        _avatarScrollView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _avatarScrollView.showsVerticalScrollIndicator = NO;
        _avatarScrollView.showsHorizontalScrollIndicator = NO;
        _avatarScrollView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        _avatarScrollView.delegate = self;
        _avatarScrollView.dataSource = self;
        _avatarScrollView.contentInset = UIEdgeInsetsMake(YJ_AUTOSIZE_X(122.0f), 0, YJ_AUTOSIZE_X(122.0f), 0);
        _avatarScrollView.rowHeight = AVATAR_SIZE + AVATAR_OFFSET * 2;
        _avatarScrollView.scrollEnabled = NO;
        [self addSubview:_avatarScrollView];
        
    }
    return self;
}

#pragma mark - Public

- (void)setUsers:(NSMutableArray *)users
{
    _userArray = users;
    
    [_avatarScrollView reloadData];
    
}

- (void)reloadData
{
    [_avatarScrollView reloadData];
}


- (void)makeScrollToIndex:(NSInteger)index withOffset:(CGFloat)offset
{
    CGFloat transitionOffset = offset * _avatarScrollView.rowHeight;
    [_avatarScrollView setContentOffset:CGPointMake(0, (index * _avatarScrollView.rowHeight + transitionOffset - YJ_AUTOSIZE_X(122.0f)))];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"avatarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBCOLOR(0xe3, 0xe3, 0xe3);
        
        CGFloat width = AVATAR_SIZE;
        CGFloat height = AVATAR_SIZE;
        CGFloat x = 1.5;
        CGFloat y = AVATAR_OFFSET;
        
        ZGAvatarView *avatarView = [[ZGAvatarView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        avatarView.transform = CGAffineTransformMakeRotation(M_PI/2);
        avatarView.tag = AVATAR_VIEW_TAG;
        avatarView.userInteractionEnabled = NO;
        [cell.contentView addSubview:avatarView];
        
    }

    ZGAvatarView *avatarView = (ZGAvatarView *)[cell.contentView viewWithTag:AVATAR_VIEW_TAG];
    // 防止复用的时候头像闪动
    [avatarView setUserInfo:nil];
    if (_userArray.count>0)
    {
        ContactInfo *contactInfo = _userArray[indexPath.row];
        UserInfo *userInfo = contactInfo.userInfo;
        [avatarView setUserInfo:userInfo];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(accostAvatarsView:seleteAvatarAtIndex:)]) {
        [_delegate accostAvatarsView:self seleteAvatarAtIndex:indexPath.row];
        ContactInfo *contactInfo = _userArray[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNoti_ShowSanJiao object:contactInfo];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f", scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > -3.0f) {
//        if (_avatarScrollView.rowHeight > AVATAR_SIZE + AVATAR_OFFSET * 2) {
//            _avatarScrollView.rowHeight -= 0.8f;
//            [_avatarScrollView reloadData];
//        }
//        
//    } else {
//        if (_avatarScrollView.rowHeight < AVATAR_SIZE + 27 * 2) {
//            _avatarScrollView.rowHeight += 0.8f;
//            [_avatarScrollView reloadData];
//        }
//        
//    }
    
    
    if (_bIsPrincipal) {
        // 因为contentInset的影响
        CGFloat transitionOffset = scrollView.contentOffset.y + 122.0f;
        
        NSInteger quotient = transitionOffset / _avatarScrollView.rowHeight;
        CGFloat remainder = transitionOffset - quotient * _avatarScrollView.rowHeight;
        CGFloat percent = remainder / _avatarScrollView.rowHeight;
        if (_delegate && [_delegate respondsToSelector:@selector(accostAvatarsView:didScrollToIndex:withOffset:)]) {
            [_delegate accostAvatarsView:self didScrollToIndex:quotient withOffset:percent];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _bIsPrincipal = YES;
//    if (_delegate && [_delegate respondsToSelector:@selector(accostAvatarsViewWillBeginDragging:)]) {
//        [_delegate accostAvatarsViewWillBeginDragging:self];
//    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kNoti_HideSanJiao object:nil];
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
    NSArray *visibleCellsArray = [_avatarScrollView visibleCells];
    for (UITableViewCell *cell in visibleCellsArray) {
        CGPoint point = [_avatarScrollView convertPoint:cell.center toView:self];
        CGFloat offset = point.x - self.width / 2;
        if (fabsf(offset) < _avatarScrollView.rowHeight / 2) {
            offset += _avatarScrollView.contentOffset.y;
            [_avatarScrollView setContentOffset:CGPointMake(0, offset) animated:YES];
            if (_delegate && [_delegate respondsToSelector:@selector(accostAvatarsView:didEndScrollAtIndex:)]) {
                NSIndexPath *indexPath = [_avatarScrollView indexPathForCell:cell];
                [_delegate accostAvatarsView:self didEndScrollAtIndex:indexPath.row];
                
                ContactInfo *contactInfo = _userArray[indexPath.row];
                [[NSNotificationCenter defaultCenter]postNotificationName:kNoti_ShowSanJiao object:contactInfo];
            }
            break;
        }
    }
    
    
}
@end
