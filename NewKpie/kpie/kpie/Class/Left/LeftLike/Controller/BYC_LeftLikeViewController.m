//
//  BYC_LeftLikeViewController.m
//  kpie
//
//  Created by 元朝 on 15/12/24.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_LeftLikeViewController.h"
#import "BYC_LeftLikeModel.h"
#import "BYC_HomeCollectionViewCell.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import "HL_JumpToVideoPlayVC.h"
#import "HL_JumpToVideoPlayVC.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "BYC_ControllerCustomView.h"
#import "BYC_HttpServers+HL_LikedVideoVC.h"

@interface BYC_LeftLikeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)  NSMutableArray  *cellArrayModels;
@property (nonatomic, strong)  UICollectionView *collectionView;

@end

@implementation BYC_LeftLikeViewController

-(NSMutableArray *)cellArrayModels{
    if (!_cellArrayModels) {
        _cellArrayModels = [NSMutableArray array];
    }
    return _cellArrayModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赞过的视频";
    //初始化Cell
    [self makeUI];
    
    //加载数据
    [self firstLoadData];
}

#pragma mark - 布局视图
-(void)makeUI
{
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing = 0.f;
    layout.itemSize = CGSizeMake(screenWidth / 2 - .5f , 180.f);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //创建UICollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, screenWidth,screenHeight-64)  collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.emptyDataSetSource = self;
    _collectionView.emptyDataSetDelegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionCell"];
    
    __weak __typeof(self) weakSelf = self;
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self firstLoadData];
    }];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreData];
    }];
}


#pragma mark - 网络请求
- (void)firstLoadData {
//    {"upType":0,"userId":"8af4bf094e96bbe6014e99f20321000c"}
    NSDictionary *dic = @{@"upType":@0,@"userId":[BYC_AccountTool userAccount].userid};
   [BYC_HttpServers requestLikedVideoVCDataWithParameters:dic success:^(AFHTTPRequestOperation *operation, HL_LikedVideoModel *likedVideoModel) {
       if ([self.collectionView.header isRefreshing]) {
           if (likedVideoModel.array_LikedVideoModel.count > 0) {
               self.cellArrayModels = [likedVideoModel.array_LikedVideoModel mutableCopy];
           }
           else{
               self.cellArrayModels = self.cellArrayModels;
           }
           [self.collectionView.header endRefreshing];
       }
       else{
          self.cellArrayModels = [likedVideoModel.array_LikedVideoModel mutableCopy]; 
       }
       [_collectionView.footer endRefreshing];
       [_collectionView reloadData];
       
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
   }];
}

-(void)loadMoreData{
//    {"time":"2016-06-13 15:31:40:603","upType":2,"userId":"8af4bf094e96bbe6014e99f20321000c","videoId":"8af4bf095542a835015543513c970005"}
//    time videoid 上拉用到
    BYC_BaseVideoModel *likedVideoModel = [self.cellArrayModels lastObject];
    NSDictionary *dic = @{@"time":likedVideoModel.onmstime,@"upType":@2,@"userId":[BYC_AccountTool userAccount].userid,@"videoId":likedVideoModel.videoid};
    QNWSWeakSelf(self);
    [BYC_HttpServers requestLikedVideoVCDataWithParameters:dic success:^(AFHTTPRequestOperation *operation, HL_LikedVideoModel *likedVideoModel) {
        if (likedVideoModel.array_LikedVideoModel.count > 0) {
                
                NSMutableArray *arr_focusData = [NSMutableArray array];
                arr_focusData = [likedVideoModel mutableCopy];
                for (int i = 0; i<arr_focusData.count; i++) {
                    
                    for (BYC_BaseVideoModel *likeModel2 in weakself.cellArrayModels) {
                        if ([((BYC_BaseVideoModel *)arr_focusData[i]).videoid isEqualToString:likeModel2.videoid]){
                            [arr_focusData removeObjectAtIndex:i];
                        }
                    }
                }
            [weakself.cellArrayModels addObjectsFromArray:arr_focusData];
            // 结束刷新
            [weakself.collectionView.footer endRefreshing];
        }
        else{
            
            [weakself.collectionView.footer endRefreshingWithNoMoreData];
        }
        
        [_collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - collection的DataSource 和 Delegate方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellArrayModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"HomeCollectionCell";
    
    BYC_HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    cell.model = self.cellArrayModels[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark --
    BYC_BaseVideoModel *leftLike_Model = [[BYC_BaseVideoModel alloc]init];
    leftLike_Model = self.cellArrayModels[indexPath.section*20+indexPath.row];
    [HL_JumpToVideoPlayVC jumpToVCWithModel:leftLike_Model andVideoTepy:leftLike_Model.isvr andisComment:NO andFromType:ENU_FromLeftLikeVideo];
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

#pragma mark - 刷新网络请求
-(void)reloadDataWithPage{
    [self firstLoadData];
}


@end
