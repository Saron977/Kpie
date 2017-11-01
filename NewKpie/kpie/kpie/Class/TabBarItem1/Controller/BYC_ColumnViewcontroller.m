//
//  BYC_ColumnViewcontroller.m
//  kpie
//
//  Created by 元朝 on 15/11/6.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_ColumnViewcontroller.h"
#import "BYC_HomeCollectionViewCell.h"
#import "BYC_HomeViewControllerModel.h"
#import "BYC_SetBackgroundColor.h"
#import "BYC_ColumnCollectionHeader.h"
#import "WX_MovieCViewController.h"
#import "BYC_TopHiddenView.h"
#import "BYC_ADModel.h"
#import "BYC_MTBannerModel.h"
#import "BYC_AccountTool.h"
#import "BYC_LoginAndRigesterView.h"
#import "UICollectionView+BYC_PlaceHolder.h"
#import "HL_JumpToVideoPlayVC.h"

#define BYC_ColumnCollectionHeaderLabelSize CGSizeMake(screenWidth - 16, 12)
#define CueWords @"暂无数据！"

@interface BYC_ColumnViewcontroller()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {

    BOOL _isNewWhetherMore;  //最新是否已经上拉加载更多加载完毕所有数据
    BOOL _isHotWhetherMore;  //最热是否已经上拉加载更多加载完毕所有数据
    CGPoint _isNewPoint;  //最新是否已经上拉加载更多加载完毕所有数据
    CGPoint _isHotPoint;  //最热是否已经上拉加载更多加载完毕所有数据
    
     UICollectionViewFlowLayout *_layout;
     CGSize _headerSize;
     UIImageView *_imageV_Header;
    BYC_TopHiddenView *_topView;
    BYC_ColumnCollectionHeader *_header;
    
    NSArray<BYC_MTBannerModel     *> *_array_SecCover;
}

@property (nonatomic, strong)  NSMutableArray  *cellNewArrayModels; //最新数据
@property (nonatomic, strong)  NSMutableArray  *cellHotArrayModels; //最热数据
@property (nonatomic, assign)  BOOL  isTeacher;

@property (nonatomic, assign)  int  isType; //最新标示:0:表示最新  1:表示最热 3未点评 2已点评
@property (weak, nonatomic  ) IBOutlet UICollectionView   *collectionView;

@property (strong, nonatomic) IBOutlet BYC_TopHiddenView *topHiddenView;

@end

@implementation BYC_ColumnViewcontroller

-(instancetype)init {

    if (self = [super init]) {
        
        [self loadView];
        
        // 设置背景色
        [[BYC_SetBackgroundColor alloc] setBackgroundViewColor:self];
        // 初始化子视图
        [self initViews];
        //不使用懒加载了，直接初始化所有数据,以免数据混乱
        [self initProperty];
        _isNewWhetherMore = NO;
        _isHotWhetherMore = NO;
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
        
        //数据下拉更新
        BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)[(weakSelf.isType == 0 || weakSelf.isType == 3 ) ? weakSelf.cellNewArrayModels:weakSelf.cellHotArrayModels firstObject];

        [weakSelf loadDataOnofftime:model.onofftime upType:@"0" videoId:model.videoid views:[NSString stringWithFormat:@"%ld",(long)model.views]];
    }];
    // 上拉更新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        //数据上拉更新
        BYC_HomeViewControllerModel *model = (BYC_HomeViewControllerModel *)[(weakSelf.isType == 0 || weakSelf.isType == 3 )? weakSelf.cellNewArrayModels:weakSelf.cellHotArrayModels lastObject];
        [weakSelf loadDataOnofftime:model.onofftime upType:@"1" videoId:model.videoid views:[NSString stringWithFormat:@"%ld",(long)model.views]];
    }];
}

- (void)initProperty {

    _cellHotArrayModels = [NSMutableArray array];
    _cellNewArrayModels = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if (![self.model.themename isEqualToString:@"" ]) self.isShowJoinInStepButton = YES;

}

-(void)clickJoinInStepAction:(UIButton *)btn
{
    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        btn.enabled = NO;
        
        WX_MovieCViewController *movieVC = [[WX_MovieCViewController alloc]init];
        
        movieVC.themeModel = [[WX_ThemeModel alloc]init];
        
        movieVC.themeModel.isAddTheme = YES;
        
        movieVC.themeModel.themeStr = self.model.themename;
        
        [self.navigationController pushViewController:movieVC animated:YES];
        
        [self performSelector:@selector(buttonAbled:) withObject:nil afterDelay:1.0f];
    }];
}

