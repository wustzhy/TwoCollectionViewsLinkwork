/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYAccostInfoCell.mh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/31.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import "ZYAccostInfoCell.h"
#import "ZYAccostInfoImagsCV.h" // picture list
#import "ZYAccostInfoChatView.h"    //聊天信息 table
#import "ZYChatMsgInfoModel.h"      //聊天信息 总model

#import "ZYTool.h"                  //计算字符串size
#import "UIView+MJExtension.h"
#import "UILabel+ZYCustom.h"

#import "GTCommont.h"           //GTFixWidthFlaot ...
#define infoCellBgSize      CGSizeMake( GTFixWidthFlaot(300) , GTFixHeightFlaot(450))
#define topInfoViewHeight   GTFixHeightFlaot(14)


@interface ZYAccostInfoCell()

// 首行信息: 昵称,性别年龄
@property (nonatomic, strong) UIView * topInfoView;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UIButton * ageBtn;
// 分割线
@property (nonatomic, strong) UIView * line;

// 通过附近的人找到你
@property (nonatomic, strong) UILabel * findLabel;
// 日期,时间,距离
//@property (nonatomic, strong) NSString * <#name#>;



@end
@implementation ZYAccostInfoCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    /* -------------------------气泡背景--------------------------*/
    //气泡背景  62 = 10 + x +10, 38
//    CGRect bgFrame;
//    bgFrame.size = infoCellBgSize;
//    bgFrame.origin.x = self.bounds.size.width/2 - infoCellBgSize.width/2;
//    UIImageView * imgV = [[UIImageView alloc]initWithFrame:bgFrame];
//    UIImage *bg_img = [UIImage imageNamed:@"Combined_Shape.png"];
//    UIEdgeInsets insets = UIEdgeInsetsMake(20, 10, 10, 10);
//    // 四角不变 //拉伸UIImageResizingModeStretch    ,填充UIImageResizingModeTile
//    UIImage * image = [bg_img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    imgV.image = image;
//    [self.contentView addSubview:imgV]; // contentView
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    /* -------------------------搭讪者name\age信息--------------------------*/
    [self.contentView addSubview:self.topInfoView];
    self.topInfoView.mj_x = self.mj_w/2 - self.topInfoView.mj_w/2;
    self.topInfoView.mj_y = GTFixHeightFlaot(24);
    self.topInfoView.backgroundColor = [UIColor clearColor];
    
    /* -------------------------搭讪者的动态图--------------------------*/
    // image list
    ZYAccostInfoImagsCV * imagesV = [[ZYAccostInfoImagsCV alloc]initWithFrame:CGRectMake(GTFixWidthFlaot(15), GTFixWidthFlaot(53), GTFixWidthFlaot(60*4), GTFixWidthFlaot(58))];
    // test data
    NSMutableArray * mArr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [mArr addObject:[UIImage imageNamed:@"demo_avatar_cook"]];
    }
    imagesV.picArray = [mArr copy];
    [self.contentView addSubview:imagesV];
    
    /* -------------------------分割线--------------------------*/
    self.line = [self addALine_UnderView:imagesV topMargin:GTFixHeightFlaot(15)];
    
    /* -------------------------找到你的方式--------------------------*/
    [self.contentView addSubview:self.findLabel];
    self.findLabel.mj_x = self.mj_w/2 - self.findLabel.mj_w/2;
    self.findLabel.mj_y = self.line.mj_y + GTFixHeightFlaot(12);
    
    /* -------------------------聊天table--------------------------*/
    CGFloat chatY = CGRectGetMaxY(self.findLabel.frame) + GTFixHeightFlaot(2);
    CGFloat chatW = self.mj_w;
    CGFloat chatH = self.mj_h - chatY;
    ZYAccostInfoChatView * chatV = [[ZYAccostInfoChatView alloc]initWithFrame:CGRectMake(0, chatY, chatW, chatH)];
    chatV.layer.cornerRadius = 10;
    chatV.layer.masksToBounds = YES;
    [self.contentView addSubview:chatV];
    //----------test data----------
    NSMutableArray <ZYChatMsgInfoModel *>* mArray = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        ZYChatMsgInfoModel * model = [[ZYChatMsgInfoModel alloc]init];
        model.time = [NSString stringWithFormat:@"06:%zd0",i];
        model.distance = [NSString stringWithFormat:@"%zd01km",i];
        NSMutableArray *mArr = [NSMutableArray array];
        for (int j = 0; j < i+2; j++) {
            NSString * str = [NSString stringWithFormat:@"我是%zd",j];
            [mArr addObject:str];
        }
        model.messagesArray = mArr;
        
        [mArray addObject:model];
    }
    
    // 行高缓存
    for (int i = 0; i < mArray.count; i++) {
        //
        NSMutableArray * mutArray = [NSMutableArray array];
        for (int j = 0; j < mArray[i].messagesArray.count; j++) {
            //计算tableviewCell 行高
            NSString  * msgStr = mArray[i].messagesArray[j];
            CGSize strSize = [ZYTool returnSizeWithString:msgStr
                                                     font:[UIFont fontWithName:@"PingFangSC-Light" size:GTFixWidthFlaot(14)]
                                                     size:CGSizeMake(GTFixWidthFlaot(240), MAXFLOAT)];
            CGFloat height = strSize.height + GTFixHeightFlaot(2*13+16);
            [mutArray addObject:@(height)];
        }
        mArray[i].heightArray = mutArray;
    }
    chatV.msgInfoArray = mArray ;   //setter 数据
    
}

