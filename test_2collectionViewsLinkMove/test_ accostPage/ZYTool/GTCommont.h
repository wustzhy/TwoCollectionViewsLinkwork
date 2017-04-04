//
//  GTCommont.h
//  iphone6 Fix Demo
//
//  Created by GuanTian Li on 14-11-5.
//  Copyright (c) 2014年 GCI. All rights reserved.
//

#import <UIKit/UIKit.h>

//  屏幕  iPhone6 (375,667)
#define ScreenF [[UIScreen mainScreen] bounds]

//颜色
#define ZHFColorRGB(R,G,B,A) [UIColor colorWithRed:R/255.f green:G/255.f blue:B/255. alpha:A]

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]



#ifndef iphone6_Fix_Demo_GTCommontHeader_h
#define iphone6_Fix_Demo_GTCommontHeader_h

CG_INLINE CGFloat GTFixHeightFlaot(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
//    if (mainFrme.size.height/1294*2 < 1) {
//        return height;
//    }
    height = height*mainFrme.size.height/1294*2;
    return height;
}

CG_INLINE CGFloat GTReHeightFlaot(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
//    if (mainFrme.size.height/1294*2 < 1) {
//        return height;
//    }
    height = height*1294/(mainFrme.size.height*2);
    return height;
}

CG_INLINE CGFloat GTFixWidthFlaot(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
//    if (mainFrme.size.height/1294*2 < 1) {
//        return width;
//    }
    width = width*mainFrme.size.width/750*2;
    return width;
}

CG_INLINE CGFloat GTReWidthFlaot(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
//    if (mainFrme.size.height/1294*2 < 1) {
//        return width;
//    }
    width = width*750/mainFrme.size.width/2;
    return width;
}

// 经过测试了, 以iphone6屏幕为适配基础
CG_INLINE CGRect
GTRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size.width = GTFixWidthFlaot(width); rect.size.height = GTFixWidthFlaot(height);
    return rect;
}


#endif
