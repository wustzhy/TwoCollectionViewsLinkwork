/*
  The Name Of The Project：test_ accostPage
  The File Name：ZYAccostInfoCollection.mh
  The Creator ：Created by Dragon Li
  Creation Time：On  2017/3/30.
  Copyright ：  Copyright © 2016年 iaround. All rights reserved.
 File Content Description：
  Modify The File(修改)：
 */

#import "ZYAccostInfoCollection.h"
#import "ZYAccostInfoCell.h"
#import "ZYCustomerFlowLayout.h"    //解决apple自带间距设置不固定的问题

#import "FSDefinedFunctions.h"  //HexRGBAlpha ...
#import "GTCommont.h"           //GTFixWidthFlaot ...
#define ItemSize_infoCell       CGSizeMake( GTFixWidthFlaot(300) , GTFixHeightFlaot(450))
NSString *const infoCellIde = @"info_Cell";

//纠偏 使cell处于正中央
#define fixOff  GTFixWidthFlaot(4.5)
// 4

@interface ZYAccostInfoCollection()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger currentIdx;

@property (nonatomic, assign) BOOL imagesFirstMoved;
@property (nonatomic, assign) BOOL infosFirstMoved;

@end

@implementation ZYAccostInfoCollection
{
    UICollectionView * m_collectionView;
    
}

-(void)setInfosArray:(NSMutableArray *)infosArray{
    _infosArray = infosArray;
    [m_collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(),^{
        
        //[self scrollToIndex:1];
    });
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self configUI];
        
    }
    return self;
}



-(void)configUI{

    ZYCustomerFlowLayout *layout = [[ZYCustomerFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = ItemSize_infoCell;
    layout.minimumInteritemSpacing = GTFixWidthFlaot(14);
    layout.maximumInteritemSpacing = GTFixWidthFlaot(14);// 设置固定间距
    
    m_collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    m_collectionView.backgroundColor = [UIColor clearColor];
    //m_collectionView.pagingEnabled = YES;
    [m_collectionView setShowsHorizontalScrollIndicator:FALSE];
    m_collectionView.dataSource = self;
    m_collectionView.delegate = self;
    [m_collectionView registerClass:[ZYAccostInfoCell class] forCellWithReuseIdentifier:infoCellIde];
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
    return 2 + self.infosArray.count; //首尾各1个空的 --> 数组的头尾元素对应的cell 就可以居中屏幕了
    
}
// ------ cellForItem
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZYAccostInfoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:infoCellIde forIndexPath:indexPath];
    if(cell == nil){
        cell = [[ZYAccostInfoCell alloc]init];
    }
    
    if(indexPath.item == 0 || indexPath.item == self.infosArray.count + 1){
        cell.hidden = YES;
    }else{
        cell.hidden = NO;   //防止 复用隐藏
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



#pragma mark - 联动 - 主动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 滚动范围约束
    CGFloat pageSize = ItemSize_infoCell.width +GTFixWidthFlaot(14);
    CGFloat originalOff = pageSize -(ZHFScreenWidth/2 -ItemSize_infoCell.width/2);
    // ----> 在右滑使第一个cell滑到中央处,禁止再右滑动
    if (scrollView.contentOffset.x < originalOff) {

        [scrollView setContentOffset:CGPointMake(originalOff, scrollView.contentOffset.y) animated:NO];
        
    }
    // ----> 在左滑使第n个cell滑到中央处,禁止再左滑动
    CGFloat maxRightOffsetX = originalOff + (self.infosArray.count - 1) * (pageSize -fixOff);
    if (scrollView.contentOffset.x > maxRightOffsetX) {
        [scrollView setContentOffset:CGPointMake(maxRightOffsetX, scrollView.contentOffset.y) animated:NO];
    }

    if(self.imagesFirstMoved == NO){
        self.infosFirstMoved = YES;
    }
    
    if(self.imagesFirstMoved == NO && self.infosFirstMoved == YES){
        // 自己先动的, 带动他动
    }else{
        return;
    }

    //从数组第0个(cell第1个)起
    CGFloat off_scale = (scrollView.contentOffset.x - originalOff)/(pageSize - fixOff);
    // 代理
    if([self.scroll_delegate respondsToSelector:@selector(infoCellScroll_scale:)]){
        [self.scroll_delegate infoCellScroll_scale:off_scale];
    }
    
    // 检测滑到最初位置停!       --> 解决Bug: A手滑至最初位置停,B不能手滑了
    if(originalOff == scrollView.contentOffset.x){
        NSLog(@"======<><ori..d><><======");
        [self stopAndSetupStatus];
    }
    // 检测滑到最末尾位置停!       --> 解决Bug: A手滑至最末尾位置停,B不能手滑了
    if(maxRightOffsetX == scrollView.contentOffset.x){
        NSLog(@"======<><end..d><><======");
        [self stopAndSetupStatus];
    }
    
}
//主动(先手动) ,结束回调
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
    if([self.scroll_delegate respondsToSelector:@selector(infoCellScroll_stop:)]){
        [self.scroll_delegate infoCellScroll_stop:YES];
    }
    m_collectionView.userInteractionEnabled = YES;
}

#pragma mark - 联动 - 被动
-(void)scrollWithOffScale:(CGFloat)offScale{
    self.imagesFirstMoved = YES;
    m_collectionView.userInteractionEnabled = NO;
    
    // 从数组第0个(cell第1个)开始
    CGFloat pageSize = ItemSize_infoCell.width +GTFixWidthFlaot(14);
    CGFloat originalOff = pageSize -(ZHFScreenWidth/2 -ItemSize_infoCell.width/2);
    CGFloat targetX = (pageSize-fixOff) * offScale + originalOff;
    [m_collectionView setContentOffset:CGPointMake(targetX, 0) animated:NO];
}
// 被动 结束
-(void)imageScrollEnd:(BOOL)stopOrNot;//
{
    self.imagesFirstMoved = NO; self.infosFirstMoved = NO;
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
    
    CGFloat pageSize = ItemSize_infoCell.width +GTFixWidthFlaot(14);
    CGFloat originalOff = pageSize -(ZHFScreenWidth/2 -ItemSize_infoCell.width/2);
    NSInteger page = roundf((offset.x - originalOff) / pageSize);//四舍五入
    CGFloat targetX = (pageSize-fixOff) * page + originalOff; //与实际中心偏差, 纠偏 4 效果良好
    return CGPointMake(targetX, offset.y);
    
}


-(void)scrollToIndex:(NSInteger)idx{    // push出来时 没有将中间的cell bgview显示
    

    NSIndexPath *idxPth = [NSIndexPath indexPathForItem:idx inSection:0];
    //ZYAccostInfoCell * cell = (ZYAccostInfoCell *)[m_collectionView cellForItemAtIndexPath:idxPth];
    [m_collectionView scrollToItemAtIndexPath:idxPth atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.currentIdx = idx;
}



@end
