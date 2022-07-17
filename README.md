# TwoCollectionViewsLinkwork
上下两collectionView互相联动,cell居中丝滑停靠。
> The upper and lower two collectionViews are linked to each other, and the cell will always finally stop smoothly in the middle.

高仿 陌生人社交App「遇见」 超高难度页面。全网唯一！！！
> Highly mimicked the effect of 「遇见」App's most difficult page. This is the only creation on the whole web.


## 效果图 / Magic Display
<img src="https://raw.githubusercontent.com/wustzhy/TwoCollectionViewsLinkwork/178ee2e6d142364e718d407fd3e9f21b2de65b29/test_2collectionViewsLinkMove/test_%20accostPage/style.png" width="300px">


### 1. 上collectionView, 滑动or点击cell, 滑动结束时自动居中,联动下collection
> Slide or click cell of the upper collectionView, then the cell will automatically stop in the middle when the slide ends, and concurrently link the under collectionView scrolling and stop.  
<img src="https://raw.githubusercontent.com/wustzhy/TwoCollectionViewsLinkwork/0dd1c3cf270153d5ddad65261029a29900a9efa9/test_2collectionViewsLinkMove/test_%20accostPage/upCollectionScrollOrSelect.gif" width="300px">

> 注意：上面的collection，快速滑动，离手后惯性继续滑动，丝滑停靠，非'常见的离手则停'。
> Note: A quick slide of the above collectionView will cause it to continue to slide with inertial after the hand leaves, slow down and eventually slide to a smooth stop , not normally 'stop when it leaves the hand'. The same goes for the collectionView below


### 2. 下collection,滑动,结束时自动居中,联动上collection
> Slide or click cell of the under collectionView, then the cell will automatically stop in the middle when the slide ends, and concurrently link the upper collectionView scrolling and stop.  
<img src="https://raw.githubusercontent.com/wustzhy/TwoCollectionViewsLinkwork/0dd1c3cf270153d5ddad65261029a29900a9efa9/test_2collectionViewsLinkMove/test_%20accostPage/downCollectionScroll.gif" width="300px">

> 注意：下面的collection，快速滑动，离手后惯性继续滑动，丝滑停靠，非'常见的离手则停'。
> Note: A quick slide of the collectionView below will cause it to continue to slide with inertial, slow down and eventually slide to a smooth stop after the hand leaves, not 'normally stop when it leaves the hand'. The same goes for the above collectionView.


### 3. 下collection cell,内嵌collectionView & tableView
> Such a scene, the collectionView below nested with another collectionView & tableView.
<img src="https://raw.githubusercontent.com/wustzhy/TwoCollectionViewsLinkwork/0dd1c3cf270153d5ddad65261029a29900a9efa9/test_2collectionViewsLinkMove/test_%20accostPage/collectionViewContainsCollectionView_TableView.gif" width="300px">
