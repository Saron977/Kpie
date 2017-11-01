//
//  WX_AddTopicModel.h
//  kpie
//
//  Created by 王傲擎 on 15/11/25.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WX_AddTopicModel : NSObject

@property(nonatomic, retain) NSString       *themeID;
@property(nonatomic, retain) NSString       *themeName;
@property(nonatomic, retain) NSString       *views;
@property(nonatomic, retain) NSString       *createDate;

-(void)saveDataWithDic:(NSDictionary *)topicDic;

@end
