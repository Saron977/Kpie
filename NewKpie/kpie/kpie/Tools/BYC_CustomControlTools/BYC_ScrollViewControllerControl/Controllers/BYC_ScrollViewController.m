 //
//  BYC_ScrollViewController.m
//  kpie
//
//  Created by 元朝 on 16/7/7.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ScrollViewController.h"
#import "BYC_ScrollViewPanGestureRecognizer.h"
#import "UIView+BYC_Tools.h"
#import "BYC_CollectionView.h"

#import "BYC_ControllerCustomView.h"

static CGFloat const KHeight_title = 30;
// 下划线默认高度
static CGFloat const KHeight_UnderLine = 2;
// 默认标题字体
#define KTitleFont [UIFont systemFontOfSize:14]
static NSString * const ItemID = @"ItemID";
// 默认标题间距
static CGFloat const margin = 20;
// 标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
static NSString * const BYC_ScrollVCClickOrScrollDidFinshNote = @"BYC_ScrollVCClickOrScrollDidFinshNote";

@interface BYC_ScrollViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**整体内容View 包含标题好内容滚动视图*/
@property (nonatomic, strong) UIView           *view_Content;
/**标题滚动视图*/
@property (nonatomic, strong) UIScrollView     *scrollView_Title;
/**内容滚动视图*/
@property (nonatomic, strong) BYC_CollectionView *collectionView_Content;
/**所有标题数组*/
@property (nonatomic, strong) NSMutableArray   *array_TitleLabels;
/**所有标题宽度数组*/
@property (nonatomic, strong) NSMutableArray   *array_TitleWidths;
/**下标视图*/
@property (nonatomic, strong) UIView           *view_UnderLine;
/**记录上一次内容滚动视图偏移量*/
@property (nonatomic, assign) CGFloat          float_LastOffsetX;
/**记录是否点击*/
@property (nonatomic, assign) BOOL             isClickTitle;
/**记录是否在动画*/
@property (nonatomic, assign) BOOL             isAniming;
/*是否初始化*/
@property (nonatomic, assign) BOOL             isInitial;
/**标题间距*/
@property (nonatomic, assign) CGFloat          float_TitleMargin;
/**计算上一次选中角标 */
@property (nonatomic, assign) NSInteger        selIndex;
/**毛玻璃视图*/
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

/**************************************下标************************************/

///**根据角标，选中对应的控制器*/
//@property (nonatomic, assign) NSInteger selectIndex;
/**是否延迟滚动下标*/
@property (nonatomic, assign) BOOL      isDelayScroll;

/**************************************下标************************************/
@end

@implementation BYC_ScrollViewController

#pragma mark - 初始化方法

