
/*
 CTAssetsPickerController.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */


#import "CTAssetsPickerController.h"
#import "NSDate+TimeInterval.h"
#import "BYC_SetBackgroundColor.h"
#import "WX_AlbumModel.h"
#import "WX_AlbumVideoEditingViewController.h"
#import "WX_AlbumViewController.h"

#define IS_IOS7             ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define kThumbnailLength    70.0f
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define kPopoverContentSize CGSizeMake(320, 480)


#pragma mark - Interfaces

@interface CTAssetsPickerController ()

@end


@interface CTAssetsGroupViewController : UITableViewController

@end


@interface CTAssetsGroupViewController()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSString  *assetsLibrartType;


@end


@interface CTAssetsViewController : UICollectionViewController

@property (nonatomic, strong) ALAssetsGroup     *assetsGroup;
@property (nonatomic, strong) NSMutableArray    *photoPathArray;    /**<   视频路径 */
@property (nonatomic, strong) WX_AlbumModel     *albumModel;        /**<   视频相册数组 */
@property (nonatomic, assign) BOOL              isTransformFinish;  /**<   是否转换完成 */
@property (nonatomic, strong) UIView            *backView;          /**<   屏幕遮罩 */
@property (nonatomic, strong) NSMutableArray    *imgInfoArray;      /**<   图片宽高旋转角度信息数组 */

@end

@interface CTAssetsViewController ()

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;


@end


@interface CTAssetsGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup *)assetsGroup WithAlassetLibraryType:(NSString *)alassetLibraryType;

@end

@interface CTAssetsGroupViewCell ()

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;

@end


@interface CTAssetsViewCell : UICollectionViewCell

- (void)bind:(ALAsset *)asset;

@end

@interface CTAssetsViewCell ()

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *videoImage;

@end


@interface CTAssetsSupplementaryView : UICollectionReusableView

@property (nonatomic, strong) UILabel *sectionLabel;

- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideos;

@end


@interface CTAssetsSupplementaryView ()

@end






#pragma mark - CTAssetsPickerController


