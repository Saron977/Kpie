//
//  HL_TagViewController.m
//  kpie
//
//  Created by sunheli on 16/9/26.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_TagViewController.h"
#import "BYC_HomeCollectionViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "HL_JumpToVideoPlayVC.h"
#import "BYC_HttpServers+HL_TagVC.h"

@interface HL_TagViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView_New;

@property (nonatomic, strong) NSMutableArray   <BYC_BaseVideoModel *>*dataSource; //与标签相关的数据

@property (nonatomic, strong) NSMutableDictionary *mDic_Parameters;

@end

@implementation HL_TagViewController

-(NSMutableArray <BYC_BaseVideoModel *>*)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableDictionary *)mDic_Parameters{
    if (!_mDic_Parameters) {
        _mDic_Parameters = [NSMutableDictionary dictionary];
    }
    return _mDic_Parameters;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];
}
- (void)initCollectionView {
    
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing = 0.f;
    layout.itemSize = CGSizeMake(screenWidth / 2 - .5f , 180.f);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //创建UICollectionView
    self.collectionView_New = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, screenWidth,screenHeight-64)  collectionViewLayout:layout];
    self.collectionView_New.dataSource = self;
    self.collectionView_New.delegate = self;
    self.collectionView_New.emptyDataSetSource = self;
    self.collectionView_New.emptyDataSetDelegate = self;
    self.collectionView_New.backgroundColor = KUIColorBackgroundModule2;
    self.collectionView_New.showsVerticalScrollIndicator = NO;
    [self.collectionView_New registerNib:[UINib nibWithNibName:@"BYC_HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionCell"];

    [self.view addSubview:self.collectionView_New];
    
    
    self.collectionView_New.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        BYC_BaseVideoModel *firstModel = [self.dataSource firstObject];
        QNWSDictionarySetValueForKey(self.mDic_Parameters, firstModel.onmstime, @"time");
        QNWSDictionarySetValueForKey(self.mDic_Parameters, @1, @"upType");
        [self getThemeVideosWith:self.mDic_Parameters];
    }];
    
    self.collectionView_New.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        BYC_BaseVideoModel *lastModel  = [self.dataSource lastObject];
        QNWSDictionarySetValueForKey(self.mDic_Parameters, lastModel.onmstime, @"time");
        QNWSDictionarySetValueForKey(self.mDic_Parameters, @2, @"upType");
        [self getThemeVideosWith:self.mDic_Parameters];

    }];
}

-(void)setThemeStr:(NSString *)themeStr{
    _themeStr = themeStr;
    QNWSDictionarySetValueForKey(self.mDic_Parameters, themeStr, @"themeName");
    QNWSDictionarySetValueForKey(self.mDic_Parameters, @0, @"upType");
    //upType  0---默认   1---刷新  2---加载
    [self getThemeVideosWith:self.mDic_Parameters];
}

-(void)getThemeVideosWith:(NSDictionary *)parameters{
    [BYC_HttpServers requestTagVCVideosWithParameters:parameters success:^(AFHTTPRequestOperation *operation, NSArray<BYC_BaseVideoModel *> *themeVideos) {
        if ([self.collectionView_New.header isRefreshing]) {

            if (themeVideos.count > 0) {
                self.dataSource = [themeVideos mutableCopy];
            }
            else{
                self.dataSource = self.dataSource;
            }
            [self.collectionView_New.header endRefreshing];
            [self.collectionView_New.footer endRefreshing];
        }
        else if ([self.collectionView_New.footer isRefreshing]){
            if (themeVideos.count > 0) {
                
                NSMutableArray *arr_focusData = [NSMutableArray array];
                arr_focusData = [themeVideos mutableCopy];
                for (int i = 0; i<arr_focusData.count; i++) {
                    
                    for (BYC_BaseVideoModel *themeVideoModel in self.dataSource) {
                        if ([((BYC_BaseVideoModel *)arr_focusData[i]).videoid isEqualToString:themeVideoModel.videoid]){
                            [arr_focusData removeObjectAtIndex:i];
                        }
                    }
                }
                [self.dataSource addObjectsFromArray:arr_focusData];
                // 结束刷新
                [self.collectionView_New.footer endRefreshing];
            }
            else{
                
                [self.collectionView_New.footer endRefreshingWithNoMoreData];
            }
        }
        else{
           self.dataSource = [themeVideos mutableCopy];
        }
       [self.collectionView_New reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - collection的DataSource 和 Delegate方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BYC_HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BYC_BaseVideoModel *themeVideoModel = [[BYC_BaseVideoModel alloc]init];
    themeVideoModel = self.dataSource[indexPath.section*20+indexPath.row];
    [HL_JumpToVideoPlayVC jumpToVCWithModel:themeVideoModel andVideoTepy:themeVideoModel.isvr andisComment:NO andFromType:ENU_FromOtherVideo];

}

#pragma mark ------空数据提示
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image = [[UIImage alloc]init];
    image = [UIImage imageNamed:@"img_kbzt_smdmy"];
    return image;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return -50;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
