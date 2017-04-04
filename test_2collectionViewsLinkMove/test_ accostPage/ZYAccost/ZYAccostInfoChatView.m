/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYAccostInfoChatView.mh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/31.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import "ZYAccostInfoChatView.h"
#import "ZYChatMsgInfoModel.h"  //总model

#import "ZYTool.h"  //文字宽高计算
#import "UIView+MJExtension.h"
#import "UILabel+ZYCustom.h"
/* -------------------------Model of sectionHeadView--------------------------*/
@interface TimeDisModel : NSObject
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * distance;


@end
@implementation TimeDisModel
@end

/* -------------------------sectionHeadView--------------------------*/
#pragma mark - sectionHeadView

@interface TimeDistanceHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) TimeDisModel * timeDistanceModel;

// 时间,距离
@property (nonatomic, strong) UIView * timeDisView;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * distanceLable;

@end
@implementation TimeDistanceHeaderView

-(void)setTimeDistanceModel:(TimeDisModel *)timeDistanceModel{
    _timeDistanceModel = timeDistanceModel;
    
    
    [self.contentView addSubview:self.timeDisView];
    self.timeDisView.mj_x = self.mj_w/2 - self.timeDisView.mj_w/2;
    self.timeDisView.mj_y = GTFixHeightFlaot(14);
    self.timeDisView.backgroundColor = [UIColor clearColor];

}

//2.在自定义的sectionHeadView／sectionFootView中重写这个方法，设置复用
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];//HexRGB(0xF6F6F6);
        //self.backgroundColor = [UIColor clearColor];
        //self.backgroundView.backgroundColor = [UIColor clearColor];
        //_UITableViewHeaderFooterViewBackground
        //_UITableViewHeaderFooterContentView
        //self.contentView.backgroundColor = [UIColor clearColor];
        [self initMyViews];//初始化方法
    }
    
    return self;
}

-(void)initMyViews{
    
}

-(UIView *)timeDisView{
    if(_timeDisView == nil){
        _timeDisView = [[UIView alloc]init];
        [_timeDisView addSubview:self.timeLabel];   // 先调 subview的getter
        [_timeDisView addSubview:self.distanceLable];

        CGFloat ww = self.timeLabel.mj_w + GTFixWidthFlaot(6) + self.distanceLable.mj_w;
        CGFloat hh = self.timeLabel.mj_h;
        _timeDisView.bounds = CGRectMake(0, 0, ww, hh);
        self.timeLabel.mj_x = 0;
        self.timeLabel.mj_y = 0;
        self.distanceLable.mj_x = self.timeLabel.mj_w + GTFixWidthFlaot(6);
        self.distanceLable.mj_y = 0;
        //[self.contentView addSubview:_timeDisView];
    }
    return _timeDisView;
}
//UILabel *timeLabel;
-(UILabel *)timeLabel{
    if(_timeLabel == nil){
        _timeLabel = [UILabel NewLabelWithBackColor:[UIColor clearColor]
                                               text: _timeDistanceModel.time //@"15:24"
                                             fontSz:GTFixWidthFlaot(10)
                                           fontName:@"PingFangSC-Regular"
                                          textColor:HexRGB(0x9B9B9B)
                      ];

        _timeLabel.mj_h = GTFixHeightFlaot(10); //限制 高度
        _timeLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _timeLabel;
}
-(UILabel *)distanceLable{
    if(_distanceLable == nil){
        _distanceLable = [UILabel NewLabelWithBackColor:[UIColor clearColor]
                                               text:_timeDistanceModel.distance //@"13.9km"
                                             fontSz:GTFixWidthFlaot(10)
                                           fontName:@"PingFangSC-Regular"
                                          textColor:HexRGB(0x9B9B9B)
                      ];
        
        _distanceLable.mj_h = GTFixHeightFlaot(10); //限制 高度
        _distanceLable.textAlignment = NSTextAlignmentCenter;
        
    }
    return _distanceLable;
}



@end

/* -------------------------cell--------------------------*/
#pragma mark - cell
@interface zyChatCell:UITableViewCell
@property (nonatomic, strong) NSString * message;


@end
@implementation zyChatCell
{
    UILabel * _msgLabel;
    UIView * _msgBgView;
   
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    if(_msgBgView == nil){
        _msgBgView = [[UIView alloc]init];
        _msgBgView.backgroundColor = HexRGB(0xFF4064);
        _msgBgView.layer.cornerRadius = 10;
        _msgBgView.layer.masksToBounds = YES;
    }
    [self.contentView addSubview:_msgBgView];
    if(_msgLabel == nil){
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.backgroundColor = [UIColor clearColor];
    }
    [_msgBgView addSubview:_msgLabel];
    
}


-(void)setMessage:(NSString *)message{
    _message = message;
    // 文字 size
    CGSize strSize = [ZYTool returnSizeWithString:_message font:[UIFont fontWithName:@"PingFangSC-Light" size:14] size:CGSizeMake(GTFixWidthFlaot(240), MAXFLOAT)];
    // 红色背景 size
    CGRect redRect ;
    redRect.size = CGSizeMake(strSize.width + 2*GTFixWidthFlaot(15), strSize.height +2*GTFixHeightFlaot(13));
    redRect.origin.x = GTFixWidthFlaot(15);
    
    _msgBgView.frame = redRect;

//    CGRect msgRect;
//    msgRect.size = strSize;
//    _msgLabel.frame = msgRect;
    _msgLabel.textColor = [UIColor whiteColor];
    _msgLabel.text = _message;
    [_msgLabel sizeToFit];
    _msgLabel.center = CGPointMake(redRect.size.width/2, redRect.size.height/2);
}

@end


/* -------------------------tableView--------------------------*/
#pragma mark - tableView here
@interface ZYAccostInfoChatView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * chatTableV;

@end

@implementation ZYAccostInfoChatView
{
    NSMutableArray <NSString *>*dataArray1;//定义数据数组1
    
    NSMutableArray *dataArray2;//定义数据数组2
    
    NSMutableArray *titleArray;//定义标题数组
    
}

-(void)setMsgInfoArray:(NSMutableArray<ZYChatMsgInfoModel *> *)msgInfoArray{
    
    _msgInfoArray = msgInfoArray;
    // view们 初始化完了 刷新tableView
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.chatTableV reloadData];
    });
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}


