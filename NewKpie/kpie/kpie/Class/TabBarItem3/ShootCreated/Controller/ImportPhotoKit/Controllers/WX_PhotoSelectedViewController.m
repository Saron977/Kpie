//
//  WX_PhotoSelectedViewController.m
//  Album
//
//  Created by 王傲擎 on 16/8/16.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_PhotoSelectedViewController.h"
#import "WX_PhotoKitCollectionViewCell.h"
#import <Photos/Photos.h>
#import "WX_UICollectionViewFlowLayout.h"
#import "NSDate+WX_TimeInterval.h"
#import "WX_ToolClass.h"
#import "WX_MediaInfoModel.h"
#import "WX_AlbumVideoEditingViewController.h"
#import "WX_ProgressHUD.h"
#import "WX_Authority.h"

#define SELECTEDNUM 7   /**<   设置选中数量 */
#define OBSERVERARRAYCOUNT  @"ObserverArrayCount"
#define OBSEVERDISPATH @"ObserverDispath"
@interface WX_PhotoSelectedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView              *collectionView_Custom;             /**<   自定义collectionview */

@property (nonatomic, strong) NSMutableArray                *array_PHFResult;                   /**<   获取数组模型_展示 */
@property (nonatomic, strong) NSMutableArray                *array_Selected;                    /**<   选中的模型 */

@property (nonatomic, assign) PhtotKitType                  photoKitType;                       /**<   设置获取类型 */


@property (nonatomic, strong) PHCachingImageManager         *manager_PHCache;                   /**<   图片视频管理 */
@property (nonatomic, assign) CGSize                        size_Tager;                         /**<   图片展示大小 */
@property (nonatomic, strong) NSFileManager                 *fileManager;                        /**<   文件管理 */

@property (nonatomic, strong) NSMutableArray                *array_Asset;                       /**<   传给下一界面数组 */
@property (nonatomic, assign) NSInteger                     num_Dispath;                        /**<   等待执行完毕,再执行( *2) */
@property (nonatomic, strong) WX_ToolClass                  *toolClass;                         /**<   工具类,用来监听 */

@end

@implementation WX_PhotoSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self createUI];
    
    [self observerAddOrRemove:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.array_Asset removeAllObjects];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

