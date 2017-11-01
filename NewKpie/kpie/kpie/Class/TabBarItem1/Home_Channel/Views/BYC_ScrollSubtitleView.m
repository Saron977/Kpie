//
//  BYC_ScrollSubtitleView.h
//  kpie
//
//  Created by 元朝 on 16/7/13.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ScrollSubtitleView.h"
#import "BYC_ScrollViewPanGestureRecognizer.h"
#import "BYC_ScrollSubtitleCell.h"
#import "NSString+BYC_Tools.h"
#import "UIView+BYC_Tools.h"

@interface BYC_ScrollSubtitleView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)   UICollectionView *collectionView;
/**选中的下标*/
@property (nonatomic, strong)  NSIndexPath  *indexPath;
/**最新或者最热*/
@property (nonatomic, strong)  UIView  *view_NewOrHot;
/**第一次的父视图*/
@property (nonatomic, strong)  UIView  *view_FirstSuperView;

/**最新最热Button*/
@property (nonatomic, strong)  UIButton *button;
@end

@implementation BYC_ScrollSubtitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [self initSubViews];
        [self initParame];
    }
    return self;
}

#pragma mark - 初始化参数
- (void)initParame {
    
    self.backgroundColor = KUIColorBackground;
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //记录滑动手势
    [BYC_ScrollViewPanGestureRecognizer sharePanGestureWith:self.collectionView];
}

#pragma mark - 初始化子视图
- (void)initSubViews {
    
    
    _view_NewOrHot = ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.kwidth - 70, 0, 70, self.kheight)];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {(void)make.center;}];
        _button.selected = YES;
        [_button setImage:[UIImage imageNamed:@"channel_btn_zuixin_n"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"channel_btn_zuixin_h"] forState:UIControlStateHighlighted];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        view.layer.shadowOffset = CGSizeMake(-5, _button.kheight);
        view.layer.shadowColor  = [UIColor whiteColor].CGColor;
        view.layer.shadowRadius = 3;
        view.layer.shadowOpacity = .8f;
        view;
    });
    
    [self addSubview:_view_NewOrHot];
    
    //设置布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = .5f;
    layout.minimumLineSpacing = 0.f;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //创建UICollectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.kwidth - _view_NewOrHot.kwidth, self.kheight) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollsToTop = NO;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[BYC_ScrollSubtitleCell class] forCellWithReuseIdentifier:@"ScrollSubtitleCell"];
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview {

    if (!_view_FirstSuperView)_view_FirstSuperView = newSuperview;
    if (_view_FirstSuperView == newSuperview) {
    
        self.backgroundColor = KUIColorBackground;
    } else {//毛玻璃滤镜
    
//        self.backgroundColor = [UIColor clearColor];
//        [self setBlurEffectWithStyle:UIBlurEffectStyleLight];
    }
}

-(void)setArr_Models:(NSArray<BYC_OtherViewControllerModel *> *)arr_Models {

    _arr_Models = arr_Models;
    [_collectionView reloadData];
}


- (void)buttonAction:(UIButton *)button {
    
    self.selectStatue = !button.selected ? ENUM_SelectStatueNew : ENUM_SelectStatueOld;
}

-(void)setSelectStatue:(ENUM_SelectStatue)selectStatue {

    _selectStatue = selectStatue;
    
    switch (selectStatue) {
        case ENUM_SelectStatueNew: {
            _button.selected = YES;
            [_button setImage:[UIImage imageNamed:@"channel_btn_zuixin_n"] forState:UIControlStateNormal];
            [_button setImage:[UIImage imageNamed:@"channel_btn_zuixin_h"] forState:UIControlStateHighlighted];
            break;
        }
        case ENUM_SelectStatueOld: {
            _button.selected = NO;
            [_button setImage:[UIImage imageNamed:@"channel_btn_zuire_n"] forState:UIControlStateNormal];
            [_button setImage:[UIImage imageNamed:@"channel_btn_zuire_n"] forState:UIControlStateHighlighted];
            break;
        }
    }

    if (_delegate && [_delegate respondsToSelector:@selector(scrollSubtitleView:didSelectStatue:)])
        [_delegate scrollSubtitleView:self didSelectStatue:selectStatue];
}

#pragma Mark - collection的DataSource 和 Delegate方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.arr_Models.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"ScrollSubtitleCell";
    BYC_ScrollSubtitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    cell.str_Title = _arr_Models[indexPath.item].columnName;
    cell.isSelected = (_indexPath.section == indexPath.section && _indexPath.item == indexPath.item ) ? NO : YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = _arr_Models[indexPath.item].columnName;
    CGSize size = [str sizeWithfont:14 boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)];
    return CGSizeMake(size.width + 40, _collectionView.kheight);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BYC_ScrollSubtitleCell *cell;
    for (int i = 0; i < _arr_Models.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        cell = (BYC_ScrollSubtitleCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.isSelected = YES;
    }
    
    _indexPath = indexPath;
    cell = (BYC_ScrollSubtitleCell *)[collectionView cellForItemAtIndexPath:_indexPath];
    cell.isSelected = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollSubtitleView:didSelectItemAtIndexPath:)])
        [_delegate scrollSubtitleView:self didSelectItemAtIndexPath:indexPath];
}

@end