-(UIView *)addALine_UnderView:(UIView *)view topMargin:(CGFloat)margin{
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = HexRGB(0xE7E7E7);
    line.mj_x = 0;
    line.mj_y = CGRectGetMaxY(view.frame) + margin;
    line.mj_w = self.mj_w;
    line.mj_h = GTFixHeightFlaot(0.5);
    [self.contentView addSubview:line];
    
    return line;
}

-(UIView *)topInfoView{
    if(_topInfoView == nil){
        _topInfoView = [[UIView alloc]init];
        
        CGFloat ww = self.nameLabel.mj_w + GTFixWidthFlaot(6) + self.ageBtn.mj_w;
        CGFloat hh = self.nameLabel.mj_h;
        _topInfoView.bounds = CGRectMake(0, 0, ww, hh);
        [_topInfoView addSubview:self.nameLabel];
        [_topInfoView addSubview:self.ageBtn];
        self.nameLabel.mj_x = 0;
        self.nameLabel.mj_y = 0;
        self.ageBtn.mj_x = self.nameLabel.mj_w + GTFixWidthFlaot(6);
        self.ageBtn.mj_y = 0;
        //[self.contentView addSubview:_topInfoView];
    }
    return _topInfoView;
}
//UILabel *nameLabel;
-(UILabel *)nameLabel{
    if(_nameLabel == nil){
        _nameLabel = [UILabel NewLabelWithBackColor:[UIColor clearColor]
                                               text:@"也许会是你的我"
                                             fontSz:GTFixWidthFlaot(14)
                                           fontName:@"PingFangSC-Regular"
                                          textColor:HexRGB(0x222222)
                      ];
        
        _nameLabel.mj_h = topInfoViewHeight; //限制 高度
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _nameLabel;
}
//UIButton * ageBtn;
-(UIButton *)ageBtn{
    if(_ageBtn == nil){
        //_ageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_ageBtn setAgeWithBirthday:338918400 gender:1 frame:CGRectZero];
        _ageBtn = [UIButton NewButtonWithBackColor:[UIColor clearColor]
                                              text:@"24岁"
                                            fontSz:GTFixWidthFlaot(13)
                                         textColor:HexRGB(0x222222)];
        _ageBtn.mj_h = topInfoViewHeight; //限制 高度
        
    }
    return _ageBtn;
}


-(UILabel *)findLabel{
    if(_findLabel == nil){
        _findLabel = [UILabel NewLabelWithBackColor:[UIColor clearColor]
                                               text:@"通过附近的人找到你"
                                             fontSz:GTFixWidthFlaot(10)
                                           fontName:@"PingFangSC-Light"
                                          textColor:HexRGB(0x9B9B9B)
                      ];
        
        _findLabel.mj_h = GTFixHeightFlaot(10); //限制 高度
        _findLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _findLabel;
}

@end
