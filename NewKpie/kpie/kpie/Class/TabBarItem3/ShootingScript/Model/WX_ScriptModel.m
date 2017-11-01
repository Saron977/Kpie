//
//  WX_ScriptModel.m
//  ;

//
//  Created by 王傲擎 on 16/3/31.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ScriptModel.h"

@implementation WX_ScriptModel

+ (instancetype)initModelWithDic:(NSMutableDictionary *)dic
{
    WX_ScriptModel *model = [[WX_ScriptModel alloc]init];
    model.channelid = dic[@"channelid"];
    model.createdate = dic[@"createdate"];
    model.downloadcount = [(NSNumber *)dic[@"downloadcount"] integerValue];
    model.elite = [(NSNumber *)dic[@"elite"] integerValue];
    model.enddate = dic[@"enddate"];
    model.scriptID = dic[@"id"];
    model.isone = [(NSNumber*)dic[@"isone"] integerValue];
    model.jpgurl = dic[@"jpgurl"];
    model.onofftime = dic[@"onofftime"];
    model.scriptcontent = dic[@"scriptcontent"];
    NSString *scriptName = dic[@"scriptname"];
//    model.scriptname = [scriptName substringToIndex:scriptName.length-1];
    model.scriptname = scriptName;
    model.scripttype = [(NSNumber*)dic[@"scripttype"] integerValue];
    model.state = [(NSNumber *)dic[@"state"] integerValue];
    
    NSMutableDictionary *uInfoDic = dic[@"users"];
 
//    model.uInfo_city = dic[@"city"];
//    model.uInfo_emailaddres = dic[@"emailaddress"];
//    model.uInfo_facebook = dic[@"facebook"];
//    model.uInfo_firstname = dic[@"firstname"];
//    model.uInfo_headportrait = dic[@"headportrait"];
//    model.uInfo_lastname = dic[@"lastname"];
//    model.uInfo_middlename = dic[@"middlename"];
//    model.uInfo_mydescription = dic[@"mydescription"];
//    model.uInfo_nationality = dic[@"nationality"];
//    model.uInfo_nickname = dic[@"nickname"];
    model.uInfo_users_sex = [(NSNumber*)uInfoDic[@"sex"] integerValue];
    model.uInfo_users_headportrait = uInfoDic[@"headportrait"];
    model.uInfo_userid = uInfoDic[@"userid"];
    model.uInfo_users_nickname = uInfoDic[@"nickname"];
   
    
    model.userid = dic[@"userid"];
    
    NSArray *videoLenArray = dic[@"videoLensList"];
    model.videoLenArray = [[NSMutableArray alloc]init];
    
//    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(myQueue, ^{
    
        for (int i = 0; i < videoLenArray.count; i++) {
            
            NSMutableDictionary *videoLenDic = videoLenArray[i];
            
            WX_ScriptInfoModel *infoModel = [[WX_ScriptInfoModel alloc]init];
            infoModel.videoLen_actioninfo = videoLenDic[@"actioninfo"];
            infoModel.videoLen_createdate = videoLenDic[@"createdate"];
            infoModel.videoLen_hasnum = videoLenDic[@"hasnum"];
            infoModel.videoLen_id = videoLenDic[@"id"];
            infoModel.videoLen_lensid = [(NSNumber*)videoLenDic[@"lensid"] integerValue];
            infoModel.videoLen_lensjpgurl = videoLenDic[@"lensjpgurl"];
            infoModel.videoLen_lensurl = videoLenDic[@"lensurl"];
            infoModel.videoLen_sceneinfo = videoLenDic[@"sceneinfo"];
            infoModel.videoLen_scriptid = videoLenDic[@"scriptid"];
            infoModel.videoLen_shoots = [(NSNumber*)videoLenDic[@"shoots"] integerValue];
            infoModel.videoLen_talkinfo = videoLenDic[@"talkinfo"];
            infoModel.videoLen_timelength = videoLenDic[@"timelength"];
            infoModel.videoLen_ShootName = [NSString stringWithFormat:@"%@%zi",model.scriptname,infoModel.videoLen_lensid];

            [model.videoLenArray addObject:infoModel];
            
        }
        
//        QNWSLog(@"排序前");
//        for (WX_ScriptInfoModel *infoModel in model.videoLenArray) {
//            QNWSLog(@"infoModel.videoLen_ShootName == %@, infoModel.videoLen_lensid == %zi",infoModel.videoLen_ShootName, infoModel.videoLen_lensid);
//        }
        for (int i = 0;  i < model.videoLenArray.count; i++) {
            WX_ScriptInfoModel *infoModel = model.videoLenArray[i];
            NSInteger num1 = infoModel.videoLen_lensid;
            
            for (int j = i +1; j < model.videoLenArray.count ; j++) {
                WX_ScriptInfoModel *otherInfoModel = model.videoLenArray[j];
                NSInteger num2 = otherInfoModel.videoLen_lensid;
                if (num1 > num2) {
                    QNWSLog(@"顺序出错名 == %@",infoModel.videoLen_ShootName);
                    [model.videoLenArray exchangeObjectAtIndex:j withObjectAtIndex:i];
                                        
                    num1 = num2;
                }
            }
            
            
        }
        
//        QNWSLog(@"排序后");
//        for (WX_ScriptInfoModel *infoModel in model.videoLenArray) {
//            QNWSLog(@"infoModel.videoLen_ShootName == %@, infoModel.videoLen_lensid == %zi",infoModel.videoLen_ShootName, infoModel.videoLen_lensid);
//        }
//    });
    
    
    return model;
}
@end