@implementation CTAssetsPickerController
@dynamic delegate;
- (id)init
{
    CTAssetsGroupViewController *groupViewController = [[CTAssetsGroupViewController alloc] init];
    
    if (self = [super initWithRootViewController:groupViewController])
    {
        _maximumNumberOfSelection   = NSIntegerMax;
        _assetsFilter               = [ALAssetsFilter allAssets];
        _showsCancelButton          = YES;
        
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
//            [self setContentSizeForViewInPopover:kPopoverContentSize];
            self.preferredContentSize = kPopoverContentSize;

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    QNWSLog(@" %@ 死了 ",self.class);
}

@end




#pragma mark - CTAssetsGroupViewController

@implementation CTAssetsGroupViewController


- (id)init
{
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
//            [self setContentSizeForViewInPopover:kPopoverContentSize];
            
        self.preferredContentSize = kPopoverContentSize;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
    [self localize];
    [self setupGroup];
}


#pragma mark - Setup

- (void)setupViews
{
    [[BYC_SetBackgroundColor alloc] setBackgroundViewColor:self];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = kThumbnailLength + 12;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupButtons
{
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    
    if (picker.showsCancelButton)
    {
        
//        self.navigationItem.leftBarButtonItem =
//        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
//                                         style:UIBarButtonItemStylePlain
//                                        target:self
//                                        action:@selector(dismiss:)];
//        self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"icon-back-n"];
//        
//        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 55, 44);
        [backBtn setTitle:@"取消" forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [backBtn setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
        [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        [backBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = item;

        
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    }
}

- (void)localize
{
     CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    
    
    if (picker.assetsLibraryType == AllVideosType) {
        
        self.title = NSLocalizedString(@"选择视频", nil);
        self.assetsLibrartType = @"AllVideosType";
    }else if(picker.assetsLibraryType == AllPhotosType){
        self.title = NSLocalizedString(@"选择相片", nil);
        self.assetsLibrartType = @"AllPhotosType";
    }
    
    
}

- (void)setupGroup
{
    if (!self.assetsLibrary)
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    
    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];
    
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    ALAssetsFilter *assetsFilter = picker.assetsFilter;
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group)
        {
            [group setAssetsFilter:assetsFilter];
            
            if (group.numberOfAssets > 0)
                [self.groups addObject:group];
            
        }
        else
        {
            [self reloadData];
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        [self showNotAllowed];

    };
    
    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];

    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}


#pragma mark - Reload Data

- (void)reloadData
{
    if (self.groups.count == 0)
        [self showNoAssets];
    
    [self.tableView reloadData];
}


#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


#pragma mark - Not allowed / No assets

- (void)showNotAllowed
{
    self.title              = nil;
    
    UIView *lockedView      = [[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *locked     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CTAssetsPickerLocked"]];
    
    
    CGRect rect             = CGRectInset(self.view.bounds, 8, 8);
    UILabel *title          = [[UILabel alloc] initWithFrame:rect];
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    
    title.text              = NSLocalizedString(@"没有权限", nil);
    title.font              = [UIFont boldSystemFontOfSize:17.0];
    title.textColor         = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"禁止访问相册,您可以在设置中重新开启", nil);
    message.font            = [UIFont systemFontOfSize:14.0];
    message.textColor       = [UIColor colorWithRed:129.0/255.0 green:136.0/255.0 blue:148.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    lockedView.backgroundColor = [UIColor clearColor];
    
    locked.center           = CGPointMake(lockedView.center.x, lockedView.center.y - 40);
    title.center            = locked.center;
    message.center          = locked.center;
    
    rect                    = title.frame;
    rect.origin.y           = locked.frame.origin.y + locked.frame.size.height + 20;
    title.frame             = rect;
    
    rect                    = message.frame;
    rect.origin.y           = title.frame.origin.y + title.frame.size.height + 10;
    message.frame           = rect;
    
    [lockedView addSubview:locked];
    [lockedView addSubview:title];
    [lockedView addSubview:message];
    
    self.tableView.tableHeaderView  = lockedView;
    self.tableView.scrollEnabled    = NO;
}

- (void)showNoAssets
{
    UIView *noAssetsView    = [[UIView alloc] initWithFrame:self.view.bounds];

    CGRect rect             = CGRectInset(self.view.bounds, 10, 10);
    UILabel *title          = [[UILabel alloc] initWithFrame:rect];
    UILabel *message        = [[UILabel alloc] initWithFrame:rect];
    
    title.text              = NSLocalizedString(@"没有视频媒体文件可供选择", nil);
    title.font              = [UIFont systemFontOfSize:26.0];
    title.textColor         = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    title.textAlignment     = NSTextAlignmentCenter;
    title.numberOfLines     = 5;
    
    message.text            = NSLocalizedString(@"", nil);
    message.font            = [UIFont systemFontOfSize:18.0];
    message.textColor       = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    message.textAlignment   = NSTextAlignmentCenter;
    message.numberOfLines   = 5;
    
    [title sizeToFit];
    [message sizeToFit];
    
    title.center            = CGPointMake(noAssetsView.center.x, noAssetsView.center.y - 10 - title.frame.size.height / 2);
    message.center          = CGPointMake(noAssetsView.center.x, noAssetsView.center.y + 10 + message.frame.size.height / 2);

    noAssetsView.backgroundColor = [UIColor clearColor];
    
    [noAssetsView addSubview:title];
    [noAssetsView addSubview:message];
    
    self.tableView.tableHeaderView  = noAssetsView;
    self.tableView.scrollEnabled    = NO;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    CTAssetsGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CTAssetsGroupViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    [cell bind:[self.groups objectAtIndex:indexPath.row]WithAlassetLibraryType:self.assetsLibrartType];

    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kThumbnailLength + 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsViewController *vc = [[CTAssetsViewController alloc] init];
    vc.assetsGroup = [self.groups objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)dismiss:(id)sender
{
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    
    if ([picker.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)])
        [picker.delegate assetsPickerControllerDidCancel:picker];
    
    [WX_ProgressHUD dismiss];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)dealloc
{
    QNWSLog(@" %@ 死了 ",self.class);
}

@end



#pragma mark - CTAssetsGroupViewCell

@implementation CTAssetsGroupViewCell


- (void)bind:(ALAssetsGroup *)assetsGroup WithAlassetLibraryType:(NSString *)alassetLibraryType
{
//    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;

    self.assetsGroup            = assetsGroup;
    
    CGImageRef posterImage      = assetsGroup.posterImage;
    size_t height               = CGImageGetHeight(posterImage);
    float scale                 = height / kThumbnailLength;
    
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
//    self.textLabel.text         = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if ([alassetLibraryType isEqualToString:@"AllVideosType"]) {
        self.textLabel.text = @"视频文件";
        self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld个视频可供选择", (long)[assetsGroup numberOfAssets]];
        
    }else if ([alassetLibraryType isEqualToString:@"AllPhotosType"]){
        self.textLabel.text = @"相册";
        self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld个相片可供选择", (long)[assetsGroup numberOfAssets]];
    }
    self.textLabel.textColor = KUIColorFromRGB(0x3c4f5e);
    self.detailTextLabel.textColor = KUIColorFromRGB(0x3c4f5e);
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;

}

- (NSString *)accessibilityLabel
{
    NSString *label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    return [label stringByAppendingFormat:NSLocalizedString(@"%d Photos", nil), [self.assetsGroup numberOfAssets]];
}

@end




#pragma mark - CTAssetsViewController

#define kAssetsViewCellIdentifier           @"AssetsViewCellIdentifier"
#define kAssetsSupplementaryViewIdentifier  @"AssetsSupplementaryViewIdentifier"

@implementation CTAssetsViewController

- (id)init
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = kThumbnailSize;
    layout.sectionInset                 = UIEdgeInsetsMake(9.0, 0, 0, 0);
    layout.minimumInteritemSpacing      = 2.5;
    layout.minimumLineSpacing           = 5;
    layout.footerReferenceSize          = CGSizeMake(0, 44.0);
    
    if (self = [super initWithCollectionViewLayout:layout])
    {

        self.collectionView.allowsMultipleSelection = YES;
        
        self.collectionView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        
        [self.collectionView registerClass:[CTAssetsViewCell class]
                forCellWithReuseIdentifier:kAssetsViewCellIdentifier];
        
        [self.collectionView registerClass:[CTAssetsSupplementaryView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:kAssetsSupplementaryViewIdentifier];
        
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
//            [self setContentSizeForViewInPopover:kPopoverContentSize];
            self.preferredContentSize = kPopoverContentSize;

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupAssets];
    

}



#pragma mark - Setup

- (void)setupViews
{
    
    [[BYC_SetBackgroundColor alloc] setBackgroundViewColor:self];
    self.collectionView.backgroundColor = KUIColorFromRGB(0xf0f0f0);
}

- (void)setupButtons
{

    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(finishPickingAssets:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
   
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
     backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorFromRGB(0x4BC8BD) forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(returnLastView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)setupAssets
{
//    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    if (picker.assetsLibraryType == AllVideosType) {
        self.title = @"视频文件";

    }else if(picker.assetsLibraryType == AllPhotosType){
        self.title = @"相片文件";

    }
    
    
    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {

        if (asset)
        {
            [self.assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos ++;
        }
        
        else if (self.assets.count > 0)
        {
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count-1 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionTop
                                                animated:YES];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}


#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = kAssetsViewCellIdentifier;
    
    CTAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    [cell bind:[self.assets objectAtIndex:indexPath.row]];

    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *viewIdentifiert = kAssetsSupplementaryViewIdentifier;
    
    CTAssetsSupplementaryView *view =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:viewIdentifiert forIndexPath:indexPath];
    
    [view setNumberOfPhotos:self.numberOfPhotos numberOfVideos:self.numberOfVideos];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}


//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 5, 0, 5);
//}

#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsPickerController *vc = (CTAssetsPickerController *)self.navigationController;
    
    return ([collectionView indexPathsForSelectedItems].count < vc.maximumNumberOfSelection);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

//wekuolaobei

#pragma mark - Title

- (void)setTitleWithSelectedIndexPaths:(NSArray *)indexPaths
{
    // Reset title to group name
    if (indexPaths.count == 0)
    {
//        self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
        if (picker.assetsLibraryType == AllVideosType ) {
            
            self.title = @"视频文件";
        }else if(picker.assetsLibraryType == AllPhotosType){
            self.title = @"相片文件";
        }
        return;
    }
    
    BOOL photosSelected = NO;
    BOOL videoSelected  = NO;
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        ALAsset *asset = [self.assets objectAtIndex:indexPath.item];
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
            photosSelected  = YES;
        
        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            videoSelected   = YES;
        
        if (photosSelected && videoSelected)
            break;
    }
    
    NSString *format;
    
    if (photosSelected && videoSelected)
        format = NSLocalizedString(@"%d Items Selected", nil);
    
    else if (photosSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"%d 个相片", nil) : NSLocalizedString(@"%d 个相片", nil);

    else if (videoSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"%d 个视频文件", nil) : NSLocalizedString(@"%d 个视频文件", nil);
    
    self.title = [NSString stringWithFormat:format, indexPaths.count];
    
    
}


#pragma mark - Actions

- (void)finishPickingAssets:(id)sender
{
    
//    [WX_ProgressHUD show:@"正在转码"];
    
    
    QNWSLog(@"self == %@",self);
    
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems)
    {
        [assets addObject:[self.assets objectAtIndex:indexPath.item]];
    }
    CTAssetsPickerController *picker = (CTAssetsPickerController *)self.navigationController;
    if (picker.assetsLibraryType == AllVideosType) {
        
        if (assets.count > 0) {
            WX_AlbumVideoEditingViewController *albumVC = [[WX_AlbumVideoEditingViewController alloc]init];
            albumVC.assetArray = assets;
            
            [self.navigationController pushViewController:albumVC animated:YES];
            
        }else{
            [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
            
        }
    }else if (picker.assetsLibraryType == AllPhotosType){
#pragma mark -------- 添加ffmpeg 接口 转换视频
        // 把转换后的文件 添加到 WX_AlbumModel 模型中去
        // 再传到 WX_AlbumViewController 中
        
        _albumModel = [[WX_AlbumModel alloc]init];
        
        _photoPathArray = [[NSMutableArray alloc]init];
        
        
        
        if (assets.count < 3 || assets.count >12) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"照片数选在3到12张以内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
        }else if (assets.count >= 3 && assets.count <= 12) {
            
            //// 4 只支持3张图片 转换
            if (KCurrentDeviceIsIphone4) {
                
                if (assets.count != 3) {
                    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"您的设备仅支持3张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alter show];
                }else{
                    [self actionAlbumWithAssets:assets];
                }
                
            }else if (KCurrentDeviceIsIphone5){
                
                [self actionAlbumWithAssets:assets];

                
            }else if (KCurrentDeviceIsIphone6){
                
                
                [self actionAlbumWithAssets:assets];

            }else if (KCurrentDeviceIsIphone6p){
                
                [self actionAlbumWithAssets:assets];

            }
        }else{
            [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
            
        }
    }

    
}

-(void)actionAlbumWithAssets:(NSMutableArray*)assets
{
    
    if (!self.backView) {
        
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.backView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.backView];
    }else{
        self.backView.hidden = NO;
    }
    
    [self movePhotoFromAlbumToSanBoxWithAlbumArray:assets];
    
    [self createAlbumWithFFMPEGWithPhotoPath:_photoPathArray AlbumModel:_albumModel];

}

-(void)movePhotoFromAlbumToSanBoxWithAlbumArray:(NSMutableArray *)assetArray
{
    self.imgInfoArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < assetArray.count; i++) {
        NSMutableArray *imgInfoArray = [[NSMutableArray alloc]init];
        
        ALAsset *asset = assetArray[i];
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte *)malloc((long)(long)rep.size);
        NSInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(long)(long)rep.size error:nil];
        NSData *mediaData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        
        UIImage *img = [UIImage imageWithData:mediaData];
        
        //  获取图片旋转信息
        //  imageOrientation  枚举信息
        //  UIImageOrientationUp,              0  - 1              // default orientation
        //  UIImageOrientationDown,            1  - 2              // 180 deg rotation
        //  UIImageOrientationLeft,            2  - 0              // 90 deg CCW
        //  UIImageOrientationRight,           3  - 3 Or 4         // 90 deg CW
        //  UIImageOrientationUpMirrored,      4  - 1              // as above but image mirrored along other axis. horizontal flip
        //  UIImageOrientationDownMirrored,    5  - 2              // horizontal flip
        //  UIImageOrientationLeftMirrored,    6  - 0              // vertical flip
        //  UIImageOrientationRightMirrored,   7  - 3 Or 4         // vertical flip

       // 数组信息 * 旋转角度：0不旋转，1顺时针90，2逆时针90，3顺时针180，4逆时针180
        
        switch (img.imageOrientation) {
            case UIImageOrientationUp:
                [imgInfoArray addObject:[NSNumber numberWithInteger:0]];
                break;
            case UIImageOrientationDown:
                [imgInfoArray addObject:[NSNumber numberWithInteger:3]];
                break;
            case UIImageOrientationLeft:
                [imgInfoArray addObject:[NSNumber numberWithInteger:2]];
                break;
            case UIImageOrientationRight:
                [imgInfoArray addObject:[NSNumber numberWithInteger:1]];
                break;
            case UIImageOrientationUpMirrored:
                [imgInfoArray addObject:[NSNumber numberWithInteger:0]];
                break;
            case UIImageOrientationDownMirrored:
                [imgInfoArray addObject:[NSNumber numberWithInteger:3]];
                break;
            case UIImageOrientationLeftMirrored:
                [imgInfoArray addObject:[NSNumber numberWithInteger:2]];
                break;
            case UIImageOrientationRightMirrored:
                [imgInfoArray addObject:[NSNumber numberWithInteger:1]];
                break;
                
            default:
                [imgInfoArray addObject:[NSNumber numberWithInteger:0]];
                break;
        }
        
        /// 获取图片宽高信息 长  ___ 宽
        
        [imgInfoArray addObject:[NSNumber numberWithInteger:img.size.height]];
        [imgInfoArray addObject:[NSNumber numberWithInteger:img.size.width]];
        
        QNWSLog(@"图片宽高信息 imgInfoArray == %@",imgInfoArray);
        
        NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [docArray objectAtIndex:0];
        NSString *mediaPath = [path stringByAppendingPathComponent:@"Cache"];
//        self.albumPath = mediaPath;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSArray *array = [[NSString stringWithFormat:@"%@.JPG",[asset valueForProperty:ALAssetPropertyDate]] componentsSeparatedByString:@"+"];
        NSString *mediaTitle = [array firstObject];
        mediaTitle = [mediaTitle stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        
        // 存入沙盒
        mediaTitle = [mediaTitle substringToIndex:mediaTitle.length -1];
        
        
        NSString *outputFielPath=[mediaPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.JPG",mediaTitle]];
        QNWSLog(@"存入沙盒 == %@",outputFielPath);
        
        
        [mediaData writeToFile:outputFielPath atomically:YES];
        
        [self.imgInfoArray addObject:imgInfoArray];
        
        
        
        
        [_photoPathArray addObject:outputFielPath];
    }
}

-(void)createAlbumWithFFMPEGWithPhotoPath:(NSMutableArray*)photosArray AlbumModel:(WX_AlbumModel*)albumModel
{
    [WX_ProgressHUD show:@"正在转码"];
    self.isTransformFinish = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    QNWSLog(@"self.imgInfoArray == %@",self.imgInfoArray);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
#if KSimulatorRun
        ffmpegutils *ffmpeg = [ffmpegutils new];
        ffmpeg.isDebug=YES;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *outPath = [paths objectAtIndex:0];//Documents目录
        NSString *logPath = [outPath stringByAppendingPathComponent:@"log.txt"];
        
        NSString *concatFilePath = [outPath stringByAppendingString:@"/concat.txt"];
        QNWSLog(@"concatFilePath=%@", concatFilePath);
        char *clog = (char*)alloca(1024);
        strcpy(clog, [logPath cStringUsingEncoding:NSUTF8StringEncoding]);
        
        ffmpeg.logPath=clog;
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
        NSString *createDateStr = [dateFormatter stringFromDate:currentDate];
        NSString *albumOutPath = [outPath stringByAppendingPathComponent:@"Media"];
        NSFileManager *ffFilemanager = [NSFileManager defaultManager];
        [ffFilemanager createDirectoryAtPath:albumOutPath withIntermediateDirectories:YES attributes:nil error:nil];
        albumOutPath = [albumOutPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",createDateStr]];
        NSString *AACPath = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"aac"];

        _albumModel.albumTitle = createDateStr;

//        NSString *AACPath = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"photo.aac"];
     
        int result = [ffmpeg createVideoByPhotoPath:photosArray WithCount:[NSNumber numberWithInteger:photosArray.count] AndOutPath:albumOutPath AndAACPath:AACPath WithSize:self.imgInfoArray];
        
       
        if (!result) {
            
            /// 获取视频缩略图
            NSURL *outUrl = [NSURL fileURLWithPath:albumOutPath];
            AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:outUrl];
            NSString *encodeImgStr = [self creatThumbWith:item.asset];
            _albumModel.imageDataStr = encodeImgStr;
            NSString *duration;
            if (self.albumModel.videoDuration < 10) {
                duration = [NSString stringWithFormat:@"0:0%zi",self.albumModel.videoDuration];
            }else{
                duration = [NSString stringWithFormat:@"0:%zi",self.albumModel.videoDuration];
            }
            WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];
            if (![manager.dataBase executeUpdate:@"insert into KPieMedia(title,duration,createdDate,imageData,mediaPath,albumPath) values(?,?,?,?,?,?)",_albumModel.albumTitle,duration,createDateStr,_albumModel.imageDataStr,albumOutPath,albumOutPath]) {
                QNWSLog(@"视频拍摄数据库信息----- 插入失败");
            }
            
            
            QNWSLog(@"视频编辑成功");
            self.isTransformFinish = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                /// 通知主线程刷新
                [self addObserver:self forKeyPath:@"isTransformFinish" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
            });

        }else{
            dispatch_async(dispatch_get_main_queue(), ^{

            [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(transFailShow) userInfo:nil repeats:NO];
            });

        }
        
