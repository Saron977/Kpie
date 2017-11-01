//
//  BYC_MTCollectionViewCell.h
//  kpie
//
//  Created by 元朝 on 16/4/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYC_MTCollectionViewCell : UICollectionViewCell

/**标题*/
@property (nonatomic, copy)  NSString  *title;


/**设置文本颜色*/
@property (nonatomic, strong)  UIColor  *textColor;
@end
