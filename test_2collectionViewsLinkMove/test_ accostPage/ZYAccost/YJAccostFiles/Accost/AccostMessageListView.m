//
//  AccostMessageListView.m
//  iAround
//
//  Created by dingjun on 14-8-29.
//
//

#import "AccostMessageListView.h"
#import "YJMessageCell.h"
#import "ZGP2PFollowMessageCell.h"

#define TEXT_CELL_ID @"text"
#define IMAGE_CELL_ID @"image"
#define AUDIO_CELL_ID @"audio"
#define VIDEO_CELL_ID @"video"
#define LOCATION_CELL_ID @"location"
#define GIFT_CELL_ID @"gift"
#define MAP_INFO_CELL_ID @"map_info"
#define RESPONS_ID   @"responsAdventure"
#define SHARED_ID  @"SHARED_ID"
#if !__has_feature(objc_arc)
#error no "objc_arc" compiler flag
#endif

@implementation AccostMessageListView

@synthesize messageArray = _messageArray;
@synthesize delegate = _delegate;
@synthesize contentSize;
@synthesize contentOffset;
@synthesize tableHeaderView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _calculationCellDict = [[NSMutableDictionary alloc] init];
        
        _tableView = [[U6TouchTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.width, self.height)
                                                       style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.touchDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
    }
    
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    _calculationCellDict = nil;
    _messageArray = nil;
    _userInfo = nil;
    
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
}

- (void)setTableHeaderView:(UIView *)aTableHeaderView
{
    _tableView.tableHeaderView = aTableHeaderView;
}

- (UIView *)tableHeaderView
{
    return _tableView.tableHeaderView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _tableView.frame = CGRectMake(0.0, 0.0, self.width, self.height);
}

- (void)setMessageArray:(NSArray *)messageArray
{
    _messageArray = messageArray;
    
    _dLastTime = 0;
    [_tableView reloadData];
}

- (void)setTextMessageItemType:(Class)textMessageItemType
{
    _textMessageItemType = textMessageItemType;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:TEXT_CELL_ID];
    [_calculationCellDict setObject:[[_textMessageItemType alloc] initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:TEXT_CELL_ID]
                             forKey:TEXT_CELL_ID];
    
    [_tableView reloadData];
}

- (void)setImageMessageItemType:(Class)imageMessageItemType
{
    _imageMessageItemType = imageMessageItemType;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:IMAGE_CELL_ID];
    [_calculationCellDict setObject:[[_imageMessageItemType alloc] initWithStyle:UITableViewCellStyleDefault
                                                                 reuseIdentifier:IMAGE_CELL_ID]
                             forKey:IMAGE_CELL_ID];
    
    [_tableView reloadData];
}

- (void)setAudioMessageItemType:(Class)audioMessageItemType
{
    _audioMessageItemType = audioMessageItemType;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:AUDIO_CELL_ID];
    [_calculationCellDict setObject:[[_audioMessageItemType alloc] initWithStyle:UITableViewCellStyleDefault
                                                                 reuseIdentifier:AUDIO_CELL_ID]
                             forKey:AUDIO_CELL_ID];
    
    [_tableView reloadData];
}

- (void)setVideoMessageItemType:(Class)videoMessageItemType
{
    _videoMessageItemType = videoMessageItemType;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:VIDEO_CELL_ID];
    [_calculationCellDict setObject:[[_videoMessageItemType alloc] initWithStyle:UITableViewCellStyleDefault
                                                                 reuseIdentifier:VIDEO_CELL_ID]
                             forKey:VIDEO_CELL_ID];
    
    [_tableView reloadData];
}

- (void)setLocationMessageItemType:(Class)locationMessageItemType
{
    _locationMessageItemType = locationMessageItemType;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:LOCATION_CELL_ID];
    [_calculationCellDict setObject:[[_locationMessageItemType alloc] initWithStyle:UITableViewCellStyleDefault
                                                                    reuseIdentifier:LOCATION_CELL_ID]
                             forKey:LOCATION_CELL_ID];
    
    [_tableView reloadData];
}

- (void)setGiftMessageItemType:(Class)giftMessageItemType
{
    _giftMessageItemType = giftMessageItemType;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:GIFT_CELL_ID];
    [_calculationCellDict setObject:[[_giftMessageItemType alloc] initWithStyle:UITableViewCellStyleDefault
                                                                reuseIdentifier:GIFT_CELL_ID]
                             forKey:GIFT_CELL_ID];
    
    [_tableView reloadData];
}

- (void)setShareMessageItemType:(Class)shareMessageItemType_
{
    _shareMessageItemType = shareMessageItemType_;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:SHARED_ID];
    [_calculationCellDict setObject:[[_shareMessageItemType alloc] initWithStyle:UITableViewCellStyleDefault
                                                                     reuseIdentifier:SHARED_ID]
                             forKey:SHARED_ID];
    
    [_tableView reloadData];
}


-(void)setMapMessageItemType:(Class)mapMessageItemType
{
    _mapMessageItemType = mapMessageItemType;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:MAP_INFO_CELL_ID];
    [_calculationCellDict setObject:[[_mapMessageItemType alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:MAP_INFO_CELL_ID]
                             forKey:MAP_INFO_CELL_ID];
    
    [_tableView reloadData];
}

- (void)setResponsAdventureItemTyp:(Class)responsAdventureItemTyp
{
    _responsAdventureItemTyp = responsAdventureItemTyp;
    
    //替换计算高度Cell
    [_calculationCellDict removeObjectForKey:RESPONS_ID];
    [_calculationCellDict setObject:[[_responsAdventureItemTyp alloc] initWithStyle:UITableViewCellStyleDefault
                                                                    reuseIdentifier:RESPONS_ID]
                             forKey:RESPONS_ID];
    
    [_tableView reloadData];
}

