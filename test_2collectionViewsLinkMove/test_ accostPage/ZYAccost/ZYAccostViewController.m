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
    
    
    // create
    
    self.infoCollectionView = [[ZYAccostInfoCollection alloc]initWithFrame:CGRectMake(0, 168, ScreenF.size.width, 450)];
    self.infoCollectionView.scroll_delegate = self;  //联动delegate
    [self.view addSubview:self.infoCollectionView];
    // test data
    NSMutableArray * mArr1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        [mArr1 addObject:[UIImage imageNamed:@"demo_avatar_jobs.png"]];
    }
    self.infoCollectionView.infosArray = mArr1;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
