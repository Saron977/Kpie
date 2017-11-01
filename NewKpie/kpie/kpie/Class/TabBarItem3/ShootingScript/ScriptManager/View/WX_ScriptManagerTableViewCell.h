//
//  WX_ScriptManagerTableViewCell.h
//  kpie
//
//  Created by 王傲擎 on 16/4/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WX_ScriptManagerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleimgView; /**<   展示图片 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;     /**<   简介 */

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;       /**<   选中Btn */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;       /**<   标题 */
@end
