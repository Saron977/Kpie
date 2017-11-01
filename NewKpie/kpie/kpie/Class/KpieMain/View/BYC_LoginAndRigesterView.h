//
//  BYC_LoginAndRigesterView.h
//  kpie
//
//  Created by 元朝 on 15/11/3.
//  Copyright © 2015年 QNWS. All rights reserved.
//需要登录的时候调用

#import <UIKit/UIKit.h>

@interface BYC_LoginAndRigesterView : UIView
/**
 *  登录
 *
 *  @param success 登录成功的回调
 */
+(void)shareLoginAndRigesterViewSuccess:(void(^)())success failure:(void(^)())failure;

/**
 *  内部结合了判断是否登录逻辑，登录成功或者已经登录过调用block执行相应逻辑代码，无需使用若引用，内部已经在调用完毕的block之后立马释放block不会造成循环引用。
 *
 *  @param success 有登录或者登录成功，回调处理事情
 */

+(void)checkLoginStateBlock:(void(^)(BOOL isLogin))block;

+(void)removeAppearView;

@end
