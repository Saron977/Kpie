//
//  WX_AddUrlView.h
//  kpie
//
//  Created by 王傲擎 on 16/9/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UrlTextDelegate <NSObject>
/**
 *  代理方法
 *
 *  @param text 返回网站字符串
 */
-(void)UrlText:(NSString*)text;

@end
/**
 *  block
 *
 *  @param urlString 返回网站字符串
 */
typedef void(^blockUrlString)(NSString* urlString);

typedef enum {
    ENUM_ViewDidLoad        =   0,  /**<   界面存在 */
    ENUM_ViewDisappear      =   1,  /**<   界面被移除 */
}ENUMViewState;

@interface WX_AddUrlView : UIView

@property (nonatomic, copy) blockUrlString block;           /**<   block 回调方法 返回文字 */

@property (nonatomic, weak) id<UrlTextDelegate> delegate;   /**<   获取返回文字方法 */

@property (nonatomic, assign) ENUMViewState  state_UrlView;  /**<   界面状态 */
/**
 *  创建输入框
 *
 *  @param frame       输入框frame
 *  @param placeholder 提示文字
 */
-(void)createUrlViewWithView:(WX_AddUrlView*)urlView Frame:(CGRect)frame Placeholder:(NSString *)placeholder;


@end
