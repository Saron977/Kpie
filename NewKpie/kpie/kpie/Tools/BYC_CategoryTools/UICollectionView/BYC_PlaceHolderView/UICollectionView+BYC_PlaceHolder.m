//
//  UICollectionView+BYC_PlaceHolder.m
//  kpie
//
//  Created by 元朝 on 16/5/30.
//  Copyright © 2016年 QNWS. All rights reserved.

// 空collectionView的占位视图工具类目，使用方法：导入此类目，然后替换系统的reloadData 使用byc_reloadData类目。

#import "UICollectionView+BYC_PlaceHolder.h"
#import <objc/runtime.h>
#import "BYC_PlaceHolderView.h"

@interface UICollectionView ()

/**占位视图*/
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation UICollectionView (BYC_PlaceHolder)

- (UIView *)placeHolderView {
    return objc_getAssociatedObject(self, @selector(placeHolderView));
}

- (void)setPlaceHolderView:(UIView *)placeHolderView {
    
    objc_setAssociatedObject(self, @selector(placeHolderView), placeHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)byc_reloadData {

    [self byc_reloadData:nil];
}

- (void)byc_reloadData:(NSString *)promptText {

    [self byc_reloadData:promptText frame:CGRectNull];
}

- (void)byc_reloadData:(NSString *)promptText frame:(CGRect)frame {

    [self reloadData];
    [self checkEmpty:promptText frame:frame];
}

- (void)checkEmpty:(NSString *)promptText frame:(CGRect)frame {
    BOOL isEmpty = YES;
    
    id<UICollectionViewDataSource> object = self.dataSource;
    NSInteger sections = 1;
    if ([object respondsToSelector: @selector(numberOfSectionsInTableView:)])
        sections = [object numberOfSectionsInCollectionView:self];
    
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [object collectionView:self numberOfItemsInSection:i];
        if (rows) isEmpty = NO;
    }
    if (isEmpty) {//数据为空

        if ([self respondsToSelector:@selector(creatPlaceHolderView)])
            self.placeHolderView = [self performSelector:@selector(creatPlaceHolderView)];
         else if ( [self.delegate respondsToSelector:@selector(creatPlaceHolderView)])
            self.placeHolderView = [self.delegate performSelector:@selector(creatPlaceHolderView)];
        if (self.placeHolderView == nil)
            self.placeHolderView = [[BYC_PlaceHolderView alloc] initWithPromptText:promptText frame: frame.size.width > 0 ? frame : self.bounds];//没有就使用默认的placeHolderView
        
        //插入最底层，以免有头视图的collectionView 遮挡头视图
        [self insertSubview:self.placeHolderView atIndex:0];
    } else {//数据不为空

        [self.placeHolderView removeFromSuperview];
        self.placeHolderView = nil;
    }
}

@end
