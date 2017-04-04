//
//  UIButton+ZYCustom.m
//  7nujoom
//
//  Created by 赵洋 on 2017/3/6.
//  Copyright © 2017年 Fission. All rights reserved.
//

#import "UIButton+ZYCustom.h"
#import "ZYTool.h"

@implementation UIButton (ZYCustom)
+(UIButton *)NewButtonWithBackColor:(UIColor *)bcolor
                               text:(NSString *)text
                             fontSz:(CGFloat)num
                          textColor:(UIColor *)tcolor
{
    
    UIButton * btn = [[UIButton alloc]init];
    btn.backgroundColor = bcolor;
    [btn setTitle:text forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:num];
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    [btn sizeToFit];
    
    return btn;
}

+(UIButton *)NewButtonWithBackColor:(UIColor *)bcolor
                               text:(NSString *)text
                             fontSz:(CGFloat)num
                          textColor:(UIColor *)tcolor
                             target:(id)target
                             action:(SEL)selector
{
    UIButton * btn = [UIButton NewButtonWithBackColor:bcolor text:text fontSz:num textColor:tcolor];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    return btn;
}


-(void)zy_setAttributeString:(NSAttributedString *)Astr fontSize:(CGFloat)num maxSize:(CGSize)size PositionXY:(CGPoint)point backColor:(UIColor *)rgbaColor type:(BOOL)leftOrRight{

    CGSize strSize = [ZYTool returnSizeWithString:Astr.string font:[UIFont systemFontOfSize:num] size:size];
    //字边距设置
    CGFloat leadingTrailing = strSize.height/2;//头、尾 缩进
    CGFloat upDown = GTFixHeightFlaot(4); //上下间距
    //[self setTitleEdgeInsets:UIEdgeInsetsMake(leadingTrailing, 0, 0, 0)];
    CGFloat xx = point.x;
    CGFloat ww = strSize.width + leadingTrailing*2;
    if(!leftOrRight){
        xx = ScreenF.size.width - point.x - ww;
    }
    self.frame = CGRectMake( xx, point.y, ww , strSize.height+upDown*2);
    
//    self.frame = CGRectMake(frame.origin.x, frame.origin.y, 20+ageSize.width, ageSize.height);
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2;
    
    [self setAttributedTitle:Astr forState:UIControlStateNormal];
    [self setBackgroundColor:rgbaColor];
}




@end
