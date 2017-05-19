/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYAccostViewController.mh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/30.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import "ZYAccostViewController.h"
#import "GTCommont.h"           //GTFixWidthFlaot ...


#import "ZYAccostImageCollection.h"
#import "ZYAccostInfoCollection.h"

@interface ZYAccostViewController ()<ZYAccostInfoCollection_ScrollDelegate,ZYAccostImageScrollDelegate>

@property (nonatomic, strong) ZYAccostImageCollection * imgCollectView;
@property (nonatomic, strong) ZYAccostInfoCollection * infoCollectionView;

@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) UIButton * replyBtn;

@end

@implementation ZYAccostViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;     //⚠️解决 自动下移Bug
    self.title = @"accost";
    self.view.backgroundColor = HexRGB(0xF6F6F6);
    
    // create imgCollectView, set frame
    self.imgCollectView.frame = CGRectMake(0, GTFixHeightFlaot(66), ScreenF.size.width, GTFixHeightFlaot(100));
    // test data
    NSMutableArray * mArr = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [mArr addObject:[UIImage imageNamed:@"demo_avatar_jobs.png"]];
    }
    self.imgCollectView.picArray = [mArr copy];
    self.imgCollectView.delegate = self;
    
    
    // create info
    
    self.infoCollectionView = [[ZYAccostInfoCollection alloc]initWithFrame:CGRectMake(0, 168, ScreenF.size.width, 450)];
    self.infoCollectionView.scroll_delegate = self;  //联动delegate
    [self.view addSubview:self.infoCollectionView];
    // test data
    NSMutableArray * mArr1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        [mArr1 addObject:[UIImage imageNamed:@"demo_avatar_jobs.png"]];
    }
    self.infoCollectionView.infosArray = mArr1;
    
    // create bottom btn
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.replyBtn addTarget:self action:@selector(replyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - touch events
-(void)deleteBtnClick:(UIButton *)sender{
    
}
-(void)replyBtnClick:(UIButton *)sender{
    
}
#pragma mark -ZYAccostInfoCollection_ScrollDelegate

-(void)infoCellScroll_scale:(CGFloat)off_scale{
    [self.imgCollectView scrollWithOFFScale:off_scale];
}

-(void)infoCellScroll_stop:(BOOL)stopOrNot{
    [self.imgCollectView infoScrollEnd:YES];
}

#pragma mark - ZYAccostImageScrollDelegate
-(void)imageCellScroll_scale:(CGFloat)off_scale{
    [self.infoCollectionView scrollWithOffScale:off_scale];
}
-(void)imageCellScroll_stop:(BOOL)stopOrNot
{
    [self.infoCollectionView imageScrollEnd:YES];
}


#pragma mark - 懒加载
-(ZYAccostImageCollection *)imgCollectView{
    if(_imgCollectView == nil){
        _imgCollectView = [[ZYAccostImageCollection alloc]init];
        [self.view addSubview:_imgCollectView];
    }
    return _imgCollectView;
}

-(UIButton *)deleteBtn{
    if(_deleteBtn == nil){
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ZHFScreenHeight-GTFixHeightFlaot(49), ZHFScreenWidth/2, GTFixHeightFlaot(49))];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        [_deleteBtn setImage:[UIImage imageNamed:@"btn_accost_delete"] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:HexRGB(0x9B9B9B) forState:UIControlStateNormal];
        [self.view addSubview:_deleteBtn];
        
    }
    return _deleteBtn;
}

-(UIButton *)replyBtn{
    if(_replyBtn == nil){
        _replyBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZHFScreenWidth/2, ZHFScreenHeight-GTFixHeightFlaot(49), ZHFScreenWidth/2, GTFixHeightFlaot(49))];
        _replyBtn.backgroundColor = [UIColor whiteColor];
        [_replyBtn setImage:[UIImage imageNamed:@"btn_accost_reply"] forState:UIControlStateNormal];
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBtn setTitleColor:HexRGB(0x9B9B9B) forState:UIControlStateNormal];
        [self.view addSubview:_replyBtn];

    }
    return _replyBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