// 一秒内只能点击一次
-(void)buttonAbled:(UIButton *)btn
{
    btn.enabled = YES;
}


-(void)setIdModel:(id)idModel {
    
    BYC_OtherViewControllerModel  *model = [[BYC_OtherViewControllerModel alloc] init];
    model.columnid    = ((BYC_ADModel *)idModel).columnID;
    model.columnname  = ((BYC_ADModel *)idModel).columnName;
    model.secondcover = ((BYC_ADModel *)idModel).secondCover;
    model.columndesc  = ((BYC_ADModel *)idModel).columnDesc;
    model.themename   = ((BYC_ADModel *)idModel).theMeName;
    model.channelid   = ((BYC_ADModel *)idModel).channelID;
    
    self.model = model;
}

- (void)setModel:(BYC_OtherViewControllerModel *)model {

    _model = model;
    
    if ([_model.columnname isEqualToString:@"名师点评"]) {
        
        _isTeacher = YES;
        self.topHiddenView.commentsType = ENUM_CommentsTypeTeacher;
    }else {
        
        _isTeacher = NO;
        self.topHiddenView.commentsType = ENUM_CommentsTypeCustom;
    }
    
    self.title = _model.columnname;
    NSString *string = _model.columndesc;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(BYC_ColumnCollectionHeaderLabelSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

    _headerSize =  CGSizeMake(screenWidth, _headerSize.height + titleSize.height - BYC_ColumnCollectionHeaderLabelSize.height);
    //默认加载最新
    _isType = _isTeacher == YES ? 3 : 0;
    [self loadDataOnofftime:nil upType:nil videoId:nil views:nil];
}

- (void)buttonAction:(NSInteger)flag {
    
    self.topHiddenView.selectButton = flag;
    _header.selectButton = flag;
    switch (flag) {
        case 1://最新
            _isHotPoint = self.collectionView.contentOffset;
            _isType = _isTeacher == YES ? 3 : 0;
            
            if (_cellNewArrayModels.count == 0)[self loadDataOnofftime:nil upType:nil videoId:nil views:nil];
            if (!_isNewWhetherMore)[_collectionView.footer resetNoMoreData];
            break;
        case 2://最热
            _isNewPoint = self.collectionView.contentOffset;
            _isType = _isTeacher == YES ? 2 : 1;
            if (_cellHotArrayModels.count == 0) [self loadDataOnofftime:nil upType:nil videoId:nil views:nil];
            if (!_isHotWhetherMore) [_collectionView.footer resetNoMoreData];

            break;
            
        default:
            break;
    }
    
    [_collectionView reloadData];
}

/**
 *  网络请求
 *
 *  @param onofftime 上下架时间
 *  @param type      0 最新（默认）  1 最热
 *  @param upType    0 下拉  1 上拉
 *  @param videoId   视频编号（上、下拉时需带上）
 *  @param views     点击量（上、下拉时需带上）
 */
- (void)loadDataOnofftime:(NSString *)onofftime upType:(NSString *)upType videoId:(NSString *)videoId views:(NSString *)views {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    QNWSDictionarySetObjectForKey(dic, [NSNumber numberWithInteger:_isType], @"type")
    QNWSDictionarySetObjectForKey(dic, _model.columnid, @"columnid")
    if (onofftime) QNWSDictionarySetObjectForKey(dic, onofftime, @"onofftime")
    if (upType) QNWSDictionarySetObjectForKey(dic, upType, @"upType")
    if (videoId) QNWSDictionarySetObjectForKey(dic, videoId, @"videoId")
    if (views) QNWSDictionarySetObjectForKey(dic, views, @"views")
    
    [self requestDataWithParameters:dic type:(_isType == 0 || _isType == 3 )? 0 : 1];
}

#pragma mark - 网络请求
//涉及到快速切换，所以部分代码不复用。
- (void)requestDataWithParameters:(NSDictionary *)parameters type:(NSInteger)integer{

    QNWSLog(@"parameters == %@",parameters);
    
    __block BOOL isRepeat = NO;//NO 没有重复 YES 有重复
    if (integer == 0) {//最新
        
        [self requestResponseObject:parameters success:^(NSArray *array_Data) {
            
            //cell数据
            NSMutableArray *bodyArrayModels = [NSMutableArray array];
            if (array_Data.count > 0) {
            
                if (self.collectionView.footer.isRefreshing || self.collectionView.header.isRefreshing) {
                    for (BYC_HomeViewControllerModel *model in array_Data) {
                    
                        for (BYC_HomeViewControllerModel *CellModel in _cellNewArrayModels)
                            if ([CellModel.videoid isEqualToString:model.videoid]) isRepeat = YES;
                        if (!isRepeat) [bodyArrayModels addObject:model];
                    }
                }else bodyArrayModels = [array_Data mutableCopy];
                {//数据处理
                    
                    if (self.collectionView.footer.isRefreshing) {
                        
                        [ self.cellNewArrayModels addObjectsFromArray:bodyArrayModels];
                        
                        // 变为没有更多数据的状态
                        if (bodyArrayModels.count == 0) [self.collectionView.footer endRefreshingWithNoMoreData];
                            else [self.collectionView.footer endRefreshing];// 结束刷新
                    }else {

                        if (self.collectionView.header.isRefreshing) {
                            
                            NSMutableArray *mmArray = self.cellNewArrayModels;
                            self.cellNewArrayModels = [bodyArrayModels mutableCopy];
                            [self.cellNewArrayModels addObjectsFromArray:mmArray];
                            // 结束刷新
                            [self.collectionView.header endRefreshing];
                        } else
                            self.cellNewArrayModels = bodyArrayModels;
                    }
                }
            }else {
                
                if (self.collectionView.footer.isRefreshing) {
                    
                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isNewWhetherMore = YES;
                }else {
                    
                    if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
                    if (!self.collectionView.header.isRefreshing && !self.collectionView.footer.isRefreshing)
                      [self.cellNewArrayModels removeAllObjects];
                }
            }

            [self reloadCollection];
        } failure:^(NSError *error) {
            
            if (self.collectionView.footer.isRefreshing) {
                // 变为没有更多数据的状态
                if (_isNewWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                else [self.collectionView.footer endRefreshing];
            }
            if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];

        }];
        
    }else if (integer == 1) {
    
        [self requestResponseObject:parameters success:^(NSArray *array_Data) {
           
            //cell数据
            NSMutableArray *bodyArrayModels = [NSMutableArray array];
            if (array_Data.count > 0) {
                
                if (self.collectionView.footer.isRefreshing || self.collectionView.header.isRefreshing) {
                    for (BYC_HomeViewControllerModel *model in array_Data) {
                    
                        for (BYC_HomeViewControllerModel *CellModel in _cellHotArrayModels)
                            if ([CellModel.videoid isEqualToString:model.videoid]) isRepeat = YES;
                        if (!isRepeat) [bodyArrayModels addObject:model];
                    }
                }else bodyArrayModels = [array_Data mutableCopy];
                {//数据处理
                    
                    if (self.collectionView.footer.isRefreshing) {
                        
                        
                        
                        [self.cellHotArrayModels addObjectsFromArray:bodyArrayModels];
                        // 变为没有更多数据的状态
                        if (bodyArrayModels.count == 0) [self.collectionView.footer endRefreshingWithNoMoreData];
                        else [self.collectionView.footer endRefreshing];// 结束刷新
                        
                        QNWSLog(@"上拉 = %lu",(unsigned long)self.cellHotArrayModels.count);
                        
                    }else {

                        if (self.collectionView.header.isRefreshing) {
                            
                            NSMutableArray *mmArray = self.cellHotArrayModels;
                            self.cellHotArrayModels = [bodyArrayModels mutableCopy];
                            [self.cellHotArrayModels addObjectsFromArray:mmArray];
                            // 结束刷新
                            [self.collectionView.header endRefreshing];
                        }else {
                        
                            self.cellHotArrayModels = bodyArrayModels;
                            QNWSLog(@"点击 = %lu",(unsigned long)self.cellHotArrayModels.count);
                        }
                    }
                }
            }else {
            
                if (self.collectionView.footer.isRefreshing) {

                    // 变为没有更多数据的状态
                    [self.collectionView.footer endRefreshingWithNoMoreData];
                    _isHotWhetherMore = YES;
                }else {
                    
                    if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
                    if (!self.collectionView.header.isRefreshing && !self.collectionView.footer.isRefreshing)
                        [self.cellHotArrayModels removeAllObjects];
                }
            }
            [self reloadCollection];
        } failure:^(NSError *error) {
            
            if (self.collectionView.footer.isRefreshing) {

                // 变为没有更多数据的状态
                if (_isHotWhetherMore) [self.collectionView.footer endRefreshingWithNoMoreData];
                else [self.collectionView.footer endRefreshing];
            }
            if (self.collectionView.header.isRefreshing) [self.collectionView.header endRefreshing];
            
        }];
    }
}

/** 数据处理 */
- (void)resultDataProcessing:(NSMutableArray *)mArray toMarrayWithIndex:(NSInteger)integer{
    
    if (self.collectionView.footer.isRefreshing) {
        
        [integer == 0 ? self.cellNewArrayModels:self.cellHotArrayModels addObjectsFromArray:mArray];

        if (mArray.count == 0) {
            // 变为没有更多数据的状态
            [self.collectionView.footer endRefreshingWithNoMoreData];
        }else {
            
            // 结束刷新
            [self.collectionView.footer endRefreshing];
        }
        
    }else {


        if (self.collectionView.header.isRefreshing) {
            
            
            NSMutableArray *mmArray = integer == 0 ? self.cellNewArrayModels:self.cellHotArrayModels;
            if (integer == 0) {
                
                self.cellNewArrayModels = [mArray mutableCopy];
            }
            
            if (integer == 1) {
                
                self.cellHotArrayModels = [mArray mutableCopy];
            }
            [integer == 0 ? self.cellNewArrayModels:self.cellHotArrayModels addObjectsFromArray:mmArray];
            
            // 结束刷新
            [self.collectionView.header endRefreshing];
        }
        
        if (!self.collectionView.header.isRefreshing && !self.collectionView.footer.isRefreshing) {
        
            if (integer == 0) {
                
                self.cellNewArrayModels = mArray;
            }
            
            if (integer == 1) {
                
                 self.cellHotArrayModels = mArray;
            }
    }
    
    }
}

/**
 *  视频数据通用请求方法
 *
 *  @param dicParameters 请求参数
 *  @param success       成功回调
 */
- (void)requestResponseObject:(NSDictionary *)dicParameters success:(void (^)(NSArray *array_Data))success failure:(void (^)(NSError *error))failure{
    
    [BYC_HttpServers Get:KQNWS_GetColumnAllJsonArrayListVideoUrl parameters:dicParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array_Data = [BYC_HomeViewControllerModel initModelsWithArray:responseObject[@"video"]];
        _array_SecCover   = [BYC_MTBannerModel initModelsWithArray:responseObject[@"secCover"]];
        return success(array_Data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view showAndHideHUDWithTitle:error.userInfo[@"NSLocalizedDescription"] WithState:BYC_MBProgressHUDHideProgress];
        failure(error);
    }];
}

