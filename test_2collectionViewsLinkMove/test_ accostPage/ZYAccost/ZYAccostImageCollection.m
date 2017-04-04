/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYAccostImageCollection.mh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/30.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */


#import "ZYAccostImageCollection.h"

#import "FSDefinedFunctions.h"  //HexRGBAlpha ...
#import "GTCommont.h"           //GTFixWidthFlaot ...

#define ScreenWidth             [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight            [[UIScreen mainScreen] bounds].size.height
#define ItemSize_dataCell       CGSizeMake( GTFixWidthFlaot(100) , GTFixHeightFlaot(100))
NSString *const cellIde = @"data_Cell";


#pragma mark - Cell

@interface dataCell: UICollectionViewCell

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIImageView *image;


@end

@implementation dataCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.layer.doubleSided = NO;
    
    CGFloat wh_bg = GTFixWidthFlaot(94);
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, wh_bg, wh_bg)];
    self.bgView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.bgView.backgroundColor = HexRGB(0xFFFFFF);
    self.bgView.layer.borderWidth = GTFixWidthFlaot(1);
    self.bgView.layer.borderColor = HexRGB(0xE7E7E7).CGColor;// 边框颜色
    self.bgView.layer.cornerRadius = wh_bg/2;
    self.bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bgView];
    
    self.image = [[UIImageView alloc] init];
    //self.image.backgroundColor = [UIColor clearColor];
    self.image.contentMode = UIViewContentModeScaleToFill;   //
    self.image.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGFloat wh_img = GTFixWidthFlaot(80);
    self.image.frame = CGRectMake(0, 0, wh_img, wh_img);
    self.image.center = self.bgView.center;
    self.image.layer.cornerRadius = wh_img/2;
    self.image.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.image];
    
    
}


@end


#pragma mark - ZYAccostImageCollection

@interface ZYAccostImageCollection() <UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, assign) NSInteger currentIdx;

@property (nonatomic, assign) BOOL imagesFirstMoved;
@property (nonatomic, assign) BOOL infosFirstMoved;


@end


@implementation ZYAccostImageCollection
{
    UICollectionView * m_collectionView;
    
}

-(void)setPicArray:(NSArray *)picArray{
    _picArray = picArray;
    [m_collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(),^{
        
        [self scrollToIndex:2];
    });
        
}

- (instancetype)init {
    self = [super init];
    if (self) {
    
        [self uiConfig];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    // height = 100
    m_collectionView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [m_collectionView reloadData];
    
    [super setFrame:frame];
}



-(void)uiConfig{
    self.currentIdx = 2;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = ItemSize_dataCell;//CGSizeMake( GTFixWidthFlaot(100) , GTFixHeightFlaot(100));
    layout.minimumInteritemSpacing = 6;
    layout.minimumLineSpacing = 0;
    //layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    
    m_collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    //m_collectionView.layer.cornerRadius = GTFixWidthFlaot(94)/2;
    //m_collectionView.layer.masksToBounds = YES;
    
    m_collectionView.backgroundColor = [UIColor clearColor];
    [m_collectionView setShowsHorizontalScrollIndicator:FALSE];
    m_collectionView.dataSource = self;
    m_collectionView.delegate = self;
    [m_collectionView registerClass:[dataCell class] forCellWithReuseIdentifier:cellIde];
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
    return self.picArray.count + 4; //首位各2个空的
    
}
// ------ cellForItem
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    dataCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIde forIndexPath:indexPath];
    if(cell == nil){
        cell = [[dataCell alloc]init];
    }

    if(indexPath.item < 2 || indexPath.item >= 2 + self.picArray.count){

        cell.hidden = YES;
    }
    else /*if(indexPath.item < 2 + self.picArray.count)*/{
        
        //cell.bgView.backgroundColor = HexRGB(0xFFFFFF);
        cell.bgView.hidden = YES;   //防止复用cell 出现
        //cell.image.hidden = NO;
        cell.hidden = NO;
        [cell.image setImage:self.picArray[indexPath.item-2]];
    }
    
    return cell;
}



//设置页眉的高度，竖着滚x没用，横着滚Y没用
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"did s cell %zd",indexPath.item);
    
    [self scrollToIndex:indexPath.item];
    
}

-(void)scrollToIndex:(NSInteger)idx{    // push出来时 没有将中间的cell bgview显示
    
    [self selectImageWithIndex:idx];
    //[m_collectionView scrollToItemAtIndexPath:idxPth atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES]; //不走结束的回调⚠️
    
    // 从数组第0个(cell第2个)开始
    CGFloat pageSize = ItemSize_dataCell.width;
    CGFloat originalOff = pageSize*2.5 - ZHFScreenWidth/2 ;
    [m_collectionView setContentOffset:CGPointMake(originalOff + (idx-2)*pageSize, 0) animated:YES];
    
}
-(void)selectImageWithIndex:(NSInteger)idx{
    
    NSIndexPath *idxPth_old = [NSIndexPath indexPathForItem:self.currentIdx inSection:0];
    dataCell * cell_old = (dataCell *)[m_collectionView cellForItemAtIndexPath:idxPth_old];
    cell_old.bgView.hidden = YES;
    
    NSIndexPath *idxPth = [NSIndexPath indexPathForItem:idx inSection:0];
    dataCell * cell = (dataCell *)[m_collectionView cellForItemAtIndexPath:idxPth];
    cell.bgView.hidden = NO;
    
    self.currentIdx = idx;
}
#pragma mark - 联动 - 被动
-(void)scrollWithOFFScale:(CGFloat)offscale{
    self.infosFirstMoved = YES;
    m_collectionView.userInteractionEnabled = NO; //被动滚动,若手势触发停止,没有结束回调可走
    
    
    // 从数组第0个(cell第2个)开始
    CGFloat pageSize = ItemSize_dataCell.width;
    CGFloat originalOff = pageSize*2.5 - ZHFScreenWidth/2 ;
    [m_collectionView setContentOffset:CGPointMake(originalOff + offscale*pageSize, 0) animated:NO];    // animated:YES ,会导致滑不动
    
}