#endif
    });
}

#pragma mark ---------- KVO
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if ([keyPath isEqualToString:@"isTransformFinish"]) {
        if (self.isTransformFinish) {
            
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            [WX_ProgressHUD showSuccess:@"转换成功"];
            
            [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(transSuccess) userInfo:nil repeats:NO];

        }
    }
}



-(NSString *)creatThumbWith:(AVAsset *)asset
{
    // 获取截图
    //        AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
#if 1
    UIGraphicsPopContext();
    AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
    imgGenerator.appliesPreferredTrackTransform = YES;
    imgGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    NSInteger videoTime =(int)asset.duration.value / asset.duration.timescale;
    self.albumModel.videoDuration = videoTime;
    
    QNWSLog(@"视频时长 ==  %zi ",videoTime);
    
    CFTimeInterval thumbnailImageTime = 2;
    NSError *thumbnailImageError = nil;
    CGImageRef thumbnailImageRef = nil;
    thumbnailImageRef = [imgGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 10) actualTime:nil error:&thumbnailImageError];
    UIImage *image = [UIImage imageWithCGImage:thumbnailImageRef];
    
    CGImageRelease(thumbnailImageRef);
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(image);
    NSString *encodeImgStr = [imgData base64EncodedStringWithOptions:0];
    
    if (!thumbnailImageRef) {
        QNWSLog(@"图片为空");
        QNWSLog(@"thumbnailImageError == %@",thumbnailImageError.localizedDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [WX_ProgressHUD show:@"转换失败"];
            
            [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(transFail) userInfo:nil repeats:NO];
        });

    }
    return encodeImgStr;
