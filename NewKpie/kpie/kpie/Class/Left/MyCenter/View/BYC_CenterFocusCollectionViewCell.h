//
//  BYC_CenterFocusCollectionViewCell.h
//  kpie
//
//  Created by 元朝 on 15/12/9.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^BYC_CenterFocusCollectionViewCellSelectedWhetherFocus)(BOOL whetherFocus,BYC_AccountModel *model ,UIButton *button ,BOOL isLogin);
@interface BYC_CenterFocusCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)  BYC_AccountModel  *model;
@property (nonatomic, assign)  WhetherFocusForCell     whetherFocusForCell;
@property (nonatomic, strong)  BYC_CenterFocusCollectionViewCellSelectedWhetherFocus  whetherFocusBlock;
@property (weak, nonatomic) IBOutlet UIButton *button_Focus;

@end
