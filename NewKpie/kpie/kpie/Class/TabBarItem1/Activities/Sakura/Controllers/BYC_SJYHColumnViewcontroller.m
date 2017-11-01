//
//  BYC_SJYHColumnViewcontroller.m
//  kpie
//
//  Created by 元朝 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//
//  世纪樱花 定制栏目 以后其他类似栏目可以借用
//  世纪樱花 定制栏目 以后其他类似栏目可以借用
//  世纪樱花 定制栏目 以后其他类似栏目可以借用

#import "BYC_SJYHColumnViewcontroller.h"
#import "BYC_HomeCollectionViewCell.h"
#import "WX_VoideDViewController.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_SetBackgroundColor.h"
#import "BYC_ColumnCollectionHeader.h"
#import "WX_MovieCViewController.h"
#import "BYC_TopHiddenView.h"

#import "BYC_MTBannerModel.h"
#import "BYC_MTVideoModel.h"
#import "BYC_AccountTool.h"
#import "BYC_LoginAndRigesterView.h"
#import "BYC_MTVideoGroupModel.h"
#import "BYC_ShareView.h"
#define BYC_ColumnCollectionHeaderLabelSize CGSizeMake(screenWidth - 16, 12)

@interface BYC_SJYHColumnViewcontroller()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UMSocialUIDelegate> {

    BOOL _isNewWhetherMore;  //最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotWhetherMore;  //最热是否已经上拉加载更多加载完毕所有数据
    
     UICollectionViewFlowLayout *_layout;
     CGSize _headerSize;
     UIImageView *_imageV_Header;
    BYC_ColumnCollectionHeader *_header;
    
    NSArray<BYC_MTBannerModel     *> *_array_SecCover;
    NSArray<BYC_MTVideoModel      *> *_array_Video;
    NSArray<BYC_MTVideoGroupModel *> *_array_VideoGroup;
}

@property (nonatomic, strong)  NSMutableArray  *cellNewArrayModels; //最新数据
@property (nonatomic, strong)  NSMutableArray  *cellHotArrayModels; //最热数据
@property (nonatomic, assign)  int  isType; //最新标示:0:表示最新   2:按点赞量排
@property (weak, nonatomic  ) IBOutlet UICollectionView   *collectionView;

@property (strong, nonatomic) IBOutlet BYC_TopHiddenView *topHiddenView;

@end

@implementation BYC_SJYHColumnViewcontroller

-(instancetype)init {

    if (self = [super init]) {
        
        [self loadView];
        
        // 设置背景色
        [[BYC_SetBackgroundColor alloc] setBackgroundViewColor:self];
        // 初始化子视图
        [self initViews];
        
        _isNewWhetherMore = NO;
        _isHotWhetherMore = NO;
        _cellHotArrayModels = [NSMutableArray array];
        _cellNewArrayModels = [NSMutableArray array];
        
        _headerSize = CGSizeMake(screenWidth, 226);
    }
    
    return self;
}

- (void)initViews {
    
    __weak __typeof(self) weakSelf = self;
    

    self.topHiddenView.buttonAction = ^(NSInteger flag){
    
        [weakSelf buttonAction:flag];
    };
    //设置布局
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = .5f;
    _layout.minimumLineSpacing      = 0.f;
    _layout.itemSize = CGSizeMake(screenWidth / 2 - .5f , 180.f);
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];

    _collectionView.collectionViewLayout = _layout;
    _collectionView.backgroundColor      = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"BYC_ColumnCollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)[weakSelf.isType == 0 ? weakSelf.cellNewArrayModels:weakSelf.cellHotArrayModels firstObject];
        [weakSelf refreshParameterWithModel:model Type:weakSelf.isType upType:@"0" isRefresh:YES];
    }];
    // 上拉加载更多
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)[weakSelf.isType == 0 ? weakSelf.cellNewArrayModels:weakSelf.cellHotArrayModels lastObject];
        [weakSelf refreshParameterWithModel:model Type:weakSelf.isType upType:@"1" isRefresh:YES];
    }];
}

//设置分享
- (void)setUpActivity {
    
    if (![const_ShareActivityUrl isEqualToString:const_ShareKpieDownloadUrl] && const_ShareActivityUrl.length > 0) {
        
        const_ShareActivityContent = [NSString stringWithFormat:@"我在参加#%@#活动,快来看看吧~%@",_model.columnname,const_ShareActivityUrl];
        const_ShareActivityImageUrl =  _model.firstcover.length == 0 ? _idModel.advertimg : _model.firstcover;
        const_ShareActivityTitle = _model.columnname;
        self.isShowShareButton = YES;
    }
}

