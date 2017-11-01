//
//  BYC_SkillViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/19.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_SkillViewController.h"
#import "BYC_SkillCollectionViewCell.h"
#import "BYC_MainNavigationController.h"

@interface BYC_SkillViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)  NSMutableArray  *mArrayData;
@property (nonatomic, strong)  UIPageControl   *pageControl;

@end

@implementation BYC_SkillViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = KUIColorBaseGreenNormal;
    
    [self initData];
    
    [self initViews];
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}
-(NSMutableArray *)mArrayData {

    if (!_mArrayData) {
        
        _mArrayData = [NSMutableArray array];
    }
    
    return _mArrayData;
}

- (void)initData {

    NSString *stringName = (KCurrentDeviceIsIphone4) ? @"iphone4s" : (KCurrentDeviceIsIphone5) ? @"iphone5:5s" : (KCurrentDeviceIsIphone6) ?  @"iphone6:6s": @"iphone6p:6sp";
    
    for (int i = 1; i <= 12; i++) {

        if(i == 2) continue;
        [self.mArrayData addObject:[NSString stringWithFormat:@"%@%d",stringName,i]];
    }
}

- (void)initViews {
    
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    layout.itemSize = CGSizeMake(screenWidth,screenHeight);
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //创建UICollectionView
    UICollectionView *skillcollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth,screenHeight) collectionViewLayout:layout];
    skillcollectionView.dataSource = self;
    skillcollectionView.delegate = self;
    skillcollectionView.backgroundColor = [UIColor clearColor];
    skillcollectionView.showsHorizontalScrollIndicator = NO;
    skillcollectionView.pagingEnabled = YES;
    skillcollectionView.alwaysBounceHorizontal = NO;
    skillcollectionView.bounces = NO;
    [self.view addSubview:skillcollectionView];
    
    [skillcollectionView registerClass:[BYC_SkillCollectionViewCell class] forCellWithReuseIdentifier:@"skillcollectionView"];

    //page视图
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 25, self.view.frame.size.width,10)];
    //未选中颜色
    _pageControl.pageIndicatorTintColor = KUIColorFromRGBA(0xffffff, .5f);
    //当前page的颜色
    _pageControl.currentPageIndicatorTintColor = KUIColorFromRGB(0X4BC8B6);
    _pageControl.numberOfPages = self.mArrayData.count;
    [self.view addSubview:_pageControl];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(self.view.left + 4, self.view.top + 20, 40, 44);
    [backButton setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:backButton atIndex:0];
    [self.view addSubview:backButton];
}

- (void)backAction {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  Mark - collectionDataSourceAndDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.mArrayData.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *stringID = @"skillcollectionView";
    BYC_SkillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.cellImageName = self.mArrayData[indexPath.item];
    _pageControl.currentPage = indexPath.item;
    if (indexPath.item == 0) {
        collectionView.frame = CGRectMake(20, 0, screenWidth-20, screenHeight);
    }
    else{
    collectionView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    }
    return cell;
}

@end
