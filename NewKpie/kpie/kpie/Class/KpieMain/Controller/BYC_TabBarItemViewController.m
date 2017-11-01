//
//  BYC_TabBarItemViewController.m
//  kpie
//
//  Created by 元朝 on 16/7/8.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_TabBarItemViewController.h"
#import "BYC_TabBarItemNavigationBar.h"
#import "BYC_ControllerCustomView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface BYC_TabBarItemViewController ()<BYC_TabBarItemNavigationBarDelegate,BYC_TabBarItemViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) BYC_TabBarItemNavigationBar *tabBarItemNavigationBar;
/**包含的标题数组，要求必须大于等于2*/
@property (nonatomic, strong)  NSMutableArray <NSString *> *array_Items;
/**包含的控制器数组，要求必须大于等于2*/
@property (nonatomic, strong)  NSMutableArray <UIViewController *> *array_VCs;
@end

@implementation BYC_TabBarItemViewController

#pragma mark - 本类系统相关方法(包括自定义的初始化方法)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}

-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (_tabBarItemNavigationBar == nil) {
        
        //布局
        [self initSubViews];
        [self initCustomNavigationBar];
    }
}
#pragma mark - 初始化子视图及参数
-(void)initSubViews
{
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(screenWidth , screenHeight);
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //创建UICollectionView
    _homecollectionView = [[BYC_CollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,screenHeight) collectionViewLayout:layout];
    _homecollectionView.dataSource = self;
    _homecollectionView.delegate = self;
    _homecollectionView.emptyDataSetSource = self;
    _homecollectionView.emptyDataSetDelegate = self;
    _homecollectionView.backgroundColor = [UIColor clearColor];
    _homecollectionView.showsHorizontalScrollIndicator = NO;
    _homecollectionView.scrollsToTop = NO;
    _homecollectionView.pagingEnabled = YES;
    _homecollectionView.bounces = NO;
    [self.view addSubview:_homecollectionView];
    [_homecollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionCell"];
}

- (void)initCustomNavigationBar {
    
    _tabBarItemNavigationBar = [BYC_TabBarItemNavigationBar initTabBarItemNavigationBarWithItems:_array_Items];
    _tabBarItemNavigationBar.delegate = self;
    [self.view addSubview:_tabBarItemNavigationBar];
}

#pragma mark - 属性的get 及 set 方法

-(void)setArr_Items:(NSArray<NSDictionary *> *)arr_Items {
    
    if (_arr_Items != arr_Items) {
        
        _arr_Items = arr_Items;
        
        
     for (NSDictionary *dic in _arr_Items) {
        
        BOOL isRepeat = NO;//去掉同名重复的频道
        for (NSString *str_Temp in _array_Items) if ([str_Temp isEqualToString:[dic allKeys][0]]) isRepeat = YES;
        if (isRepeat) continue;
            if (_array_Items)[_array_Items addObjectsFromArray:[dic allKeys]];
            else _array_Items = [[dic allKeys] mutableCopy];
            
            if (_array_VCs) [_array_VCs addObjectsFromArray:[dic allValues]];
            else _array_VCs = [[dic allValues] mutableCopy];
        }
    }
    if (_isNoCustomNavBar) {//BYC~~~！20161223 应对新需求，活动栏，只有活动页面了。
        
        _array_Items = [@[_array_Items[0]] mutableCopy];
        _array_VCs = [@[_array_VCs[0]] mutableCopy];
    }
    if (_tabBarItemNavigationBar) _tabBarItemNavigationBar.arr_Items = _array_Items;
    [_homecollectionView reloadData];
}

#pragma mark - 网络请求数据

#pragma mark - UIScrollView 以及其子类的数dataSource和delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.array_VCs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionCell" forIndexPath:indexPath];;
    UIViewController *vc = _array_VCs[indexPath.row];
    [cell.contentView addSubview:vc.view];
    [self addChildViewController:vc];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.tabBarItemNavigationBar.float_Progress = scrollView.contentOffset.x;
}
#pragma mark - 其它系统类的代理（例如UITextFieldDelegate,UITextViewDelegate等）

#pragma mark - BYC_TabBarItemViewControllerDelegate
- (void)tabBarItemViewController:(BYC_TabBarItemViewController *)tabBarItemViewController didSelectItemAtIndexPath:(int)index {
    
    [self.homecollectionView setContentOffset:CGPointMake(screenWidth * index, 0) animated:YES];
}

#pragma mark - BYC_TabBarItemNavigationBarDelegate
- (void)tabBarItemNavigationBar:(BYC_TabBarItemNavigationBar *)tabBarItemNavigationBar didSelectItemAtIndexPath:(int)index {
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarItemViewController:didSelectItemAtIndexPath:)])
        [_delegate tabBarItemViewController:self didSelectItemAtIndexPath:index];
}

#pragma mark ------空数据提示
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    BYC_ControllerCustomView *emptyView = [[BYC_ControllerCustomView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight - KHeightNavigationBar - KHeightTabBar) andNotificationObject:self];
    emptyView.imageUrl = @"img_kbzt_smdmy";
    return emptyView;
}
#pragma mark - 自定义类的代理

#pragma mark - 本类创建的的相关方法（不是本类系统的方法）




@end
