//
//  WX_UICollectionViewFlowLayout.m
//  kpie
//
//  Created by 王傲擎 on 16/8/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_UICollectionViewFlowLayout.h"

@implementation WX_UICollectionViewFlowLayout
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    //从第二个循环到最后一个
    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //这里我们只能对相同的组做操作
        if (currentLayoutAttributes.indexPath.section != prevLayoutAttributes.indexPath.section) continue;
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = _integer_MaximumSpacing;
        //前一个cell的最右边
        NSInteger originOfPrevLayout = CGRectGetMaxX(prevLayoutAttributes.frame);
        NSInteger WidthOfCurrent = CGRectGetWidth(currentLayoutAttributes.frame);
        if (originOfPrevLayout + maximumSpacing + WidthOfCurrent > screenWidth - 20/*距离右边的间隙*/) continue;
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(originOfPrevLayout + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = originOfPrevLayout + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    
    return attributes;
}
@end
