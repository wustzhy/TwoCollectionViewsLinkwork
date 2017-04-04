//
//  AccostAvatarsView.h
//  iAround
//
//  Created by 123456 on 8/1/14.
//
//

#import <UIKit/UIKit.h>

@protocol AccostAvatarsViewDelegate;

@interface AccostAvatarsView : UIView

{
    __weak id<AccostAvatarsViewDelegate> _delegate;
}

@property (nonatomic, weak) id<AccostAvatarsViewDelegate> delegate;
@property (nonatomic, assign) BOOL bIsPrincipal;
/**
 *  设置数据源
 *
 *  @param avatars 用户的头像数组
 */
- (void)setUsers:(NSMutableArray *)avatars;

- (void)makeScrollToIndex:(NSInteger)index withOffset:(CGFloat)offset;
/**
 *  刷新
 */
- (void)reloadData;

@end

@protocol AccostAvatarsViewDelegate <NSObject>
/**
 *  点击了第几个头像
 *
 *  @param view  自身
 *  @param index 第几个头像
 */
- (void)accostAvatarsView:(AccostAvatarsView *)view seleteAvatarAtIndex:(NSInteger)index;
- (void)accostAvatarsViewWillBeginDragging:(AccostAvatarsView *)view;
- (void)accostAvatarsView:(AccostAvatarsView *)view didScrollToIndex:(NSInteger)index withOffset:(CGFloat)offset;
- (void)accostAvatarsView:(AccostAvatarsView *)view didEndScrollAtIndex:(NSInteger)index;

@end