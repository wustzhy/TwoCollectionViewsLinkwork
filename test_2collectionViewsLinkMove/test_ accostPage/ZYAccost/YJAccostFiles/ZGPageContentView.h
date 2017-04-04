//
//  ZGPageContentView.h
//  InputViewDemo
//
//  Created by hower on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGPageContentView : UIView
{
@private
    NSString *_reuseIdentifier;
}

/**
	引用标识
 */
@property (nonatomic,readonly) NSString *reuseIdentifier;


/**
	根据引用标识初始化页面内容视图
	@param reuseIdentifier 引用标识
    @param frame 位置与尺寸
	@returns 页面内容视图
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

/**
	视图显示
 */
- (void)viewDidShow;

/**
	视图隐藏
 */
- (void)viewDidHide;


@end
