//
//  BYC_MyCenterFocusRequestDataHandler.m
//  kpie
//
//  Created by 元朝 on 16/9/12.
//  Copyright © 2016年 QNWS. All rights reserved.
// 至始至终不能对自己进行任何取消和关注的操作

#import "BYC_MyCenterFocusRequestDataHandler.h"
#import "BYC_HttpServers+HL_SaveOrRemoveFriend.h"

@implementation BYC_MyCenterFocusRequestDataHandler


//选择是否关注:userID 被关注或取消对象的UserID
+ (void)whetherSelectFocusWithToUserID:(BYC_AccountModel *)model handler:(BYC_MyCenterHandler *)handler completion:(void(^)(BOOL success, WhetherFocusForCell status))completion {
    
    handler.model_ToFocusUser = model;
    if (handler.model_ToFocusUser.userid == nil) {
        QNWSBlockSafe(completion,YES,handler.model_ToFocusUser.whetherFocusForCell);
        return;
    };
    
    [BYC_MyCenterFocusRequestDataHandler requestDataWithFlag:handler.model_ToFocusUser.whetherFocusForCell == WhetherFocusForCellHXFocus || handler.model_ToFocusUser.whetherFocusForCell == WhetherFocusForCellYES ? 0 : 1 data:handler completion:^(BOOL success, WhetherFocusForCell status) {
        QNWSBlockSafe(completion,YES,status);
    }];
}

+ (void)requestDataWithFlag:(NSInteger)flag data:(BYC_MyCenterHandler *)handle completion:(void(^)(BOOL success, WhetherFocusForCell status))completion{
    
    WhetherFocusForCell whenClickFocusStateResult;
    switch (handle.model_ToFocusUser.attentionstate) {
        case 1://互相关注
            whenClickFocusStateResult = WhetherFocusForCellHXFocus;
            break;
        case 2://已关注
            whenClickFocusStateResult = WhetherFocusForCellYES;
            break;
        case 3://被关注
            whenClickFocusStateResult = WhetherFocusForCellFocused;
            break;
        case 4://未关注
            whenClickFocusStateResult = WhetherFocusForCellNO;
            break;
            
        default:
            break;
    }
    handle.model_ToFocusUser.whetherFocusForCell = whenClickFocusStateResult;
     //userId/touserid
    NSArray *arr_params = @[handle.model_User.userid,handle.model_ToFocusUser.userid];
    switch (flag) {
        case 0://取消关注
        {
        [BYC_HttpServers requestRemoveFriendWithParameters:arr_params success:^(BOOL isRemoveSuccess) {
            if (isRemoveSuccess) {//取消关注成功
                switch (handle.model_ToFocusUser.whetherFocusForCell) {
                    case WhetherFocusForCellHXFocus:
                        handle.model_ToFocusUser.whetherFocusForCell = WhetherFocusForCellFocused;
                        break;
                    case WhetherFocusForCellYES:
                        handle.model_ToFocusUser.whetherFocusForCell = WhetherFocusForCellNO;
                        break;
                    default:
                        break;
                }
                
            QNWSBlockSafe(completion,YES,handle.model_ToFocusUser.whetherFocusForCell);
        }
            else{
               QNWSBlockSafe(completion,YES,handle.model_ToFocusUser.whetherFocusForCell);
            }
                
        } failure:^(NSError *error) {
            
        }];        
        }
            break;
        case 1://添加关注
        {
        [BYC_HttpServers requestSaveFriendWithParameters:arr_params success:^(BOOL isSaveSuccess) {
            
            if (isSaveSuccess) {//成功添加关注
                switch (handle.model_ToFocusUser.whetherFocusForCell) {
                    case WhetherFocusForCellFocused:
                        handle.model_ToFocusUser.whetherFocusForCell = WhetherFocusForCellHXFocus;
                        break;
                    case WhetherFocusForCellNO:
                        handle.model_ToFocusUser.whetherFocusForCell = WhetherFocusForCellYES;
                        break;
                    default:
                        break;
                }
                QNWSBlockSafe(completion,YES,handle.model_ToFocusUser.whetherFocusForCell);
            }
            else{
               QNWSBlockSafe(completion,YES,handle.model_ToFocusUser.whetherFocusForCell);
            }

        } failure:^(NSError *error) {
            
        }];
        
        }
        default:
            break;
    }
}
@end
