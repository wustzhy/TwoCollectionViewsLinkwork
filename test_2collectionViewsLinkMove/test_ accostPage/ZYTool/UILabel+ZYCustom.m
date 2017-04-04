//
//  UILabel+ZYCustom.m
//  7nujoom
//
//  Created by 赵洋 on 2017/3/7.
//  Copyright © 2017年 Fission. All rights reserved.
//

#import "UILabel+ZYCustom.h"
#import "ZYTool.h"


@implementation UILabel (ZYCustom)


/**
 *  type =left ，point 为子view左上角 距离 父view左上角 xy值
 *  type =right ，point 为子view右上角 距离 父view右上角 xy值
 */
-(void)zy_setAttributeString:(NSAttributedString *)Astr fontSize:(CGFloat)num maxSize:(CGSize)size PositionXY:(CGPoint)point backColor:(UIColor *)rgbaColor type:(BOOL)leftOrRight{
    
//    //字边距设置
//    CGFloat leadingTrailing = 10;//头、尾 缩进
//    CGFloat upDown = 4; //上下间距
//    
//    CGSize sizeMax_str = CGSizeMake(size.width -2*leadingTrailing, size.height);
//    CGSize strSize = [ZYTool returnSizeWithString:Astr.string font:[UIFont systemFontOfSize:num] size:sizeMax_str];
//    //[self setTitleEdgeInsets:UIEdgeInsetsMake(leadingTrailing, 0, 0, 0)];
//    CGFloat xx = point.x;
//    CGFloat ww = strSize.width + leadingTrailing*2;
    CGSize sizeResult = [ZYTool zy_returnLabelSizeWithString:Astr.string fontSize:num maxSize:size];

    CGFloat xx = point.x;
    if(!leftOrRight){
        xx = ScreenF.size.width - point.x - sizeResult.width;
    }
    self.frame = CGRectMake( xx, point.y, sizeResult.width , sizeResult.height);
    
    // 单行高度
    //NSString *olStr = [Astr.string substringToIndex:1];
    CGFloat oneLineHeight = [ZYTool zy_returnLabelSizeWithString:@"1" fontSize:num maxSize:size].height;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = oneLineHeight/2;
        
    //[self setAttributedText:Astr];
    [self setBackgroundColor:rgbaColor];
    
    NSMutableAttributedString * MAstr = [[NSMutableAttributedString alloc]initWithAttributedString:Astr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //paragraphStyle.maximumLineHeight = 60;  //最大的行高
    //paragraphStyle.lineSpacing = 5;  //行自定义行高度
    [paragraphStyle setHeadIndent:GTFixWidthFlaot(8)];   //非首行 缩进
    [paragraphStyle setFirstLineHeadIndent:GTFixWidthFlaot(8)]; //首行 缩进
    
    [MAstr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, Astr.length)];
    self.attributedText = MAstr;

    
}




+(UILabel *)NewLabelWithBackColor:(UIColor *)bcolor
                               text:(NSString *)text
                             fontSz:(CGFloat)num
                           fontName:(NSString *)fname
                          textColor:(UIColor *)tcolor
{
    
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = bcolor;
    [label setText:text];
    label.font = [UIFont fontWithName:fname size:num];
    label.textColor = tcolor;
    [label sizeToFit];
    
    return label;
}


+(UILabel *)NewLabelWithBackColor:(UIColor *)bcolor
                             text:(NSString *)text
                           fontSz:(CGFloat)num
                         fontName:(NSString *)fname
                        textColor:(UIColor *)tcolor
                         maxSize:(CGSize)maxSZ
{
    
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = bcolor;
    [label setText:text];
    label.font = [UIFont fontWithName:fname size:num];
    label.textColor = tcolor;
    
    NSAttributedString * astr = [[NSAttributedString alloc]initWithString:text];

    [label zy_setAttributeString:astr
                        fontSize:num
                         maxSize:maxSZ
                      PositionXY:CGPointZero
                       backColor:bcolor
                            type:YES
     ];
    
    return label;
}

@end
