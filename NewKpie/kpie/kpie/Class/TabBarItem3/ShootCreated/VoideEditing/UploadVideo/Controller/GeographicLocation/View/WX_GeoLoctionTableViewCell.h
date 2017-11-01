//
//  WX_GeoLoctionTableViewCell.h
//  kpie
//
//  Created by 王傲擎 on 15/11/26.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WX_GeoLoctionTableViewCell : UITableViewCell
//{
//        __weak IBOutlet UIView *backGView;
//}
@property (weak, nonatomic) IBOutlet UIView *backGView;

-(void)creatTheCellWithName:(NSString *)name Adress:(NSString *)adress;

@end