#else
    UIGraphicsPopContext();
    AVAssetImageGenerator *imgGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    
    imgGenerator.appliesPreferredTrackTransform = YES;
    imgGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    NSInteger videoTime = asset.duration.value / asset.duration.timescale;
    QNWSLog(@"视频时长 ==  %zi",videoTime);
    
    CFTimeInterval thumbnailImageTime = 2;
    NSError *thumbnailImageError = nil;
    CGImageRef thumbnailImageRef = nil;
    thumbnailImageRef = [imgGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 10) actualTime:nil error:&thumbnailImageError];
    UIImage *image = [UIImage imageWithCGImage:thumbnailImageRef];
    
    CGImageRelease(thumbnailImageRef);
    UIGraphicsEndImageContext();
    
    NSData *imgData = UIImagePNGRepresentation(image);
    NSString *encodeImgStr = [imgData base64EncodedStringWithOptions:0];
    
    if (!thumbnailImageRef) {
        QNWSLog(@"图片为空");
        QNWSLog(@"thumbnailImageError == %@",thumbnailImageError.localizedDescription);
    }
    return encodeImgStr;
#endif
}
-(void)transFailShow
{
    [WX_ProgressHUD show:@"转换失败"];
    self.backView.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(transFail) userInfo:nil repeats:NO];
}

