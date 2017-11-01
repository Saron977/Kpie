//
//  WX_ChannelModel.h
//  kpie
//
//  Created by 王傲擎 on 16/4/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_ChannelModel : NSObject

//0  CHANNELID      String   频道编号
//1  CHANNELNAME    String   频道名称
//2  CHANNELDESC    String   频道描述
//3  ONOFFTIME      TimeStamp 上架时间
//4  CT              Integer   剧本数量
@property (nonatomic, copy) NSString        *channelID;         /**<   频道编号 */
@property (nonatomic, copy) NSString        *channelName;       /**<   频道名称 */
@property (nonatomic, copy) NSString        *channelDesc;       /**<   频道描述 */
@property (nonatomic, copy) NSString        *onOffTime;         /**<   上架时间 (时间戳)*/
@property (nonatomic, copy) NSString        *CTNum;             /**<   剧本数量 */

@property (nonatomic, assign) BOOL          isPull;             /**<   频道是否收起 */



+(instancetype)initModelWithDic:(NSDictionary *)dic;

@end
