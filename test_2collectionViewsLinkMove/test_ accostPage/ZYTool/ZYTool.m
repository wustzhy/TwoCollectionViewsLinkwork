//
//  ZYTool.m
//  7nujoom
//
//  Created by 赵洋 on 2017/3/6.
//  Copyright © 2017年 Fission. All rights reserved.
//

#import "ZYTool.h"

#import "UILabel+ZYCustom.h"

static const CGFloat chatFontSize = (13);
@interface ZYTool()

@property(nonatomic,assign)CGFloat chatFontSize;

@end

@implementation ZYTool


#pragma mark - 直播间·聊天


// 给聊天cell的label赋值、frame
+ (void) zy_setChatName:(NSString *)userName message:(NSString *)mesg forLabel:(UILabel *)chatLable{
    
    NSAttributedString * Mstring = [ZYTool zy_MtStringWithUserName:userName message:mesg];
    
    [chatLable zy_setAttributeString:Mstring fontSize:GTFixWidthFlaot(chatFontSize) maxSize:CGSizeMake(GTFixWidthFlaot(281), MAXFLOAT) PositionXY:CGPointMake(GTFixWidthFlaot(10), 0) backColor:HexRGBAlpha(0x868686, 0.5) type:YES];
    //_messageLabel.attributedText = string_name;

}

// 返回size给chat tableview
+ (CGSize) zy_returnLabelSizeWithChatUserName:(NSString *)userName message:(NSString *)mesg{
    
    NSAttributedString * Mstring = [ZYTool zy_MtStringWithUserName:userName message:mesg];
    
    return [ZYTool zy_returnLabelSizeWithString:Mstring.string fontSize:GTFixWidthFlaot(chatFontSize) maxSize:CGSizeMake(GTFixWidthFlaot(281), GTFixHeightFlaot(36))];
    
}

//  聊天 name+message拼接
+ (NSAttributedString *) zy_MtStringWithUserName:(NSString *)userName message:(NSString *)mesg{
    if(userName == nil){
        userName = @"无名：";
    }
    if(mesg == nil){
        mesg = @"";
    }
    
    NSString * name_colon  = [NSString stringWithFormat:@"%@：",userName];
    NSMutableAttributedString * string_name = [[NSMutableAttributedString alloc]initWithString:name_colon];
    [string_name addAttribute:NSForegroundColorAttributeName value:HexRGB(0xFFC968) range:NSMakeRange(0,string_name.length)];
    [string_name addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:GTFixWidthFlaot(chatFontSize)] range:NSMakeRange(0,string_name.length)];
    
    NSMutableAttributedString *string_msg = [[NSMutableAttributedString alloc] initWithString:mesg];
    [string_msg addAttribute:NSForegroundColorAttributeName value:HexRGB(0xFFFFFF) range:NSMakeRange(0,string_msg.length)];
    [string_msg addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:GTFixWidthFlaot(chatFontSize)] range:NSMakeRange(0,string_msg.length)];
    
    [string_name appendAttributedString:string_msg];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [paragraphStyle setHeadIndent:GTFixWidthFlaot(8)];   //非首行 缩进
    [paragraphStyle setFirstLineHeadIndent:GTFixWidthFlaot(8)]; //首行 缩进
    
    [string_name addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string_name.length)];

    return string_name;

}

# pragma mark - 直播间header info
+ (void) zy_setMeiliValue:(long)value forButton:(UIButton *)btn{
    
    [self zy_setBtn:btn FrontString:@"魅力值：" frontColor:HexRGB(0xFFCB37) latterString: [NSString stringWithFormat:@"%ld",value] position:CGPointMake(GTFixWidthFlaot(10),GTFixWidthFlaot(61-20)) type:YES];
}

+ (void) zy_setMeetIDValue:(long)value forButton:(UIButton *)btn{
    
    [self zy_setBtn:btn FrontString:@"遇见ID：" frontColor:HexRGB(0xFFFFFF) latterString: [NSString stringWithFormat:@"%ld",value ] position:CGPointMake(GTFixWidthFlaot(10),  GTFixHeightFlaot(61-20)) type:NO];
}

+ (void) zy_setBtn:(UIButton *)btn FrontString:(NSString *)fString frontColor:(UIColor *)fColor latterString:(NSString *)lString position:(CGPoint)position type:(BOOL)leftOrRight{
    
    NSMutableAttributedString * maString = [[NSMutableAttributedString alloc]initWithString:fString attributes:[NSDictionary dictionaryWithObjectsAndKeys:fColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:GTFixWidthFlaot(11)],NSFontAttributeName, nil]];
    NSAttributedString * aStr = [[NSAttributedString alloc]initWithString:lString attributes:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0xFFFFFF),NSForegroundColorAttributeName,[UIFont systemFontOfSize:GTFixWidthFlaot(11)],NSFontAttributeName, nil]];
    [maString appendAttributedString:aStr];
    [btn zy_setAttributeString:maString fontSize:GTFixWidthFlaot(11) maxSize:CGSizeMake(GTFixWidthFlaot(100), GTFixHeightFlaot(11)) PositionXY:position backColor:HexRGBAlpha(0x868686, 0.5) type:leftOrRight];
    //
    
}


#pragma mark - common methods
//返回文字size
+ (CGSize)returnSizeWithString:(NSString *)str font:(UIFont *)font size:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [str boundingRectWithSize:size
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    return retSize;
}

//返回label size（含文字、边框间距）
+ (CGSize)zy_returnLabelSizeWithString:(NSString *)str fontSize:(CGFloat)num maxSize:(CGSize)size{
    
    //字边距设置
    CGFloat leadingTrailing = GTFixWidthFlaot(10);//头、尾 缩进
    CGFloat upDown = GTFixWidthFlaot(4); //上下间距
    
    CGSize sizeMax_str = CGSizeMake(size.width -2*leadingTrailing, size.height);
    CGSize strSize = [ZYTool returnSizeWithString:str font:[UIFont systemFontOfSize:num] size:sizeMax_str];
    
    CGFloat ww = strSize.width + leadingTrailing*2;
    CGFloat hh = strSize.height + upDown*2;
    
    return CGSizeMake(ww, hh);
    
}


@end
