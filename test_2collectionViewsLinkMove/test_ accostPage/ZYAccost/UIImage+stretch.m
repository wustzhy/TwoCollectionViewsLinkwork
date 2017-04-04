//
//  UIImage+stretch.m
//  test_ accostPage
//
//  Created by Ray on 2017/3/31.
//  Copyright © 2017年 DragonLi. All rights reserved.
//

#import "UIImage+stretch.h"

@implementation UIImage (stretch)

//内缩放，一条变等于最长边，另外一条小于等于最长边
- (UIImage *)scaleToSize:(CGSize)newSize {
    CGFloat width = self.size.width;
    CGFloat height= self.size.height;
    CGFloat newSizeWidth = newSize.width;
    CGFloat newSizeHeight= newSize.height;
    if (width <= newSizeWidth &&
        height <= newSizeHeight) {
        return self;
    }
    
    if (width == 0 || height == 0 || newSizeHeight == 0 || newSizeWidth == 0) {
        return nil;
    }
    CGSize size;
    if (width / height > newSizeWidth / newSizeHeight) {
        size = CGSizeMake(newSizeWidth, newSizeWidth * height / width);
    } else {
        size = CGSizeMake(newSizeHeight * width / height, newSizeHeight);
    }
    return [self drawImageWithSize:size];
}
- (UIImage *)drawImageWithSize: (CGSize)size {
    CGSize drawSize = CGSizeMake(floor(size.width), floor(size.height));
    UIGraphicsBeginImageContext(drawSize);
    
    [self drawInRect:CGRectMake(0, 0, drawSize.width, drawSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
