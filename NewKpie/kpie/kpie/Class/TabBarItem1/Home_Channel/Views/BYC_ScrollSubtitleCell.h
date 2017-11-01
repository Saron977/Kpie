//
//  BYC_ScrollSubtitleCell.h
//  kpie
//
//  Created by 元朝 on 16/7/13.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_ScrollSubtitleCell: UICollectionViewCell

/**标题*/
@property (nonatomic, copy)  NSString  *str_Title;

/**选中*/
@property (nonatomic, assign)  BOOL  isSelected;

@end
