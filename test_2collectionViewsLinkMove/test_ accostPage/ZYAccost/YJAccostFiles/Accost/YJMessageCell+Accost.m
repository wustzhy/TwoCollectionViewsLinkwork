//
//  YJMessageCell+Accost.m
//  iAround
//
//  Created by 123456 on 8/6/14.
//
//

#import "YJMessageCell+Accost.h"

#import "ZGP2PTextMessageCell.h"
#import "ZGP2PAudioMessageCell.h"
#import "ZGP2PPictureMessageCell.h"
#import "ZGP2PVideoMessageCell.h"
#import "ZGP2PLocationMessageCell.h"
#import "ZGP2PGiftMessageCell.h"
#import "ZGP2PMapMessageCell.h"
#import "ZGP2PShareMsgCell.h"

#import "U6Common.h"
#import "TrueOrBraveAnswer.h"
#import <objc/runtime.h>

#define LEFT_PADDING    (39.0f)

static Boolean accostType = false;

@implementation YJMessageCell (Accost)

+ (void)openAccostType
{
    accostType = true;
}

+ (void)closeAccostType
{
    accostType = false;
}

- (void)updateViewAjustAccost
{
    // 时间轴是没有头像的
    _userAvatar.hidden = YES;
}

+ (void)swizzling
{
//    Method oriM = class_getInstanceMethod([self class], @selector(messageDateView));
//    Method newM = class_getInstanceMethod([self class], @selector(accostMessageDateView));
//    method_exchangeImplementations(oriM, newM);
}


//XXX:具体显示时间的规则
- (UIView *)accostMessageDateView
{
    if (!accostType) {
        return [self accostMessageDateView];
    }
    
    if (self.dMessageDate <= 0) {
        return nil;
    }
    
    UILabel *label = [self accostTimeLabel];
    
    NSString *dateString = [U6Common getChatMessageDateString:_messageInfo.datetime/1000];
    NSString *distanceString = [U6Common getDistanceStr:_messageInfo.fDistance];
    NSString *timeSting = [NSString stringWithFormat:@"%@    %@", dateString, distanceString];
    label.text = timeSting;
    
    [label sizeToFit];
    return label;
}


- (UILabel *)accostTimeLabel
{
    UILabel *label = (UILabel *)[self.contentView viewWithTag:223344];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.textColor = RGBCOLOR(0x33, 0x33, 0x33);
        label.tag = 223344;
        label.font = [UIFont systemFontOfSize:9.0f];
        [self.contentView addSubview:label];
        [label release];
    }
    return label;
}

@end



@implementation ZGP2PTextMessageCell (Accost)

+ (void)swizzling
{
    Method oriM = class_getInstanceMethod([self class], @selector(updateLayout));
    Method newM = class_getInstanceMethod([self class], @selector(accostUpdateLayout));
    method_exchangeImplementations(oriM, newM);
}

- (void)accostUpdateLayout
{
    if (accostType)
    {
        _userAvatar = nil;
    }
    [self accostUpdateLayout];
}

@end

@implementation ZGP2PAudioMessageCell (Accost)

+ (void)swizzling
{
    Method oriM = class_getInstanceMethod([self class], @selector(updateLayout));
    Method newM = class_getInstanceMethod([self class], @selector(accostUpdateLayout));
    method_exchangeImplementations(oriM, newM);
}

- (void)accostUpdateLayout
{
    if (accostType)
    {
        _userAvatar = nil;
    }
    [self accostUpdateLayout];
}

@end

@implementation ZGP2PPictureMessageCell (Accost)

+ (void)swizzling
{
    Method oriM = class_getInstanceMethod([self class], @selector(updateLayout));
    Method newM = class_getInstanceMethod([self class], @selector(accostUpdateLayout));
    method_exchangeImplementations(oriM, newM);
}

- (void)accostUpdateLayout
{
    if (accostType)
    {
        _userAvatar = nil;
    }
    [self accostUpdateLayout];
}

@end

@implementation ZGP2PVideoMessageCell (Accost)

+ (void)swizzling
{
    Method oriM = class_getInstanceMethod([self class], @selector(updateLayout));
    Method newM = class_getInstanceMethod([self class], @selector(accostUpdateLayout));
    method_exchangeImplementations(oriM, newM);
}

- (void)accostUpdateLayout
{
    if (accostType)
    {
        _userAvatar = nil;
    }
    [self accostUpdateLayout];
}

@end

@implementation ZGP2PLocationMessageCell (Accost)

+ (void)swizzling
{
    Method oriM = class_getInstanceMethod([self class], @selector(updateLayout));
    Method newM = class_getInstanceMethod([self class], @selector(accostUpdateLayout));
    method_exchangeImplementations(oriM, newM);
}

- (void)accostUpdateLayout
{
    if (accostType)
    {
        _userAvatar = nil;
    }
    [self accostUpdateLayout];
}

@end

@implementation ZGP2PGiftMessageCell (Accost)

+ (void)swizzling
{
    Method oriM = class_getInstanceMethod([self class], @selector(updateLayout));
    Method newM = class_getInstanceMethod([self class], @selector(accostUpdateLayout));
    method_exchangeImplementations(oriM, newM);
}

- (void)accostUpdateLayout
{
    if (accostType)
    {
        _userAvatar = nil;
    }
    [self accostUpdateLayout];
}

@end

@implementation ZGP2PMapMessageCell (Accost)

+ (void)swizzling
{
    Method oriM = class_getInstanceMethod([self class], @selector(updateLayout));
    Method newM = class_getInstanceMethod([self class], @selector(accostUpdateLayout));
    method_exchangeImplementations(oriM, newM);
}

- (void)accostUpdateLayout
{
    if (accostType)
    {
        _userAvatar = nil;
    }
    [self accostUpdateLayout];
}

@end

@implementation ZGP2PShareMsgCell (Accost)

+ (void)swizzling
{
    Method oriM = class_getInstanceMethod([self class], @selector(updateLayout));
    Method newM = class_getInstanceMethod([self class], @selector(accostUpdateLayout));
    method_exchangeImplementations(oriM, newM);
}

- (void)accostUpdateLayout
{
    if (accostType)
    {
        _userAvatar = nil;
    }
    [self accostUpdateLayout];
}

@end

