//
//  BYC_LoginHandler.h
//  kpie
//
//  Created by 元朝 on 16/10/31.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYC_LoginHandler : NSObject

+ (void)requestDataWithParameters:(id)parameters type:(BOOL)isThird success:(void (^)(AFHTTPRequestOperation *operation, BYC_AccountModel *model))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
