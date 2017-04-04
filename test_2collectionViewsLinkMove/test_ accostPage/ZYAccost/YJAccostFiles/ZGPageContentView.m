//
//  ZGPageContentView.m
//  InputViewDemo
//
//  Created by hower on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZGPageContentView.h"

@implementation ZGPageContentView

//@synthesize reuseIdentifier = _reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) 
    {
        _reuseIdentifier = [reuseIdentifier copy];
    }
    return self;
}

- (void)dealloc
{
//    [_reuseIdentifier release];
//    _reuseIdentifier = nil;
//    
//    [super dealloc];
}

- (void)viewDidShow
{
    
}

- (void)viewDidHide
{
    
}

@end