-(void)configUI{
    
    // test data
//    dataArray1 = [NSMutableArray array];
//    for (int i = 0; i < 3; i++) {
//        [dataArray1 addObject:[NSString stringWithFormat:@"我在这%zd",i]];
//    }
//    dataArray2 = [NSMutableArray array];
//    for (int i = 0; i < 2; i++) {
//        [dataArray2 addObject:[NSString stringWithFormat:@"你在哪%zd",i]];
//    }
//    titleArray = [NSMutableArray array];
//    for (int i = 0; i < 2; i++) {
//        TimeDisModel * tdModel = [[TimeDisModel alloc]init];
//        tdModel.time = [NSString stringWithFormat:@"06:5%zd",i];
//        tdModel.distance = [NSString stringWithFormat:@"%zd01km",i];
//        [titleArray addObject:tdModel];
//    }
    
    _chatTableV = [[UITableView alloc]initWithFrame:self.bounds
                                              style:UITableViewStyleGrouped];
    //UITableViewStylePlain ,section header 会停在顶部   
    _chatTableV.delegate = self;
    _chatTableV.dataSource = self;
    _chatTableV.separatorStyle = UITableViewCellSeparatorStyleNone; // 隐藏分割线
    _chatTableV.allowsSelection = NO; // 选中 取消
    _chatTableV.showsVerticalScrollIndicator = NO; // 滚动条 隐藏
    _chatTableV.backgroundColor = [UIColor whiteColor]; // 下拉时 背景色露出
    _chatTableV.layer.cornerRadius = 10;    //底部Corner直角,fix
    _chatTableV.layer.masksToBounds = YES;
    [self addSubview:_chatTableV];
    
    
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //return [titleArray count];//返回标题数组中元素的个数来确定分区的个数
    return self.msgInfoArray.count;
}

//指定每个分区中有多少行

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    switch (section) {
//            
//        case 0:
//            
//            return  [dataArray1 count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
//            
//            break;
//            
//        case 1:
//            
//            return  [dataArray2 count];
//            
//            break;
//            
//        default:
//            
//            return 0;  
//            
//            break;  
//            
//    }  
    return self.msgInfoArray[section].messagesArray.count;
}


//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID_zychat = @"CellID_zychat";
    
    //初始化cell并指定其类型，也可自定义cell
    
    zyChatCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellID_zychat];
    if(cell == nil){
        cell = [[zyChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID_zychat];
    }
//    switch (indexPath.section) {
//        case 0:
//            cell.message = @"hello";
//            break;
//        case 1:
//            cell.message = @"oh no";//[dataArray2[indexPath.row] copy];
//            break;
//        default:
//            break;
//    }
    cell.message = self.msgInfoArray[indexPath.section].messagesArray[indexPath.row];//
    return cell;//返回cell
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return [self.msgInfoArray[indexPath.section].heightArray[indexPath.row] floatValue];
}

//自定义section的头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    CGFloat ww = tableView.frame.size.width;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ww, GTFixHeightFlaot(40))];//
//    //add your code behind
//    
//    NSString * time = @"15:24";
//    NSString * distance = @"13.9km";

    
    static NSString *viewIdentfier_zy = @"headView_zy";
    
    TimeDistanceHeaderView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier_zy];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[TimeDistanceHeaderView alloc] initWithReuseIdentifier:viewIdentfier_zy];
    }
    
    TimeDisModel * model = [[TimeDisModel alloc]init];
    model.time = self.msgInfoArray[section].time;
    model.distance = self.msgInfoArray[section].distance;
    sectionHeadView.timeDistanceModel = model;//titleArray[section];
    
    return sectionHeadView;
    
    
}
//自定义section头部的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return GTFixHeightFlaot(40);
}




@end
