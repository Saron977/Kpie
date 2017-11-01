//
//  BYC_AusleseVCCollectionViewHeader.m
//  kpie
//
//  Created by 元朝 on 16/5/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_AusleseVCCollectionViewHeader.h"
#import "BYC_HomeBannnerHeader.h"
#import "BYC_SearchViewController.h"
#import "UIView+BYC_GetViewController.h"

@interface BYC_AusleseVCCollectionViewHeader()

/**搜索View*/
@property (nonatomic, strong)  UIView *view_Search;
/**bannerView*/
@property (nonatomic, strong)  UIView  *view_bannerHeader;
/**banner*/
@property (nonatomic, strong)  BYC_HomeBannnerHeader  *bannerHeader;

@end

@implementation BYC_AusleseVCCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


- (void)initViews {

//    [self initSearchView];
    [self initBannerHeader];
}

- (void)initSearchView {

    _view_Search = ({
    
        UIView *view_Search = [[UIView alloc] init];
        view_Search.backgroundColor = [UIColor whiteColor];
        view_Search.layer.cornerRadius = 5;
        [self addSubview:view_Search];
        [view_Search mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.leading.trailing.equalTo(view_Search.superview).insets(UIEdgeInsetsMake(7, 10, 0, 10));
            make.height.offset(30);
        }];
        
        UITapGestureRecognizer *tap_Search = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapAction)];
        [view_Search addGestureRecognizer:tap_Search];
        
        view_Search;
    });
    
    UIView *view_Center = ({
    
        UIView *view_Center = [[UIView alloc] init];
        [_view_Search addSubview:view_Center];
        view_Center;
    });
    
    UIImageView *imageV = ({
    
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:@"icon_sousuo_chaxun_n"];
        [view_Center addSubview:imageV];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.leading.equalTo(imageV.superview);
            make.height.equalTo(imageV.superview);
        }];
        
        imageV;
    });
    
    
    UILabel *label = ({
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"搜索昵称、内容";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = KUIColorFromRGB(0X828E9A);
        label.textAlignment = NSTextAlignmentCenter;
        [view_Center addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(label.superview);
            make.leading.equalTo(imageV.mas_trailing).offset(10);
            make.height.equalTo(label.superview);
        }];
        
        label;
    });
    
    [view_Center mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(view_Center.superview);
        make.height.equalTo(view_Center.superview);
        make.leading.equalTo(imageV.mas_leading);
        make.trailing.equalTo(label.mas_trailing);
    }];
    
}

- (void)initBannerHeader {

    _bannerHeader = [BYC_HomeBannnerHeader getSelfObject];
    [self addSubview:_bannerHeader];
    [_bannerHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.leading.bottom.trailing.equalTo(_bannerHeader.superview).insets(UIEdgeInsetsMake(KHeightNavigationBar - KHeightStateBar, 0, 0, 0));
    }];
}

- (void)searchTapAction {

    BYC_SearchViewController *searchVC = [[BYC_SearchViewController alloc] init];
    [[self getBGViewController].navigationController pushViewController:searchVC animated:YES];
}

-(void)setArray_bannnerModels:(NSArray *)array_bannnerModels {

    _bannerHeader.array_bannnerModels = array_bannnerModels;
}

@end