-(void)transFail
{
    [WX_ProgressHUD dismiss];
    if (!self.backView.hidden) {
        
        self.backView.hidden = YES;
    }
}

-(void)transSuccess
{
    
    self.backView.hidden = YES;
    
    [WX_ProgressHUD dismiss];
    
    WX_ShootCViewController *shootVC = [[WX_ShootCViewController alloc]init];
    
    [self.navigationController pushViewController:shootVC animated:YES];
//    [(CTAssetsPickerController*)self.navigationController.viewControllers[0].presentingViewController dismissViewControllerAnimated:YES completion:NULL];

    /// 开启所有按钮
    //            [self stateEnableOrUnableWithYesOrNo:NO];
    
    /// 页面跳转
    
    
//    WX_AlbumViewController *albumVC = [[WX_AlbumViewController alloc]init];
    
//    albumVC.albumModel = _albumModel;
    
//    [self.navigationController pushViewController:albumVC animated:YES];
}
-(void)returnLastView:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [WX_ProgressHUD dismiss];
}

-(void)dealloc
{
    QNWSLog(@" %@ 死了 ",self.class);
}

@end



#pragma mark - CTAssetsViewCell

@implementation CTAssetsViewCell

static UIFont *titleFont = nil;

static CGFloat titleHeight;
static UIImage *videoIcon;
static UIColor *titleColor;
static UIImage *checkedIcon;
static UIColor *selectedColor;