/// 创建监听
-(void)observerAddOrRemove:(BOOL)isAdd
{
    if (isAdd) {
        /// 创建监听
        self.toolClass = [[WX_ToolClass alloc]init];

        [self.toolClass addObserver:self forKeyPath:@"num_Dispath" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:OBSEVERDISPATH];
        
//        [self addObserver:self forKeyPath:@"array_Selected" options:NSKeyValueObservingOptionNew context:OBSERVERARRAYCOUNT];
    }else{
        /// 移除监听
        
        [self.toolClass removeObserver:self forKeyPath:@"num_Dispath" context:OBSEVERDISPATH];
        
//        [self removeObserver:self forKeyPath:@"array_Selected" context:OBSERVERARRAYCOUNT];

    }
}
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{

}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([(__bridge NSString*)context isEqualToString:OBSEVERDISPATH] && _array_Selected.count > 0) {
        if (self.toolClass.num_Dispath == _array_Selected.count) {
            [WX_ProgressHUD showSuccess:@"读取完成"];
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pushVideoEditingView) userInfo:nil repeats:NO];
            
        }else if(self.toolClass.num_Dispath > 0){
            QNWSLog(@"self.toolClass.num_Dispath == %zi",self.toolClass.num_Dispath);
            [self receiveAlbumFromAssetArrayWithNum:self.toolClass.num_Dispath];
        }
    }
}
/// 进入剪辑界面
-(void)pushVideoEditingView
{
    [WX_ProgressHUD dismiss];
    
    WX_AlbumVideoEditingViewController *albumVC = [[WX_AlbumVideoEditingViewController alloc]init];
    albumVC.assetArray = _array_Asset;
    [self.navigationController pushViewController:albumVC animated:YES];
}
/// 自定义 ui
-(void)createUI
{
    self.title = _photoKitType? @"视频":@"相片" ;
    self.view.backgroundColor = KUIColorFromRGB(0xf0f0f0);
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80,30)];
    [rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -0, 0, -40);
    [rightButton setTitleColor:KUIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [rightButton setTitleColor:KUIColorFromRGB(0x4bc8ba) forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(clickTheRigthButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;

    /// 自定义 collectionview
//    WX_UICollectionViewFlowLayout *layout_Custom = [[WX_UICollectionViewFlowLayout alloc]init];
//    layout_Custom.integer_MaximumSpacing = 5;
    UICollectionViewFlowLayout *layout_Custom = [[UICollectionViewFlowLayout alloc]init];
    layout_Custom.itemSize = CGSizeMake(70, 70);
    layout_Custom.minimumInteritemSpacing = 10;
    
    layout_Custom.minimumLineSpacing = 5;
    _collectionView_Custom = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout_Custom];
    _collectionView_Custom.backgroundColor = [UIColor clearColor];
    _collectionView_Custom.delegate = self;
    _collectionView_Custom.dataSource = self;
    [self.view addSubview:_collectionView_Custom];
    
    [_collectionView_Custom registerClass:[WX_PhotoKitCollectionViewCell class] forCellWithReuseIdentifier:@"WX_PhotoKitCollectionViewCell"];
    
    [_collectionView_Custom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KHeightNavigationBar);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    
}

/// 点击进行下一步
-(void)clickTheRigthButton
{
    
    if (_array_Selected.count == 0) {
        [self.view showAndHideHUDWithTitle:@"请选择视频" WithState:BYC_MBProgressHUDHideProgress];
    }else if(_array_Selected.count > 0 && _array_Selected.count <= SELECTEDNUM){
        switch (_photoKitType) {
            case ENUM_Photo:
            {
                //// 图片处理
                
            }
                break;
                
            case ENUM_Video:
            {
                [WX_ProgressHUD show:@"正在读取文件"];
                self.toolClass.num_Dispath = 0;
                //// 视频处理
                [self receiveAlbumFromAssetArrayWithNum:0];
            }
                break;
            default:
                break;
        }
    }else if(_array_Selected.count > SELECTEDNUM){
        [self.view showAndHideHUDWithTitle:@"最多不能超过7个视频哦" WithState:BYC_MBProgressHUDHideProgress];
    }
    
   

}

/// 初始化数组
-(void)arrayInitialize
{
    _array_PHFResult = [[NSMutableArray alloc]init];
    _array_Selected = [[NSMutableArray alloc]init];
    _array_Asset = [[NSMutableArray alloc]init];
}

/// 获取相关类型文件
-(void)parmsFromPhotoKitWith:(PhtotKitType)photoType
{
    
    _photoKitType = photoType;
    /// 初始化数组
    [self arrayInitialize];
    
    [WX_Authority WX_AuthorityPhotoDetection:^(BOOL authority) {
        if (authority) {
            /// 允许访问相册
            [self photoGetWith:photoType];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (status == PHAuthorizationStatusNotDetermined) {
//                
//                [self photoGetWith:photoType];
//            }
//            else if ([WX_ToolClass ConfirmedForPhotoAlbumPermissions]) {
//                /// 允许访问相册
//                [self photoGetWith:photoType];
//            }else{
//                /// 不许访问相册
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相册访问权限 \n可在设置中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//            }
//        });
//    }];
}

-(void)photoGetWith:(PhtotKitType)photoType
{
    
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    _manager_PHCache = [[PHCachingImageManager alloc] init];
    
    _size_Tager = CGSizeMake(150, 150);
    /// 根据需要类型,获取相关文件
    /// 相片文件___视频文件
    switch (photoType) {
        case ENUM_Photo:
        {
            PHFetchResult *result_AllAlbums = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
            if ([result_AllAlbums countOfAssetsWithMediaType:PHAssetMediaTypeImage] > 0) {
                NSRange range = NSMakeRange(0, result_AllAlbums.count);
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
                [result_AllAlbums enumerateObjectsAtIndexes:indexSet options:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if (obj) {
                        [_array_PHFResult addObject:obj];
                    }
                }];
            }
            [_collectionView_Custom reloadData];
        }
            break;
        case ENUM_Video:
        {
            PHFetchResult *result_AllAlbums = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:options];
            if ([result_AllAlbums countOfAssetsWithMediaType:PHAssetMediaTypeVideo] > 0) {
                NSRange range = NSMakeRange(0, result_AllAlbums.count);
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
                [result_AllAlbums enumerateObjectsAtIndexes:indexSet options:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if (obj) {
                        [_array_PHFResult addObject:obj];
                    }
                }];
            }
            [_collectionView_Custom reloadData];
        }
            break;
        default:
            break;
    }

}



#pragma mark  -------------- UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array_PHFResult.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WX_PhotoKitCollectionViewCell *cell = (WX_PhotoKitCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WX_PhotoKitCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = 1000 +indexPath.row;
    PHAsset *asset = _array_PHFResult[indexPath.row];
    [_manager_PHCache requestImageForAsset:asset
                                 targetSize:_size_Tager
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
//                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.img_Photo = result;
//                                  }
                              }];
    /// 获取类型
    [cell initCellTypeWithPhotoKitType:_photoKitType PHAsset:asset];
    
    cell.btn_Selected.tag = 900 +indexPath.row;
    [cell.btn_Selected addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
  
    BOOL isSelected = NO;
    /// 根据模型设置cell选中状态
    for (PHAsset *asset_Need in _array_Selected) {
        if (asset == asset_Need) {
            cell.btn_Selected.selected = YES;
            isSelected = YES;
        }
    }
    if (!isSelected) {
        cell.btn_Selected.selected = NO;
    }

    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

/// 设置选中状态
-(void)selected:(UIButton*)btn
{
    btn.selected = !btn.selected;
    NSInteger row = btn.tag - 900;
    PHAsset *asset = _array_PHFResult[row];
    BOOL isHave = NO;
    if (btn.selected) {
            /// 添加
        if(_array_Selected.count >= 7){
            [self.view showAndHideHUDWithTitle:@"最多不能超过7个视频哦" WithState:BYC_MBProgressHUDHideProgress];
            btn.selected = NO;
            
        }else{
            
            for (PHAsset *asset_Select in _array_Selected) {
                if (asset == asset_Select ) {
                    isHave = YES;
                }
            }
            if (!isHave) {
                [_array_Selected addObject:asset];
            }
        }
    }else{
        /// 移除
        for (PHAsset *asset_Select in _array_Selected) {
            if (asset == asset_Select ) {
                [_array_Selected removeObject:asset_Select];
                break;
            }
        }
        
    }
    
}

/// 把选中的复制到沙盒,并转化为模型, 用数组接受
-(void)receiveAlbumFromAssetArrayWithNum:(NSInteger)num
{
    PHAsset *asset_PH = _array_Selected[num];
    QNWSLog(@"第%zi个视频",num);
//    for (PHAsset *asset in _array_Selected) {
    
        WX_MediaInfoModel *model_Media = [[WX_MediaInfoModel alloc]init];
    [_manager_PHCache requestAVAssetForVideo:asset_PH options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [docArray objectAtIndex:0];
        NSString *mediaPath = [path stringByAppendingPathComponent:@"Cache"];
        self.fileManager = [NSFileManager defaultManager];
        [self.fileManager createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
        //            NSString *mediaTitle = [WX_ToolClass getDateWithType:0];
        // 存入沙盒
        AVURLAsset *asset_URL = (AVURLAsset*)asset;
        NSData *data_Media = [NSData dataWithContentsOfURL:asset_URL.URL];
        NSString *outputFielPath=[mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",[NSDate stringFromDate:asset_PH.creationDate],_photoKitType==0?@"JPEG":@"mp4"]];
        
        BOOL isWrite = [data_Media writeToFile:outputFielPath atomically:YES];
        if (isWrite) {
            
            QNWSLog(@"写入成功");
            model_Media.mediaPath = outputFielPath;
            model_Media.mediaTitle = [NSDate stringFromDate:asset_PH.creationDate];
            model_Media.DurationStr = [NSDate timeDescriptionOfTimeInterval:asset_PH.duration];
            model_Media.durationSecond = [NSDate timeDescriptionOfTimeIntervalForSecond:asset_PH.duration];
            model_Media.createDate = [NSDate stringFromDate:asset_PH.creationDate];
            model_Media.albumPath = outputFielPath;
            
            /// 获取缩略图
            [_manager_PHCache requestImageForAsset:asset_PH targetSize:_size_Tager contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                NSData *imgData = UIImagePNGRepresentation([UIImage imageWithCGImage:result.CGImage]);
                model_Media.imageDataStr = [imgData base64EncodedStringWithOptions:0];
                if (model_Media.mediaTitle.length > 0 && model_Media.imageDataStr.length >0) {
                    BOOL isHave = NO;
                    for ( WX_MediaInfoModel *model_Ready in _array_Asset) {
                        if (model_Ready == model_Media) {
                            isHave =YES;
                        }
                    }
                    if (!isHave) {
                        [_array_Asset addObject:model_Media];
                        [_manager_PHCache cancelImageRequest:0];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.toolClass.num_Dispath++;
                            QNWSLog(@"存储成功 self.toolClass.num_Dispath == %zi",self.toolClass.num_Dispath);
                        });
                    }else{
                        [_manager_PHCache cancelImageRequest:0];
                    }
                    
                }
                
            }];
        }else{
            QNWSLog(@"写入失败");
            [self.view showHUDWithTitle:@"文件读取失败" WithState:BYC_MBProgressHUDHideProgress];
            return ;
        }
    }];
        
        
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self observerAddOrRemove:NO];
    QNWSLog(@"%s 死了",__func__);
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
