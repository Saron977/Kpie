//
//  WX_AddTopicCollectionViewCell.h
//  kpie
//
//  Created by 王傲擎 on 15/11/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WX_AddTopicModel.h"

@interface WX_AddTopicCollectionViewCell : UICollectionViewCell
@property(nonatomic, retain) UILabel             *topiclabel;;

-(void)setTheCellWithModel:(WX_AddTopicModel *)model;

@end