+ (void)initialize
{
    titleFont       = [UIFont systemFontOfSize:12];
    titleHeight     = 20.0f;
    videoIcon       = [UIImage imageNamed:@"icon_dpcz_video_n"];
    titleColor      = [UIColor whiteColor];
    checkedIcon     = [UIImage imageNamed:(!IS_IOS7) ? @"CTAssetsPickerChecked~iOS6" : @"CTAssetsPickerChecked"];
    selectedColor   = [UIColor colorWithWhite:1 alpha:0.3];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.opaque                     = YES;
        self.isAccessibilityElement     = YES;
        self.accessibilityTraits        = UIAccessibilityTraitImage;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)bind:(ALAsset *)asset
{
    self.asset  = asset;
    self.image  = [UIImage imageWithCGImage:asset.thumbnail];
    self.type   = [asset valueForProperty:ALAssetPropertyType];
    self.title  = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}


// Draw everything to improve scrolling responsiveness

- (void)drawRect:(CGRect)rect
{
    // Image
    [self.image drawInRect:CGRectMake(0, 0, kThumbnailLength, kThumbnailLength)];
    
    // Video title
    if ([self.type isEqual:ALAssetTypeVideo])
    {
        // Create a gradient from transparent to black
        CGFloat colors [] = {
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.8,
            0.0, 0.0, 0.0, 1.0
        };
        
        CGFloat locations [] = {0.0, 0.75, 1.0};
        
        CGColorSpaceRef baseSpace   = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient      = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
        
        CGContextRef context    = UIGraphicsGetCurrentContext();
        
        CGFloat height          = rect.size.height;
        CGPoint startPoint      = CGPointMake(CGRectGetMidX(rect), height - titleHeight);
        CGPoint endPoint        = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);

//        
//        CGSize titleSize        = [self.title sizeWithFont:titleFont];
        
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
        
        
        NSDictionary *titleAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        [titleColor set];

        
//        [self.title drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2 , startPoint.y + (titleHeight - 12) / 2)
//                       forWidth:kThumbnailLength
//                       withFont:titleFont
//                       fontSize:12
//                  lineBreakMode:NSLineBreakByTruncatingTail
//             baselineAdjustment:UIBaselineAdjustmentAlignCenters];
//        
//        [videoIcon drawAtPoint:CGPointMake(2, startPoint.y + (titleHeight - videoIcon.size.height) / 2)];
        
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:@"kThumbnailLength",@"titleSize",@"12",@"NSLineBreakByTruncatingTail",@"UIBaselineAdjustmentAlignCenters", nil];
//        [self.title drawInRect:CGRectMake(0, rect.size.height-titleHeight, rect.size.width, titleHeight) withAttributes:titleAttributes] ;
        
        NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc]init];
        drawingContext.minimumScaleFactor = 0.5;
        
        
        [self.title drawWithRect:CGRectMake(rect.size.width-titleSize.width-5, rect.size.height-titleHeight+2.5, titleSize.width+5, titleHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:drawingContext];
    
        [videoIcon drawAtPoint:CGPointMake(2, startPoint.y + (titleHeight - videoIcon.size.height) / 2)];

    }
    
    if (self.selected)
    {
        CGContextRef context    = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, selectedColor.CGColor);
		CGContextFillRect(context, rect);
        
        [checkedIcon drawAtPoint:CGPointMake(CGRectGetMaxX(rect) - checkedIcon.size.width, CGRectGetMinY(rect))];
    }
}


