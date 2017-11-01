//
//  BYC_HttpServers+BYC_BaseRequset.m
//  kpie
//
//  Created by 元朝 on 16/10/19.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServers+BYC_BaseRequset.h"

@implementation BYC_HttpServers (BYC_BaseRequset)

/**请求是post，且只要求成功回调，不需要回调特别的参数接口适用。*/
+ (void)requestCommonDontDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [BYC_HttpServers Post:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        QNWSBlockSafe(success, operation);

    } failure:failure];
}

//+ (void)requestNormalDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, ...))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure exeBlock:(NSArray *(^)(id responseObject))exeBlock{
//    
//    [BYC_HttpServers Post:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [BYC_HttpServers isfailure:responseObject success:^{
//            
//            NSArray *arr_Temp = QNWSBlockSafe(exeBlock,responseObject);
//            
//            switch (arr_Temp.count) {
//                case 0:
//                    QNWSBlockSafe(success, operation);
//                    break;
//                case 1:
//                    QNWSBlockSafe(success, operation, arr_Temp[0]);
//                    break;
//                case 2:
//                    QNWSBlockSafe(success, operation, arr_Temp[0], arr_Temp[1]);
//                    break;
//                case 3:
//                    QNWSBlockSafe(success, operation, arr_Temp[0], arr_Temp[1], arr_Temp[2]);
//                    break;
//                case 4:
//                    QNWSBlockSafe(success, operation, arr_Temp[0], arr_Temp[1], arr_Temp[2], arr_Temp[3]);
//                    break;
//                case 5:
//                    QNWSBlockSafe(success, operation, arr_Temp[0], arr_Temp[1], arr_Temp[2], arr_Temp[3], arr_Temp[4]);
//                    break;
//                case 6:
//                    QNWSBlockSafe(success, operation, arr_Temp[0], arr_Temp[1], arr_Temp[2], arr_Temp[3], arr_Temp[4], arr_Temp[5]);
//                    break;
//                case 7:
//                    QNWSBlockSafe(success, operation, arr_Temp[0], arr_Temp[1], arr_Temp[2], arr_Temp[3], arr_Temp[4], arr_Temp[5], arr_Temp[7]);
//                    break;
//                    
//                    
//                default:
//                    QNWSBlockSafe(failure, operation, nil);
//                    break;
//            }
//            
//        } failure:failure];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [[UIView alloc] showAndHideHUDWithTitle:error.localizedDescription WithState:BYC_MBProgressHUDHideProgress];
//        QNWSBlockSafe(failure, operation, error);
//    }];
//}

//+ (void)functionName:(id)string, ...NS_REQUIRES_NIL_TERMINATION
//{
//    va_list args;
//    va_start(args, string);
//    if (string)
//    {
//        id object;
//        while ((object = va_arg(args, NSString *)))
//        {
//            //依次取得所有参数
//            QNWSLog(@"object == %@",object);
//        }
//    }
//    va_end(args);
//}


@end
