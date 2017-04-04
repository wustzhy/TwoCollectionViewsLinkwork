//
//  UILabel+ZYCustom.h
//  7nujoom
//
//  Created by 赵洋 on 2017/3/7.
//  Copyright © 2017年 Fission. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZYCustom)

// 直播间·聊天 name：message
-(void)zy_setAttributeString:(NSAttributedString *)Astr fontSize:(CGFloat)num maxSize:(CGSize)size PositionXY:(CGPoint)point backColor:(UIColor *)rgbaColor type:(BOOL)leftOrRight;


// 
+(UILabel *)NewLabelWithBackColor:(UIColor *)bcolor
                             text:(NSString *)text
                           fontSz:(CGFloat)num
                         fontName:(NSString *)fname
                        textColor:(UIColor *)tcolor;



+(UILabel *)NewLabelWithBackColor:(UIColor *)bcolor
                             text:(NSString *)text
                           fontSz:(CGFloat)num
                         fontName:(NSString *)fname
                        textColor:(UIColor *)tcolor
                          maxSize:(CGSize)maxSZ;


@end
