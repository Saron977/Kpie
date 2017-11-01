//
//  BYC_BaseVideoModel.m
//  kpie
//
//  Created by 元朝 on 16/8/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseVideoModel.h"
#import "MJExtension.h"

@implementation BYC_BaseVideoModel
MJExtensionCodingImplementation
+ (instancetype)initModelWithArray:(NSArray *)array {
    
    
    BYC_BaseVideoModel     *model = [[self alloc] init];
//    model.videoID          = array[0];//视频的id
//    model.videoTitle       = array[1];//视频的标题
//    model.userID           = array[2];//上传该视频的用户的id
//    model.videoMP4         = array[3];//mp4的地址
//    model.GPSX             = [(NSNumber *)array[4] doubleValue];//上传该视频的时候的用户地理坐标
//    model.GPSY             = [(NSNumber *)array[5] doubleValue];//上传该视频的时候的用户地理坐标
//    model.pictureJPG       = array[6];//视频的截图的地址
//    model.videoDescription = array[7];//该视频的描述
//    model.upLoadTime       = array[8];//该视频的上传时间
//    model.comments         = [(NSNumber *)array[9] integerValue];//该视频的评论数
//    model.favorites        = [(NSNumber *)array[10] integerValue];//该视频的收藏量
//    model.views            = [(NSNumber *)array[11] integerValue];//该视频的点击量
//    model.cateID           = array[12];//所属剧集的编号
//    model.videoIndex       = [(NSNumber *)array[13] integerValue];//这个视频属于第几集
//    model.onOffTime        = array[14];//视频的上架时间（也就是属于上传时间）
//    model.headPortrait     = array[15];//上传该视频的用户头像的地址
//    model.nickName         = array[16];//上传该视频的用户的昵称
//    model.sex              = [(NSNumber *)array[17] boolValue];//上传该视频的用户的性别
//    model.scriptID         = array[18];//上传的视频属于剧本就有这个id，不是剧本就没有。（播放界面的“我来拍”，就是用这个控
    
    return model;
}

+ (NSArray *)initModelsWithArray:(NSArray *)array {
    
    return [[self mj_objectArrayWithKeyValuesArray:array] copy];
}

+ (instancetype)initModelWithDictionary:(NSDictionary *)dictionary {

//    BYC_BaseVideoModel *model = [super initModelWithDictionary:dictionary];
//    model.video_Description = dictionary[@"description"];
    return [BYC_BaseVideoModel mj_objectWithKeyValues:dictionary];
}

-(void)setPicturejpg:(NSString *)picturejpg {

    _picturejpg =  [picturejpg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BYC_AccountModel *)users {

    if (!_users) _users = [BYC_AccountModel new];
    return _users;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"video_Description" : @"description"};
}

@end
