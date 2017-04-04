//
//  FSDefinedFunctions.h
//  FlyShow
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 Fission. All rights reserved.
//

#ifndef FSDefinedFunctions_h
#define FSDefinedFunctions_h

#define RevertX(SuperW,ViewX,ViewW) !IsArabic?ViewX:(SuperW - ViewX - ViewW)
#define RevertXAToE(SuperW,ViewX,ViewW) IsArabic?ViewX:(SuperW - ViewX - ViewW)

#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
// 切换语言
#define LanguageBundle [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]]
// 颜色
#define Color(red,green,blue) [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
#define IOS7_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

//color
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//首页文件存储
#define FSHomeInfoFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"FSHomeInfo.data"]


#endif /* FSDefinedFunctions_h */

//阿语字体
#define FSFontNameAlJazeeraArabicRegular  @"Al-Jazeera-Arabic-Regular"
#define FSFontNameAlJazeeraArabicLight   @"Al-Jazeera-Arabic-Light"
#define FSFontNameHelveticaLight              @"Helvetica Light"
#define FSFontNameHelveticaBold              @"Helvetica Bold"
#define FSFontNameHelveticaBoldOblique      @"Helvetica Bold Oblique"



#define   ThemeColor HexRGB(0x0bc2c6)



