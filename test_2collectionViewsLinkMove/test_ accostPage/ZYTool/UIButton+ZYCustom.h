//
//  UIButton+ZYCustom.h
//  7nujoom
//
//  Created by 赵洋 on 2017/3/6.
//  Copyright © 2017年 Fission. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZYCustom)



+(UIButton *)NewButtonWithBackColor:(UIColor *)bcolor
                               text:(NSString *)text
                             fontSz:(CGFloat)num
                          textColor:(UIColor *)tcolor;



+(UIButton *)NewButtonWithBackColor:(UIColor *)bcolor
                               text:(NSString *)text
                             fontSz:(CGFloat)num
                          textColor:(UIColor *)tcolor
                             target:(id)target
                             action:(SEL)selector;

//  魅力值 、 遇见ID
-(void)zy_setAttributeString:(NSAttributedString *)Astr fontSize:(CGFloat)num maxSize:(CGSize)size PositionXY:(CGPoint)point backColor:(UIColor *)rgbaColor type:(BOOL)leftOrRight;




@end