//- (void)setContentSize:(CGSize)aContentSize
//{
//    _tableView.contentSize = aContentSize;
//}
//
//- (CGSize)contentSize
//{
//    return _tableView.contentSize;
//}
//
//- (void)setContentOffset:(CGPoint)aContentOffset
//{
//    _tableView.contentOffset = aContentOffset;
//}

- (CGPoint)contentOffset
{
    return _tableView.contentOffset;
}

- (void)reloadData
{
    _dLastTime = 0;
    [_tableView reloadData];
}

//- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
//{
//    [_tableView deselectRowAtIndexPath:indexPath animated:animated];
//}
//
//- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath
//                    animated:(BOOL)animated
//              scrollPosition:(UITableViewScrollPosition)scrollPosition
//{
//    [_tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
//}

- (NSIndexPath *)indexPathForSelectedRow
{
    return [_tableView indexPathForSelectedRow];
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell
{
    return [_tableView indexPathForCell:cell];
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Private

- (CGFloat)calculationCellHeight:(MessageInfo *)messageInfo
{
    if (messageInfo)
    {
        YJMessageCell* cell = nil;
        switch (messageInfo.type)
        {
            case MessageTypeText:
                cell = [_calculationCellDict objectForKey:TEXT_CELL_ID];
                break;
            case MessageTypePicture:
                cell = [_calculationCellDict objectForKey:IMAGE_CELL_ID];
                break;
            case MessageTypeSound:
                cell = [_calculationCellDict objectForKey:AUDIO_CELL_ID];
                break;
            case MessageTypeVideo:
                cell = [_calculationCellDict objectForKey:VIDEO_CELL_ID];
                break;
            case MessageTypeLocation:
                cell = [_calculationCellDict objectForKey:LOCATION_CELL_ID];
                break;
            case MessageTypeGift:
                cell = [_calculationCellDict objectForKey:GIFT_CELL_ID];
                break;
            case MessageTypeMap:
                cell = [_calculationCellDict objectForKey:MAP_INFO_CELL_ID];
                break;
            case MessageTypeReponsed:
                cell = [_calculationCellDict objectForKey:RESPONS_ID];
                break;
            case MessageTypeShared:
                cell = [_calculationCellDict objectForKey:SHARED_ID];
                break;
            default:
                cell = [_calculationCellDict objectForKey:TEXT_CELL_ID];
                break;
        }
        
        CGFloat fHeight = [cell calculationCellHeight:messageInfo];
        return fHeight;
    }
    return _tableView.rowHeight;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId;
    Class cellType;
    UITableViewCell *cell;
    
    if ([_messageArray count] > indexPath.row)
    {
        MessageInfo *messageInfo = [_messageArray objectAtIndex:indexPath.row];
        switch (messageInfo.type)
        {
            case MessageTypeText:
                cellType = _textMessageItemType;
                break;
            case MessageTypePicture:
                cellType = _imageMessageItemType;
                break;
            case MessageTypeSound:
                cellType = _audioMessageItemType;
                break;
            case MessageTypeVideo:
                cellType = _videoMessageItemType;
                break;
            case MessageTypeLocation:
                cellType = _locationMessageItemType;
                break;
            case MessageTypeGift:
                cellType = _giftMessageItemType;
                break;
            case MessageTypeMap:
                cellType = _mapMessageItemType;
                break;
            case MessageTypeReponsed:
                cellType = _responsAdventureItemTyp;
                break;
            case MessageTypeShared:
                cellType = _shareMessageItemType;
                break;
            default:
                cellType = _textMessageItemType;
                break;
        }
    }
    else
    {
        cellType = [UITableViewCell class];
    }
    
    cellId = NSStringFromClass(cellType);
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[cellType alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:cellId];
        
        if ([_delegate conformsToProtocol:@protocol(AccostMessageListViewDelegate)] &&
            [_delegate respondsToSelector:@selector(listView:createItemCell:)])
        {
            [_delegate listView:self createItemCell:cell];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_messageArray count])
    {
        MessageInfo *messageInfo = [_messageArray objectAtIndex:indexPath.row];
        
        BOOL bNeedShowTime = NO;
        //FOR IOS8: messageInfo.datetime - _dLastTime == 0 防止只有一条信息时，信息的时间减去最后的时间总是等于0导致时间不显示
        if (messageInfo.datetime - _dLastTime == 0||fabsf((messageInfo.datetime - _dLastTime)) > MSG_DATE_TIME)
        {
            _dLastTime = messageInfo.datetime;
            bNeedShowTime = YES;
        }
        
        BOOL bNeedCalcu = NO;
        if (messageInfo.needShowDatetime != bNeedShowTime)
        {
            messageInfo.needShowDatetime = bNeedShowTime;
            bNeedCalcu = YES;
        }
        
        if(messageInfo.contentHeight == -1|| bNeedCalcu)
        {
            messageInfo.contentHeight = [self calculationCellHeight:messageInfo];
        }
        return messageInfo.contentHeight;
    }
    return _tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_messageArray count])
    {
        MessageInfo *messageInfo = [_messageArray objectAtIndex:indexPath.row];
        [(YJMessageCell*)cell setMessageInfo:messageInfo];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageInfo *messageInfo = [_messageArray objectAtIndex:indexPath.row];
    if (messageInfo.type == MessageTypeShared) {
        if (_delegate && [_delegate respondsToSelector:@selector(didSharedMessageClick:)]) {
            [_delegate didSharedMessageClick:messageInfo];
        }
    }
}



@end