-(void)setIdModel:(BYC_ADModel *)idModel {
    
    _idModel = idModel;
    BYC_OtherViewControllerModel  *model = [[BYC_OtherViewControllerModel alloc] init];
    model.columnid    = idModel.columnID;
    model.columnname  = idModel.columnName;
    model.secondcover = idModel.secondCover;
    model.columndesc  = idModel.columnDesc;
    model.themename   = idModel.theMeName;
    model.channelid   = idModel.channelID;
    model.isactive    = [NSNumber numberWithInteger:idModel.advertType - 3];
    self.model = model;
}

- (void)setModel:(BYC_OtherViewControllerModel *)model {
    
    [super setModel:model];
    self.title = _model.columnname;
    //默认加载最新
    _isType = 0;
    
    
    NSString *string = _model.columndesc;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(BYC_ColumnCollectionHeaderLabelSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    _headerSize =  CGSizeMake(screenWidth, _headerSize.height + titleSize.height - BYC_ColumnCollectionHeaderLabelSize.height);
    //默认加载最新

    [self.view showHUDWithTitle:@"正在加载..." WithState:BYC_MBProgressHUDShowTurnplateProgress];
    [self firstRequestData];
}

- (void)buttonAction:(NSInteger)flag {
    
    self.topHiddenView.selectButton = flag;
    _header.selectButton = flag;
    
    switch (flag) {
        case 1://最新
            
            _isType = 0;
            if (_cellNewArrayModels.count == 0)[self firstRequestData];
            else [_collectionView reloadData];
            if (!_isNewWhetherMore)[_collectionView.footer resetNoMoreData];

            break;
        case 2://最热
            
            _isType = 2;
            if (_cellHotArrayModels.count == 0) {
                
                [_collectionView reloadData];//没有数据提前刷新一下，把上个数据刷掉
                [self refreshParameterWithModel:nil Type:_isType upType:nil isRefresh:NO];
            } else [_collectionView reloadData];
            if (!_isHotWhetherMore)[_collectionView.footer resetNoMoreData];
            
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 网络请求
- (void)firstRequestData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    QNWSDictionarySetObjectForKey(parameters, [NSNumber numberWithInteger:_isType], @"type")
    QNWSDictionarySetObjectForKey(parameters, _model.isactive, @"columnType")
    QNWSDictionarySetObjectForKey(parameters, _model.columnid, @"columnid")
    
    [BYC_HttpServers Get:KQNWS_GetGroupAllJsonArrayListVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _array_SecCover   = [BYC_MTBannerModel initModelsWithArray:responseObject[@"secCover"]];
        _array_Video      = [BYC_MTVideoModel initModelsWithArray:responseObject[@"video"]];
        _array_VideoGroup = [BYC_MTVideoGroupModel initModelsWithArray:responseObject[@"videoGroup"]];
        _topHiddenView.array_VideoGroup = _array_VideoGroup;
        const_ShareActivityUrl = responseObject[@"shareUrl"];
        [self setUpActivity];
        switch (_isType) {
            case 0://最新
                
                self.cellNewArrayModels = [_array_Video mutableCopy];
                break;
            case 2://最热
                
                self.cellHotArrayModels = [_array_Video mutableCopy];
                break;
                
            default:
                break;
        }
        
        [_collectionView reloadData];
        [self.view hideHUDWithTitle:@"加载完成！" WithState:BYC_MBProgressHUDHideProgress];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
    }];
}


- (void)refreshParameterWithModel:(BYC_HomeViewControllerModel *)model Type:(int)type upType:(NSString *)upType isRefresh:(BOOL)flag {
    
    NSMutableDictionary *dic_Parameters = [NSMutableDictionary dictionary];
    if (flag) {
        
        dic_Parameters[@"upType"]    = upType;
        dic_Parameters[@"videoId"]   = model.videoid;
        dic_Parameters[@"onofftime"] = model.onofftime;
        dic_Parameters[@"views"]     = [NSNumber numberWithInteger:model.views];
    }
    
    dic_Parameters[@"type"]      = [NSNumber numberWithInt:type];
    if (_array_VideoGroup)dic_Parameters[@"groupId"] = _isType == 2 ? _array_VideoGroup[1].videoGroup_Id : _array_VideoGroup[0].videoGroup_Id ;
    
    [self refreshRequestWithParameters:dic_Parameters];
}

- (void)refreshRequestWithParameters:(NSDictionary *)parameters{
    
    [BYC_HttpServers Get:KQNWS_GetGroupJsonArrayListVideoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *bodyRows = responseObject[@"rows"];
        
        if (bodyRows.count > 0 ) {
            
            //cell数据
            NSMutableArray *bodyArrayModels = [NSMutableArray array];
            
            for (NSArray *arrayModel in bodyRows) {
                
                BOOL isRepeat = NO;//NO 没有重复 YES 有重复
                BYC_HomeViewControllerModel *model = [BYC_HomeViewControllerModel initModelWithArray:arrayModel];
                
                if (_isType == 0) {
                        
                    for (BYC_HomeViewControllerModel *CellModel in _cellNewArrayModels)
                        if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                    if (!isRepeat)[bodyArrayModels addObject:model];
                    
                }else if (_isType == 2) {
                        
                    for (BYC_HomeViewControllerModel *CellModel in _cellHotArrayModels)
                        if ([CellModel.videoid isEqualToString:model.videoid])isRepeat = YES;//有重复
                    if (!isRepeat)[bodyArrayModels addObject:model];
                }
            }
            
            [self resultDataProcessing:bodyArrayModels];
        }else {
            
            [self noDataWithType];
        }

        [_collectionView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];

        if (self.collectionView.footer.isRefreshing) {
            
            if (_isType == 0) {
                    
                // 变为没有更多数据的状态
                if (_isNewWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                else [self.collectionView.footer endRefreshing];
            }
            if (_isType == 2) {
                
                // 变为没有更多数据的状态
                if (_isHotWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                else [self.collectionView.footer endRefreshing];
            }
        }
        if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
    }];
}

/** 数据处理 */
- (void)resultDataProcessing:(NSMutableArray *)mArray{
    
    if (self.collectionView.footer.isRefreshing) {
        
        
        [_isType == 0 ? self.cellNewArrayModels:self.cellHotArrayModels addObjectsFromArray:mArray];
        if (mArray.count == 0) [self noDataWithType];// 变为没有更多数据的状态
        else [self.collectionView.footer endRefreshing];// 结束刷新
        
    }else if (self.collectionView.header.isRefreshing) {
        
        NSMutableArray *mmArray = _isType == 0 ? self.cellNewArrayModels:self.cellHotArrayModels;
        if (_isType == 0) self.cellNewArrayModels = [mArray mutableCopy];
        if (_isType == 2) self.cellHotArrayModels = [mArray mutableCopy];
        [_isType == 0 ? self.cellNewArrayModels:self.cellHotArrayModels addObjectsFromArray:mmArray];
        // 结束刷新
        [self.collectionView.header endRefreshing];
        
    }else {
        
        if (_isType == 0) self.cellNewArrayModels = mArray;
        if (_isType == 2) self.cellHotArrayModels = mArray;
    }
    
}

- (void)noDataWithType {
    
    if (self.collectionView.footer.isRefreshing) {
        
        if (_isType == 0) {

            // 变为没有更多数据的状态
            [self.collectionView.footer endRefreshingWithNoMoreData];
            _isNewWhetherMore = YES;

        }
        if (_isType == 2) {

            // 变为没有更多数据的状态
            [self.collectionView.footer endRefreshingWithNoMoreData];
            _isHotWhetherMore = YES;
        }
    }else if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
}


#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _isType == 0 ? _cellNewArrayModels.count : _cellHotArrayModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"HomeCollectionCell";
    
    BYC_HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    cell.model = _isType == 0 ? _cellNewArrayModels[indexPath.row] : _cellHotArrayModels[indexPath.row];
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader)
    {
        _header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        
        _imageV_Header = _header.imageV_BG;
        __weak __typeof(self) weakSelf = self;
        _header.headerButtonAction = ^(NSInteger flag){
        
            [weakSelf buttonAction:flag];
        };
        
        _header.array_VideoGroup = _array_VideoGroup;
        _header.model = _model;
        _header.array_Banner = _array_SecCover;
        return _header;
    }
    
    return nil;
}

//设置段头大小，竖着滚高有用，横着滚宽有用
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return _headerSize;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 通知中心
    NSNotification *notification = [NSNotification notificationWithName:@"hiddenTheButton" object:nil userInfo:@{@"1":@"1"}];
    [QNWSNotificationCenter postNotification:notification];
    
    WX_VoideDViewController *voideVC = [[WX_VoideDViewController alloc]init];
    voideVC.hidesBottomBarWhenPushed = YES;
    [voideVC receiveTheModelWith:_isType == 0 ? _cellNewArrayModels: _cellHotArrayModels WithNum:indexPath.row WithType:1];
    [self.navigationController pushViewController:voideVC animated:YES];
}

#pragma mark - UIScrollDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //获取偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    //centrView的frame
    if (_headerSize.height - offsetY - 64 <= 27)
        self.topHiddenView.hidden = NO;
    else self.topHiddenView.hidden = YES;
}

-(void)dealloc {

    _collectionView.delegate = nil;
}

@end
