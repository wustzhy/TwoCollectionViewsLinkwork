//
//  ZYTool.h
//  7nujoom
//
//  Created by 赵洋 on 2017/3/6.
//  Copyright © 2017年 Fission. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIButton+ZYCustom.h"
#import "GTCommont.h"


@interface ZYTool : NSObject
// 魅力值 显示
+ (void) zy_setMeiliValue:(long)value forButton:(UIButton *)btn;

// 遇见ID
+ (void) zy_setMeetIDValue:(long)value forButton:(UIButton *)btn;

// 直播聊天 · 设置label自适应内容 -> cell label
+ (void) zy_setChatName:(NSString *)userName message:(NSString *)mesg forLabel:(UILabel *)chatLable;

+ (NSAttributedString *) zy_MtStringWithUserName:(NSString *)userName message:(NSString *)mesg;

// 直播聊天 · 返回size -> table
+ (CGSize) zy_returnLabelSizeWithChatUserName:(NSString *)userName message:(NSString *)mesg;


// 字符串宽度
+ (CGSize)returnSizeWithString:(NSString *)str font:(UIFont *)font size:(CGSize)size;

// 返回label size（文字、边框间距）
+ (CGSize)zy_returnLabelSizeWithString:(NSString *)str fontSize:(CGFloat)num maxSize:(CGSize)size;

@end