-(void)infoScrollEnd:(BOOL)stopOrNot{
    //self.infoStop = stopOrNot;
    self.infosFirstMoved = NO;  self.imagesFirstMoved = NO;
    m_collectionView.userInteractionEnabled = YES;
}

#pragma mark - 滑动监听 - 联动 - 主动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 从数组第0个(cell第2个)开始
    CGFloat pageSize = ItemSize_dataCell.width;
    CGFloat originalOff = pageSize*2.5 - ZHFScreenWidth/2 ;
    // ----> 在右滑使第2个cell滑到中央处,禁止再右滑动
    if (scrollView.contentOffset.x < originalOff) {
        
        [scrollView setContentOffset:CGPointMake(originalOff, scrollView.contentOffset.y) animated:NO];
        NSLog(@"--<><><><><><>--, org = %f, offsetX = %f",originalOff,scrollView.contentOffset.x);
    
    }
    // ----> 在左滑使第n个cell滑到中央处,禁止再左滑动
    CGFloat maxRightOffsetX = originalOff + (self.picArray.count - 1) * (pageSize -0);
    if (scrollView.contentOffset.x > maxRightOffsetX) {
        [scrollView setContentOffset:CGPointMake(maxRightOffsetX, scrollView.contentOffset.y) animated:NO];
    }

    
    // 计算处于正中央的image
    NSInteger centerNum = (scrollView.contentOffset.x - (originalOff - pageSize/2))/pageSize;
    // 选中
    [self selectImageWithIndex:centerNum+2];
    
    if(self.infosFirstMoved == NO){
        self.imagesFirstMoved = YES;
    }
    
    if(self.infosFirstMoved == NO && self.imagesFirstMoved == YES){
        // 自己先动的, 带动他动
        NSLog(@"image first moved , images moving ..");
    }else{
        return;
    }

    CGFloat off_scale = (scrollView.contentOffset.x - originalOff)/pageSize;
    // 代理
    if([self.delegate respondsToSelector:@selector(imageCellScroll_scale:)]){
        [self.delegate imageCellScroll_scale:off_scale];
    }
    
    // 检测滑到最初位置停!       --> 解决Bug: A手滑至最初位置停,B不能手滑了
    if(originalOff == scrollView.contentOffset.x){
        NSLog(@"======<><ori..u><><======");
        [self stopAndSetupStatus];
    }
    // 检测滑到最末尾位置停!       --> 解决Bug: A手滑至最末尾位置停,B不能手滑了
    if(maxRightOffsetX == scrollView.contentOffset.x){
        NSLog(@"======<><end..u><><======");
        [self stopAndSetupStatus];
    }
    
    
}

#pragma mark 停止
// ----- 手滑一下放开,,, 自然滚停
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView.decelerating == NO && scrollView.dragging == NO){

        [self stopAndSetupStatus];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(scrollView.decelerating == NO && scrollView.dragging == NO){

        [self stopAndSetupStatus];
    }
}
// ⚠️调用setContentOffset: animated:YES  停止滑动的回调
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
{
    [self stopAndSetupStatus];
}

-(void)stopAndSetupStatus{
    self.imagesFirstMoved = NO; self.infosFirstMoved = NO;
    // 被动者 不走结束的回调, 主动者去告诉一下
    if([self.delegate respondsToSelector:@selector(imageCellScroll_stop:)]){
        [self.delegate imageCellScroll_stop:YES];
    }
    m_collectionView.userInteractionEnabled = YES;
}

#pragma mark - 使预测的cell平滑滚动到中央
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
    NSLog(@"velocity = %@ --> targetContentOffset->x = %f",NSStringFromCGPoint(velocity),targetContentOffset->x);
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    // 从数组第0个(cell第2个)开始
    CGFloat pageSize = ItemSize_dataCell.width;
    CGFloat originalOff = pageSize*2.5 - ZHFScreenWidth/2 ;
    NSInteger page = roundf((offset.x - originalOff) / pageSize);//四舍五入
    CGFloat targetX = (pageSize-0) * page + originalOff; //
    return CGPointMake(targetX, offset.y);
    
}



- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    NSLog(@"will d cell %zd",indexPath.item);
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    NSLog(@"will d1 cell %zd",indexPath.item);
    
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"will ed cell %zd",indexPath.item);
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

