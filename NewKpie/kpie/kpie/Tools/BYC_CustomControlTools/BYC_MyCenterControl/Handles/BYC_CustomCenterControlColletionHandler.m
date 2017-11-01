//
//  BYC_CustomCenterControlColletionHandler.m
//  kpie
//
//  Created by 元朝 on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_CustomCenterControlColletionHandler.h"
static NSString *cellId = @"cellId";
 NSString  *Notification_CustomCenterControlColletionScroll = @"Notification_CustomCenterControlColletionScroll";
 NSString  *Notification_CustomCenterControlColletionClickButtonScroll = @"Notification_CustomCenterControlColletionClickButtonScroll";

@interface BYC_CustomCenterControlColletionHandler ()<UICollectionViewDelegate, UICollectionViewDataSource>{

    // 这里使用weak 避免循环引用
    __weak UIViewController *_vc;
}

/**通知1*/
@property (nonatomic, strong)  NSString  *str_Notification1;
/**通知1*/
@property (nonatomic, strong)  NSString  *str_Notification2;

@end

@implementation BYC_CustomCenterControlColletionHandler

+ (instancetype)customCenterControlColletionHandlerWithParentViewController:(UIViewController *)parentViewController {

    BYC_CustomCenterControlColletionHandler *mySelf = [BYC_CustomCenterControlColletionHandler new];
    
    if (mySelf) {
        mySelf -> _vc = parentViewController;
        [mySelf initParam];//导致pop回上个个人中心，滑动条以及点击事件都没有了。
        [mySelf initSubViews];
        [mySelf registerNotification];
    }
    
    return mySelf;
}

- (void)initParam {

    Notification_CustomCenterControlColletionScroll = [NSString stringWithFormat:@"%lu",(unsigned long)_vc.hash];
    Notification_CustomCenterControlColletionClickButtonScroll = [NSString stringWithFormat:@"%lu",(unsigned long)_vc.view.hash];
}

- (void)initSubViews {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = _vc.view.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:_vc.view.bounds collectionViewLayout:flowLayout];
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    // 如果不设置代理, 将不会调用scrollView的delegate方法
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollsToTop = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [_vc.view addSubview:_collectionView];
}

- (void)registerNotification {

    _str_Notification1 = [Notification_CustomCenterControlColletionScroll copy];
    _str_Notification2 = [Notification_CustomCenterControlColletionClickButtonScroll copy];
    [QNWSNotificationCenter addObserver:self selector:@selector(notificationAction:) name:_str_Notification2 object:nil];
}

- (void)notificationAction:(NSNotification *)notification {

    [_collectionView setContentOffset:CGPointMake(screenWidth * [notification.object integerValue], 0)];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _vc.childViewControllers.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView1 dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    // 避免出现重用显示内容出错 ---- 也可以直接给每个cell用不同的reuseIdentifier实现
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController  *vc = _vc.childViewControllers[indexPath.row];
    [cell.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:_vc];
    return cell;
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [QNWSNotificationCenter postNotificationName:_str_Notification1 object:@(scrollView.contentOffset.x)];
}

@end