- (instancetype)init
{
    if (self = [super init]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    [self initParam];
    [self initSubViews];
}

- (void)initParam {

    _array_TitleLabels = [NSMutableArray array];
    _array_TitleWidths = [NSMutableArray array];
}

- (void)initSubViews {

    _view_Content = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_view_Content];
    
    _scrollView_Title = [[UIScrollView alloc] init];
    //毛玻璃滤镜
//    [self setBlurEffectView];
    
    _scrollView_Title.backgroundColor = KUIColorBackgroundModule2;
    _scrollView_Title.scrollsToTop = NO;
    [self.view_Content addSubview:_scrollView_Title];
    
    _view_UnderLine = [[UIView alloc] init];
    _view_UnderLine.backgroundColor = KUIColorBaseGreenNormal;
    [self.scrollView_Title addSubview:_view_UnderLine];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(screenWidth, screenHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView_Content = [[BYC_CollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView_Content.pagingEnabled = YES;
    _collectionView_Content.showsHorizontalScrollIndicator = NO;
    _collectionView_Content.bounces = NO;
    _collectionView_Content.delegate = self;
    _collectionView_Content.dataSource = self;
    _collectionView_Content.emptyDataSetSource = self;
    _collectionView_Content.emptyDataSetDelegate = self;
    _collectionView_Content.scrollsToTop = NO;
    [self.view_Content insertSubview:_collectionView_Content belowSubview:self.scrollView_Title];
    [self.collectionView_Content registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ItemID];
    self.collectionView_Content.backgroundColor = self.view.backgroundColor;
    
    //记录滑动手势
    //    [BYC_ScrollViewPanGestureRecognizer sharePanGestureWith:self.scrollView_Title];
    //记录滑动手势
    //    [BYC_ScrollViewPanGestureRecognizer sharePanGestureWith:self.collectionView_Content];
}
#pragma mark - 懒加载

/**
 *  设置毛玻璃
 */
-(void)setBlurEffectView{
    
    _visualEffectView = [_scrollView_Title getBlurEffectViewWithStyle:UIBlurEffectStyleLight];
    [_scrollView_Title addSubview:_visualEffectView];
}

#pragma mark - 控制器view生命周期方法

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat contentY = self.navigationController ? KHeightNavigationBar : [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat contentW = screenWidth;
    self.view_Content.backgroundColor = [UIColor whiteColor];
    // 设置标题滚动视图frame
    // 计算尺寸
    CGFloat titleH = KHeight_title;
    CGFloat titleY = contentY;
    self.scrollView_Title.frame = CGRectMake(0, titleY, contentW, titleH);
    _visualEffectView.frame = CGRectMake(0, 0, _scrollView_Title.contentSize.width + margin, _scrollView_Title.kheight);
    // 设置内容滚动视图frame
    self.collectionView_Content.frame = CGRectMake(0, 0, contentW, screenHeight);
}

#pragma mark - 刷新界面方法
// 更新界面
- (void)resetSubViews
{
    
    if (_array_TitleLabels.count == 0) {
        _isInitial = NO;
        // 清空之前所有标题
        [self.array_TitleLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.array_TitleLabels removeAllObjects];
        // 刷新表格
        [self.collectionView_Content reloadData];
        [self viewWillAppear:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isInitial == NO) {
        
         _isInitial = YES;
        // 没有子控制器，不需要设置标题
        if (self.childViewControllers.count == 0) return;
        
        [self setUpTitleWidth];
        [self setUpAllTitle];
    }
}
#pragma mark - 添加标题方法
// 计算所有标题宽度
- (void)setUpTitleWidth
{
    // 判断是否能占据整个屏幕
    NSUInteger count = self.childViewControllers.count;
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    CGFloat totalWidth = 0;
    // 计算所有标题的宽度
    for (NSString *title in titles) {
        
        NSAssert(![title isKindOfClass:[NSNull class]], @"没有设置Controller.title属性，应该把子标题保存到对应子控制器中");
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KTitleFont} context:nil];
        CGFloat width = titleBounds.size.width;
        [self.array_TitleWidths addObject:@(width)];
        totalWidth += width;
    }
    
    if (totalWidth > screenWidth) {
        
        _float_TitleMargin = margin;
        self.scrollView_Title.contentInset = UIEdgeInsetsMake(0, 0, 0, _float_TitleMargin);
        return;
    }
    
    CGFloat float_TitleMargin = (screenWidth - totalWidth) / (count + 1);
    _float_TitleMargin = float_TitleMargin < margin? margin: float_TitleMargin;
    self.scrollView_Title.contentInset = UIEdgeInsetsMake(0, 0, 0, _float_TitleMargin);
}

// 设置所有标题
- (void)setUpAllTitle
{
    // 遍历所有的子控制器
    NSUInteger count = self.childViewControllers.count;
    
    // 添加所有的标题
    CGFloat labelW = 0;
    CGFloat labelH = KHeight_title;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    for (int i = 0; i < count; i++) {
        
        UIViewController *vc = self.childViewControllers[i];
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = i;
        // 设置按钮的文字颜色
        label.textColor = KUIColorWordsBlack3;
        label.font = KTitleFont;
        // 设置按钮标题
        label.text = vc.title;
        labelW = [self.array_TitleWidths[i] floatValue];
        // 设置按钮位置
        UILabel *lastLabel = [self.array_TitleLabels lastObject];
        labelX = _float_TitleMargin + CGRectGetMaxX(lastLabel.frame);
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        // 监听标题的点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        // 保存到数组
        [self.array_TitleLabels addObject:label];
        [_scrollView_Title addSubview:label];
        if (i == _selectIndex) [self titleClick:tap];
    }
    
    // 设置标题滚动视图的内容范围
    UILabel *lastLabel = self.array_TitleLabels.lastObject;
    _scrollView_Title.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    _scrollView_Title.showsHorizontalScrollIndicator = NO;
    _collectionView_Content.contentSize = CGSizeMake(count * screenWidth, 0);
}

#pragma mark - 标题效果渐变方法
// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    CGRect titleBoundsR = [rightLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KTitleFont} context:nil];
    
    CGRect titleBoundsL = [leftLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KTitleFont} context:nil];
    
    return titleBoundsR.size.width - titleBoundsL.size.width;
}

// 设置下标偏移
- (void)setUpUnderLineOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isClickTitle) return;
    
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.left - leftLabel.left;
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _float_LastOffsetX;
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / screenWidth;
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / screenWidth;
    
    self.view_UnderLine.kwidth += underLineWidth;
    self.view_UnderLine.left += underLineTransformX;

}

#pragma mark - 标题点击处理
- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    if (self.array_TitleLabels.count) {
        
        UILabel *label = self.array_TitleLabels[selectIndex];
        [self titleClick:[label.gestureRecognizers lastObject]];
    }
}

