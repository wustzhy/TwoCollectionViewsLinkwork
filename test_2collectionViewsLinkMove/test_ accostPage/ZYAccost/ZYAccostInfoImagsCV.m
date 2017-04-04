/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYAccostInfoImagsCV.mh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/31.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import "ZYAccostInfoImagsCV.h"
#import "ZYCustomerFlowLayout.h"    //解决apple自带间距设置不固定的问题

#import "GTCommont.h"           //GTFixWidthFlaot ...
#define ItemSize_imageCell       CGSizeMake( GTFixWidthFlaot(58) , GTFixHeightFlaot(58))
NSString *const imageCellIde = @"imageCellIde";

@interface ImageCell:UICollectionViewCell
@property (nonatomic, strong) UIImageView * image;

@end
@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.layer.doubleSided = NO;
   
    self.image = [[UIImageView alloc] init];
    self.image.contentMode = UIViewContentModeScaleToFill;   //
    self.image.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGFloat wh_img = ItemSize_imageCell.width;//GTFixWidthFlaot(58);
    self.image.frame = CGRectMake(0, 0, wh_img, wh_img);
    
    [self.contentView addSubview:self.image];
    
    
}


@end


@interface ZYAccostInfoImagsCV()<UICollectionViewDelegate,UICollectionViewDataSource>

@end


@implementation ZYAccostInfoImagsCV
{
    UICollectionView * m_collectionView;
    
}


-(void)setPicArray:(NSArray *)picArray{
    _picArray = picArray;
    [m_collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(),^{
        // 刷新完后 do sth...
        
    });
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self uiConfig];
    }
    return self;
}

//- (void)setFrame:(CGRect)frame
//{
//    // height = 100
//    
//    [m_collectionView reloadData];
//    
//}



-(void)uiConfig{
    
    
//    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.itemSize = ItemSize_imageCell;//CGSizeMake( GTFixWidthFlaot(100) , GTFixHeightFlaot(100));
//    layout.minimumInteritemSpacing = GTFixWidthFlaot(10); //
//    layout.minimumLineSpacing = 0;
//    //layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    
    ZYCustomerFlowLayout *layout = [[ZYCustomerFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = ItemSize_imageCell;
    layout.minimumInteritemSpacing = GTFixWidthFlaot(2);
    layout.maximumInteritemSpacing = GTFixWidthFlaot(2);// 设置固定间距
    

    
    m_collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    //m_collectionView.layer.cornerRadius = GTFixWidthFlaot(94)/2;
    //m_collectionView.layer.masksToBounds = YES;
    
    m_collectionView.backgroundColor = [UIColor clearColor];
    [m_collectionView setShowsHorizontalScrollIndicator:FALSE];
    m_collectionView.dataSource = self;
    m_collectionView.delegate = self;
    [m_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:imageCellIde];
    [self addSubview:m_collectionView];
    
    
}

#pragma mark - UICollectionView Delegate & DataSource
//设置有多少个段
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picArray.count; //首位各2个空的
    
}
// ------ cellForItem
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIde forIndexPath:indexPath];
    if(cell == nil){
        cell = [[ImageCell alloc]init];
    }
    
    [cell.image setImage:self.picArray[indexPath.item]];
    
    
    return cell;
}




@end
