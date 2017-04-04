//
//  AccostMessageListView.h
//  iAround
//
//  Created by dingjun on 14-8-29.
//
//


#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "U6TouchTableView.h"

#define MSG_DATE_TIME (3*60*1000)//3分钟

@class AccostMessageListView;

@protocol AccostMessageListViewDelegate <NSObject>
-(void)didSharedMessageClick:(MessageInfo *)info;
@optional

/**
 列表项创建
 @param listView 列表视图
 @param cell 列表项视图
 */
- (void)listView:(AccostMessageListView *)listView
  createItemCell:(UITableViewCell *)cell;

/**
 列表项数据填充
 @param listView 列表视图
 @param cell 列表项视图
 @param messageInfo 消息数据
 */
- (void)listView:(AccostMessageListView *)listView
        itemCell:(UITableViewCell *)cell
     messageItem:(MessageInfo *)messageInfo;

/**
 *	@brief	选中某项
 *
 *	@param 	listView 	列表视图
 *	@param 	cell 	单元格
 *  @param  indexPath   行索引
 *	@param 	messageInfo 	消息对象
 */
- (void)listView:(AccostMessageListView *)listView
   didSelectCell:(UITableViewCell *)cell
       indexPath:(NSIndexPath *)indexPath
     messageItem:(MessageInfo *)messageInfo;

@end


@interface AccostMessageListView : UIView <UITableViewDelegate,UITableViewDataSource,U6TouchTableViewDelegate>
{
@protected
    U6TouchTableView *_tableView;

    NSArray *_messageArray;
    NSMutableDictionary *_calculationCellDict;      //用于保存计算列表项高度的列表项
    CGFloat _fCurrentContentHeight;
    CGFloat _fLastCellHeight;
    
    double          _dLastTime;
}

@property(nonatomic, retain) U6TouchTableView* tableView;
@property (nonatomic,retain) NSArray *messageArray;
@property (nonatomic,retain) UserInfo *userInfo;

/**
 委托对象
 */
@property (nonatomic,assign) id<AccostMessageListViewDelegate> delegate;

/**
 *	@brief	表头视图
 */
@property (nonatomic,retain) UIView *tableHeaderView;

/**
 文本消息项视图类型
 */
@property (nonatomic,assign) Class textMessageItemType;

/**
 图片消息项视图类型
 */
@property (nonatomic,assign) Class imageMessageItemType;

/**
 音频消息项视图类型
 */
@property (nonatomic,assign) Class audioMessageItemType;

/**
 视频消息项视图类型
 */
@property (nonatomic,assign) Class videoMessageItemType;

/**
 位置消息项视图类型
 */
@property (nonatomic,assign) Class locationMessageItemType;

/**
 礼物消息项视图类型
 */
@property (nonatomic,assign) Class giftMessageItemType;

/**
 分享Cell
 */
@property (nonatomic,assign) Class shareMessageItemType;

/**
 贴图视图类型
 */
@property(nonatomic, assign) Class mapMessageItemType;

/**
 *	@brief	真心话答案视图类型
 */
@property (nonatomic, assign)Class responsAdventureItemTyp;

/**
 *	@brief	内容尺寸
 */
@property (nonatomic) CGSize contentSize;

/**
 *	@brief	偏移位置
 */
@property (nonatomic) CGPoint contentOffset;

/**
 *	@brief	重新加载数据
 */
- (void)reloadData;

/**
 *	@brief	获取选中行索引
 *
 *	@return	行索引
 */
- (NSIndexPath *)indexPathForSelectedRow;

/**
 *	@brief	获取行索引
 *
 *	@param 	cell 	列表项
 *
 *	@return	行索引
 */
- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
