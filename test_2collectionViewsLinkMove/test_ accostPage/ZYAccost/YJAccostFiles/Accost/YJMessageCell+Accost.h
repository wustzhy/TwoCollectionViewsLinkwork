//
//  YJMessageCell+Accost.h
//  iAround
//
//  Created by 123456 on 8/6/14.
//
//

#import "YJMessageCell.h"

@interface YJMessageCell (Accost)
/**
 *  添加搭讪时间轴的UI样式
 */
- (void)updateViewAjustAccost;
/**
 *  method swizzling 替换搭讪显示时间的UI实现
 */
+ (void)swizzling;
/**
 *  打开搭讪时间轴的形态
 */
+ (void)openAccostType;
/**
 *  关闭搭讪时间轴的形态
 */
+ (void)closeAccostType;

@end