- (void)reloadCollection {
    
    [_collectionView byc_reloadData:CueWords frame:CGRectMake(0, screenHeight / 2.0f - KHeightNavigationBar , CGRectGetWidth(_collectionView.frame), screenHeight / 2.0f)];
}

#pragma mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (_isType == 0 || _isType == 3 )? _cellNewArrayModels.count : _cellHotArrayModels.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"HomeCollectionCell";
    
    BYC_HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    cell.model = (_isType == 0 || _isType == 3 )? _cellNewArrayModels[indexPath.row] : _cellHotArrayModels[indexPath.row];
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
        _header.model = _model;
        if (_array_SecCover.count > 0) _header.array_Banner = _array_SecCover;
        else _header.model = _model;
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
    BYC_HomeViewControllerModel *model = (_isType == 0 || _isType == 3 )? _cellNewArrayModels[indexPath.row]:_cellNewArrayModels[indexPath.row];
    [HL_JumpToVideoPlayVC jumpToVCWithModel:model andVideoTepy:model.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
}

#pragma mark - UIScrollDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //获取偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    //centrView的frame
    if (_headerSize.height - offsetY - 64 <= 27) self.topHiddenView.hidden = NO;
    else self.topHiddenView.hidden = YES;
    
}

-(void)dealloc {

    _collectionView.delegate = nil;
}

@end
