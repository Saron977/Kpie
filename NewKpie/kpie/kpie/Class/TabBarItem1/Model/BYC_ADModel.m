//
//  BYC_ADModel.m
//  kpie
//
//  Created by 元朝 on 16/1/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ADModel.h"

@implementation BYC_ADModel

+ (instancetype)initModelWithArray:(NSArray *)array type:(ADType)ADType {

    BYC_ADModel *model = [[BYC_ADModel alloc] init];
//    model.advertID      = array[0];
//    model.advertImg     = array[1];
//    model.advertType    = [array[2] integerValue];
//    model.advertUrl     = array[3];
//    model.opens         = [array[4] integerValue];
//    switch (ADType) {
//        case ADTypeVideo:
//
//            model.videoID       = array[5];
//            model.videoTitle    = array[6];
//            model.userID        = array[7];
//            model.videoMP4      = array[8];
//            model.GPSX          = [array[9] integerValue];
//            model.GPSY          = [array[10] integerValue];
//            model.pictureJPG    = array[11];
//            model.videoDescription = array[12];
//            model.upLoadTime    = array[13];
//            model.comments      = [array[14] integerValue];
//            model.favorites     = [array[15] integerValue];
//            model.views         = [array[16] integerValue];
//            model.cateID        = array[17];
//            model.videoIndex    = [array[18] integerValue];
//            model.onOffTime     = array[19];
//            model.headPortrait  = array[20];
//            model.nickName      = array[21];
//            model.sex           = [array[22] boolValue];
//            model.scriptID      = array[23];
////            model.isVR          = [(NSNumber *)array[24] integerValue];
//            break;
//        case ADTypeColumn:
//            
//            model.columnID    = array[5];
//            model.columnName  = array[6];
//            model.secondCover = array[7];
//            model.columnDesc  = array[8];
//            model.onOffTime   = array[9];
//            model.theMeName   = array[10];
//            model.channelID   = array[11];
//            break;
//            case ADTypeWeb:
//            
//            break;
//        default:
//            
//            break;
//    }

    return model;
}

+ (instancetype)initModelWithDictionary:(NSDictionary *)dictionary {
    
    BYC_ADModel *model = [super initModelWithDictionary:dictionary];
    model.advertList1 = [BYC_ADModel initModelsWithArrayDic:dictionary[@"advertList1"]];
    model.advertList2 = [BYC_ADModel initModelsWithArrayDic:dictionary[@"advertList2"]];
    return model;
}

@end