- (NSString *)accessibilityLabel
{
    ALAssetRepresentation *representation = self.asset.defaultRepresentation;
    
    NSMutableArray *labels          = [[NSMutableArray alloc] init];
    NSString *type                  = [self.asset valueForProperty:ALAssetPropertyType];
    NSDate *date                    = [self.asset valueForProperty:ALAssetPropertyDate];
    CGSize dimension                = representation.dimensions;

    
    // Type
    if ([type isEqual:ALAssetTypeVideo])
        [labels addObject:NSLocalizedString(@"Video", nil)];
    else
        [labels addObject:NSLocalizedString(@"Photo", nil)];

    // Orientation
    if (dimension.height >= dimension.width)
        [labels addObject:NSLocalizedString(@"Portrait", nil)];
    else
        [labels addObject:NSLocalizedString(@"Landscape", nil)];
    
    // Date
    NSDateFormatter *df             = [[NSDateFormatter alloc] init];
    df.locale                       = [NSLocale currentLocale];
    df.dateStyle                    = NSDateFormatterMediumStyle;
    df.timeStyle                    = NSDateFormatterShortStyle;
    df.doesRelativeDateFormatting   = YES;
    
    [labels addObject:[df stringFromDate:date]];
    
    return [labels componentsJoinedByString:@", "];
}


@end


#pragma mark - CTAssetsSupplementaryView

@implementation CTAssetsSupplementaryView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _sectionLabel               = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 8.0, 8.0)];
        _sectionLabel.font          = [UIFont systemFontOfSize:18.0];
        _sectionLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_sectionLabel];
    }
    
    return self;
}

- (void)setNumberOfPhotos:(NSInteger)numberOfPhotos numberOfVideos:(NSInteger)numberOfVideos
{
    NSString *title;
    
    if (numberOfVideos == 0);
//        title = [NSString stringWithFormat:NSLocalizedString(@"%d 相片", nil), numberOfPhotos];
    else if (numberOfPhotos == 0)
//        title = [NSString stringWithFormat:NSLocalizedString(@"%d 视频文件", nil), numberOfVideos];
        return;
    else
        title = [NSString stringWithFormat:NSLocalizedString(@"%d 相片, %d 视频文件", nil), numberOfPhotos, numberOfVideos];
    
    self.sectionLabel.text = title;
    self.sectionLabel.textColor = KUIColorFromRGB(0x3c4f5e);
}

@end
