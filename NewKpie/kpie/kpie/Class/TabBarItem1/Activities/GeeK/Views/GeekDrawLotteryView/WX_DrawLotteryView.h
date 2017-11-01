//
//  WX_DrawLotteryView.h
//  DrawLottery
//
//  Created by 王傲擎 on 16/7/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WX_GeekModel.h"

typedef enum {
    ENUM_Activities_JoinShooting        = 0,     /**<   栏目界面_加入拍摄 */
    ENUM_Video_VoteWithLottery          = 1,     /**<   视频界面_参加抽奖 */
    ENUM_Video_ShareWithLottery         = 2,     /**<   视频界面_分享抽奖 */
    ENUM_Video_VoteEndNeedPhoneNum      = 3,     /**<   抽奖界面_填写手机号 */
}DrawLottery;
@interface WX_DrawLotteryView : UIView

+(void)showDrawLotteryViewWith:(DrawLottery)lotteryType ViewController:(UIViewController*)controller GeekModel:(WX_GeekModel*)model_Geek;   /**< lotteryType 为 ENUM_Activities_JoinShooting时 参与拍摄_附带controller, 否则为 nil*/
@end