// 标题按钮点击
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    // 记录是否点击标题
    _isClickTitle = YES;
    // 获取对应标题label
    UILabel *label = (UILabel *)tap.view;
    // 获取当前角标
    NSInteger i = label.tag;
    // 选中label
    [self selectLabel:label];
    // 内容滚动视图滚动到对应位置
    CGFloat offsetX = i * screenWidth;
    self.collectionView_Content.contentOffset = CGPointMake(offsetX, 0);
    // 记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
    _float_LastOffsetX = offsetX;
    // 添加控制器
    UIViewController *vc = self.childViewControllers[i];
    // 判断控制器的view有没有加载，没有就加载，加载完在发送通知
    if (vc.view)[QNWSNotificationCenter postNotificationName:BYC_ScrollVCClickOrScrollDidFinshNote  object:vc];// 发出通知点击标题通知
    _selIndex = i;
    // 点击事件处理完成
    _isClickTitle = NO;
}

- (void)selectLabel:(UILabel *)label
{

    [self.array_TitleLabels makeObjectsPerformSelector:@selector(setTextColor:) withObject:KUIColorWordsBlack3];
    // 修改标题选中颜色
    label.textColor = KUIColorBaseGreenNormal;
    // 设置标题居中
    [self setLabelTitleCenter:label];
    // 设置下标的位置
    [self setUpUnderLine:label];
}
// 设置下标的位置
- (void)setUpUnderLine:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KTitleFont} context:nil];
    CGFloat underLineH = KHeight_UnderLine;
    self.view_UnderLine.top = label.kheight - underLineH;
    self.view_UnderLine.kheight = underLineH;

    // 最开始不需要动画
    if (self.view_UnderLine.left == 0) {
        
        self.view_UnderLine.kwidth = titleBounds.size.width;
        self.view_UnderLine.left = label.left;
        return;
    }
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.view_UnderLine.kwidth = titleBounds.size.width;
        self.view_UnderLine.left = label.left;
    }];
}

// 让选中的按钮居中显示
- (void)setLabelTitleCenter:(UILabel *)label
{
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = label.center.x - screenWidth * 0.5;
    if (offsetX < 0) offsetX = 0;
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.scrollView_Title.contentSize.width - screenWidth + _float_TitleMargin;
    if (maxOffsetX < 0) maxOffsetX = 0;
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    // 滚动区域
    [self.scrollView_Title setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemID forIndexPath:indexPath];
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加控制器
    UIViewController *vc = self.childViewControllers[indexPath.row];
    vc.view.frame = CGRectMake(0, 0, self.collectionView_Content.kwidth, self.collectionView_Content.kheight);
    [cell.contentView addSubview:vc.view];
    return cell;
}

#pragma mark - UIScrollViewDelegate

// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = screenWidth;
    
    NSInteger extre = offsetXInt % screenWInt;
    if (extre > screenWidth * 0.5) {
        // 往右边移动
        offsetX = offsetX + (screenWidth - extre);
        _isAniming = YES;
        [self.collectionView_Content setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else if (extre < screenWidth * 0.5 && extre > 0){
        _isAniming = YES;
        // 往左边移动
        offsetX =  offsetX - extre;
        [self.collectionView_Content setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    // 获取角标
    NSInteger i = offsetX / screenWidth;
    // 选中标题
    [self selectLabel:self.array_TitleLabels[i]];
    // 取出对应控制器发出通知
    UIViewController *vc = self.childViewControllers[i];
    // 发出通知
    [QNWSNotificationCenter postNotificationName:BYC_ScrollVCClickOrScrollDidFinshNote object:vc];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 点击和动画的时候不需要设置
    if (_isAniming || self.array_TitleLabels.count == 0) return;
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // 获取左边角标
    NSInteger leftIndex = offsetX / screenWidth;
    // 左边按钮
    UILabel *leftLabel = self.array_TitleLabels[leftIndex];
    // 右边角标
    NSInteger rightIndex = leftIndex + 1;
    // 右边按钮
    UILabel *rightLabel = nil;
    if (rightIndex < self.array_TitleLabels.count) rightLabel = self.array_TitleLabels[rightIndex];
    // 设置下标偏移
    if (_isDelayScroll == NO) [self setUpUnderLineOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel]; // 延迟滚动，不需要移动下标
    // 记录上一次的偏移量
    _float_LastOffsetX = offsetX;
}

#pragma mark ------空数据提示
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    BYC_ControllerCustomView *emptyView = [[BYC_ControllerCustomView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight - KHeightNavigationBar - KHeightTabBar) andNotificationObject:self];
    emptyView.imageUrl = @"img_kbzt_smdmy";
    return emptyView;
}

@end
