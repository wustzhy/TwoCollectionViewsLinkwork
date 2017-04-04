/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYAccostInfoCollection.hh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/30.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import <UIKit/UIKit.h>

@protocol ZYAccostInfoCollection_ScrollDelegate <NSObject>

@optional
/*
 *  告诉别人 我移动了多少
 */
-(void)infoCellScroll_scale:(CGFloat)off_scale;
/*
 *  告诉别人 联动中 我(A)是主动?(B是被动)
 */
-(void)infoIsActive:(BOOL)infoActive;
/*
 *  告诉别人 我彻底停下来了    ----> add: 我是手动滑动的开始者,走end方法!
 */
-(void)infoCellScroll_stop:(BOOL)stopOrNot;

@end

@interface ZYAccostInfoCollection : UIView


@property (nonatomic, strong) NSMutableArray * infosArray;

@property (nonatomic, weak) id<ZYAccostInfoCollection_ScrollDelegate> scroll_delegate;
/*
 *  别人告诉我 联动中 别人(A)是主动?(我(B)是被动)
 */
@property (nonatomic, assign) BOOL imageIsActive;

-(void)scrollWithOffScale:(CGFloat)offScale;
-(void)imageScrollEnd:(BOOL)stopOrNot;//

@end
