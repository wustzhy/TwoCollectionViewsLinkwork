/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYChatMsgInfoModel.hh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/31.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import <UIKit/UIKit.h>

@interface ZYChatMsgInfoModel : UIView

@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSMutableArray <NSString *>* messagesArray;

//行高缓存
@property (nonatomic, strong) NSMutableArray <NSNumber *>* heightArray;


@end
