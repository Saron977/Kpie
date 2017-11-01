//
//  NSDictionary+BYC_NullChangeNilWithDic.h
//  kpie
//
//  Created by 元朝 on 15/12/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (BYC_NullChangeNilWithDic)

//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj;
@end
