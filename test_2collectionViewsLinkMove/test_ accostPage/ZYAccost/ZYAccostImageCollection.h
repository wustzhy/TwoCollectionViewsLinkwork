/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYAccostImageCollection.hh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/30.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import <UIKit/UIKit.h>

@protocol ZYAccostImageScrollDelegate <NSObject>

/*
 *  告诉别人 我移动了多少
 */
-(void)imageCellScroll_scale:(CGFloat)off_scale;
/*
 *  告诉别人 联动中 我(A)是主动?(B是被动)
 */
//-(void)imageIsActive:(BOOL)imageActive;
/*
 *  告诉别人 我彻底停下来了    ----> add: 我是手动滑动的开始者,走end方法!
 */
-(void)imageCellScroll_stop:(BOOL)stopOrNot;
@end

@interface ZYAccostImageCollection : UIView

@property(nonatomic,strong)NSArray * picArray;


@property (nonatomic, weak) id<ZYAccostImageScrollDelegate> delegate;
/*
 *  别人告诉我 联动中 别人(A)是主动?(我(B)是被动)
 */
@property (nonatomic, assign) BOOL infoIsActive;

-(void)scrollWithOFFScale:(CGFloat)offscale;


-(void)infoScrollEnd:(BOOL)stopOrNot;// 

@end
