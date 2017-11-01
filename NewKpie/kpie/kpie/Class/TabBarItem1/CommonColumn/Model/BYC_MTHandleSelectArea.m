//
//  BYC_MTHandleSelectArea.m
//  kpie
//
//  Created by 元朝 on 16/4/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_MTHandleSelectArea.h"
#import "BYC_MTCollectionViewCell.h"
#import "HL_ColumnVideoThemeModel.h"

#define OBJ_MinimumInteritemSpacing 10
#define OBJ_MinimumLineSpacing      10

@interface BYC_MTHandleSelectArea()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)  UICollectionView  *collectionView_selectArea;

/**选择地区的回调*/
@property (nonatomic, strong)  SelectAreaBlock  selectAreaBlock;

/**记录选中的位置*/
@property (nonatomic, strong)  NSIndexPath  *indexPath_Selected;
@property (nonatomic, strong)  UICollectionViewFlowLayout *layout;
@end

@implementation BYC_MTHandleSelectArea


-(instancetype)initWithCollection:(UICollectionView *)collectionView WithData:(NSArray *)arrData selectAreaBlock:(SelectAreaBlock)selectAreaBlock {

    self = [super init];
    if (self) {
        [self initDefaultParame];
        _selectAreaBlock = selectAreaBlock;
      
        [self initCollectionView:collectionView];
    }
    return self;
}

- (void)initDefaultParame {

    _indexPath_Selected = [NSIndexPath indexPathForItem:0 inSection:0];
}

-(void)setFrame:(CGRect)frame {

    _frame = frame;
    [self initSize];

}

- (void)initSize {

    float column = 3.0;
    int row    = ceil(_array_Data.count / column);
    _layout.itemSize = CGSizeMake((CGRectGetWidth(_frame) - (column - 1) * OBJ_MinimumInteritemSpacing )/ column  , (CGRectGetHeight(_frame) - (row - 1) * OBJ_MinimumLineSpacing )/ row);
}

- (void)initCollectionView:(UICollectionView *)collectionView {

    _collectionView_selectArea = collectionView;
    
    //设置布局
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = OBJ_MinimumInteritemSpacing;
    _layout.minimumLineSpacing      = OBJ_MinimumLineSpacing;
    

    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView_selectArea.delegate = self;
    _collectionView_selectArea.dataSource = self;
    _collectionView_selectArea.collectionViewLayout = _layout;
    _collectionView_selectArea.backgroundColor      = [UIColor clearColor];
    _collectionView_selectArea.showsVerticalScrollIndicator = NO;
    

    [_collectionView_selectArea registerNib:[UINib nibWithNibName:@"BYC_MTCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"default"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array_Data.count == 1 ? 0 : _array_Data.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BYC_MTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"default" forIndexPath:indexPath];
    
    HL_ColumnVideoThemeModel *model = _array_Data[indexPath.row];
    NSString *themeName = [model.themename stringByReplacingOccurrencesOfString:@"#hide" withString:@""];
    themeName = [themeName stringByReplacingOccurrencesOfString:@"#" withString:@""];
    cell.title = themeName;    
    if (indexPath == _indexPath_Selected) {
        
        cell.textColor = KUIColorBaseGreenNormal;
        cell.backgroundColor = KUIColorFromRGB(0X181D24);
    }else {
        
        cell.textColor = KUIColorFromRGB(0X89A7CC);
        cell.backgroundColor = KUIColorFromRGB(0X2C3642);
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (_selectAreaBlock)_selectAreaBlock(indexPath);
    self.indexPath_Selected = indexPath;
}

-(void)setIndexPath_Selected:(NSIndexPath *)indexPath_Selected {

    
    BYC_MTCollectionViewCell *cellOld = (BYC_MTCollectionViewCell *)[_collectionView_selectArea cellForItemAtIndexPath:_indexPath_Selected];
    cellOld.backgroundColor = KUIColorFromRGB(0X2C3642);
    cellOld.textColor = KUIColorFromRGB(0X89A7CC);
    _indexPath_Selected = indexPath_Selected;
    BYC_MTCollectionViewCell *cellNew = (BYC_MTCollectionViewCell *)[_collectionView_selectArea cellForItemAtIndexPath:indexPath_Selected];
    cellNew.backgroundColor = KUIColorFromRGB(0X181D24);
    cellNew.textColor = KUIColorBaseGreenNormal;
}

-(void)setArray_Data:(NSArray *)array_Data {

    if (_array_Data != array_Data) {
        
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        mArray = [array_Data mutableCopy];
        HL_ColumnVideoThemeModel *model = [[HL_ColumnVideoThemeModel alloc] init];
        model.themeid = nil;
        model.themename = @"全部";
        [mArray insertObject:model atIndex:0];
        _array_Data = [mArray copy];
        
        [self initSize];
        [_collectionView_selectArea reloadData];
    }
}

-(void)dealloc {

    QNWSLog(@"%@  ======  %s",[self class],__func__);
}
@end
