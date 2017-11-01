//
//  BYC_MTHandleSelectArea.h
//  kpie
//
//  Created by 元朝 on 16/4/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SelectAreaBlock)(NSIndexPath *indexPath);

@interface BYC_MTHandleSelectArea : NSObject

/**数据*/
@property (nonatomic, strong)  NSArray  *array_Data;
/**大小*/
@property (nonatomic, assign)  CGRect  frame;

-(instancetype)initWithCollection:(UICollectionView *)collectionView WithData:(NSArray *)arrData selectAreaBlock:(SelectAreaBlock)selectAreaBlock;
@end
