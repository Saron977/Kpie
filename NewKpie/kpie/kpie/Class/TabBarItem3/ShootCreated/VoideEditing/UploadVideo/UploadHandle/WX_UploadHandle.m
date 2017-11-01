//
//  WX_UploadHandle.m
//  kpie
//
//  Created by 王傲擎 on 16/9/18.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_UploadHandle.h"
#import "BYC_AliyunOSSUpload.h"
#import "WX_UploadProgress.h"
#import "WX_UploadDisplay.h"

@interface WX_UploadHandle() 
@property (nonatomic, assign) NSInteger                 timeNum;
@property (nonatomic, strong) WX_UploadHandleModel      *model_UploadHandle;    /**<   上传模型 */
@property (nonatomic, strong) WX_DBBoxModel             *model_DBBox;           /**<   存入数据库模型 */
@property (nonatomic, strong) WX_UploadProgress         *uploadProgress;        /**<   进度条 */
@property (nonatomic, assign) BOOL                      isRemove;               /**<   已经移除监听 */
@property (nonatomic, assign) BOOL                      isShare;                /**<   需要分享 */
@property (nonatomic, strong) WX_ShareModel             *model_Share;           /**<   模型_分享 */
@property (nonatomic, assign) NSInteger                 integer_NeedShareCounts;/**<   需要分享次数 */
@property (nonatomic, assign) BOOL                      isShareQQ;              /**<   需要分享qq */
@property (nonatomic, assign) BOOL                      isShareWeChat;          /**<   需要分享微信 */
@property (nonatomic, assign) BOOL                      isShareWeChatMonents;   /**<   唔要分享朋友圈 */
@property (nonatomic, assign) BOOL                      isShareWeibo;           /**<   需要分享微博 */

@end

@implementation WX_UploadHandle
QNWSSingleton_implementation(WX_UploadHandle)

+(void)uploadVideoWithModel:(WX_UploadHandleModel *)model
{
    WX_UploadHandle *uploadHandle = [WX_UploadHandle sharedWX_UploadHandle];
    
    if (model.ENUM_UploadType == ENUM_UploadDefault){
        
        [uploadHandle uploadVideoToAliyunOSSUploadWithModel:model];
        
        [uploadHandle progressInit];
        
        uploadHandle.isUploading = YES;
    }
}

+(void)writeToDraftBoxModel:(WX_DBBoxModel*)model Compeleted:(void(^)(ENUM_WriteToDBoxType type))complete
{
    WX_UploadHandle *uploadHandle = [WX_UploadHandle sharedWX_UploadHandle];
    
    [uploadHandle writeToDBBoxUseFMDBWithModel:model Compeleted:^(ENUM_WriteToDBoxType type) {
        complete(type);
    }];
}

+(void)WX_ShareVideoWithModel:(WX_ShareModel *)model NeedShareCounts:(NSInteger)counts ShareQQ:(BOOL)isShareQQ ShareWeChat:(BOOL)isShareWeChat ShareWeChatMonents:(BOOL)isWeChatMonents ShareWeiBo:(BOOL)isShareWeiBo
{
    WX_UploadHandle *uploadHandle           =   [WX_UploadHandle sharedWX_UploadHandle];
    uploadHandle.isShare                    =   YES;
    uploadHandle.model_Share                =   model;
    uploadHandle.integer_NeedShareCounts    =   counts;
    uploadHandle.isShareQQ                  =   isShareQQ;
    uploadHandle.isShareWeChat              =   isShareWeChat;
    uploadHandle.isShareWeChatMonents       =   isWeChatMonents;
    uploadHandle.isShareWeibo               =   isShareWeiBo;
}

/**
 *  创建进度条
 */
-(void)progressInit
{
    [WX_UploadDisplay createUploadDisplay];
}

/**
 *  上传视频至阿里云
 *
 *  @param model 上传视频模型
 */
-(void)uploadVideoToAliyunOSSUploadWithModel:(WX_UploadHandleModel *)model
{
    self.model_UploadHandle = model;
    self.isRemove = YES;
    [self ObserverManagerWithAddOrRemove:YES];
    
    [self uploadAliyunVideoComplete:^(BOOL complete) {
        if (complete) {
            // 成功
            
        }else{
            // 失败
            
        }
    }];
}

/**
 *  上传视频资源至阿里云
 *
 *  @param complete 完成回调
 */
-(void)uploadAliyunVideoComplete:(void(^)(BOOL complete))complete
{
    /**
     *  上传视频资源
     *
     *  @param finished 完成回调
     *
     *  @return 上传进度回调
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [BYC_AliyunOSSUpload uploadWithProgressObjectKey:_model_UploadHandle.key_Video Data:_model_UploadHandle.data_Video andType:resourceTypeVideo completion:^(BOOL finished) {
            
            if (finished) {

                _model_UploadHandle.ENUM_UploadType = ENUM_AliyunVideoSuccess;
                QNWSLog(@"视频上传成功");
                complete(YES);
            }else{
                _model_UploadHandle.ENUM_UploadType = ENUM_AliyunVideoFail;
                complete(NO);
            }
            
        } progressVale:^(CGFloat progressVale) {
            QNWSLog(@"progressVale == %f",progressVale);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [WX_UploadDisplay uploadValue:progressVale*0.8];
            });
        }];
    });
    
}

/**
 *  上传封面资源至阿里云
 *
 *  @param complete 完成回调
 */
-(void)uploadAliyunImageComplete:(void(^)(BOOL complete))complete
{
    /**
     *  上传视频封面资源
     *
     *  @param finished 完成回调
     *
     *  @return 上传封面进度回调
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [BYC_AliyunOSSUpload uploadWithProgressObjectKey:_model_UploadHandle.key_Image Data:_model_UploadHandle.data_Image andType:resourceTypeImage completion:^(BOOL finished) {
            
            if (finished) {
                _model_UploadHandle.ENUM_UploadType = ENUM_AliyunImageSuccess;
                QNWSLog(@"截图上传成功");
                complete(YES);
            }else{
                _model_UploadHandle.ENUM_UploadType = ENUM_AliyunImageFail;
                complete(NO);
            }
            
        } progressVale:^(CGFloat progressVale) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [WX_UploadDisplay uploadValue:progressVale*0.1+0.8];
            });
        }];
    });
}

/**
 *  上传至服务器
 *
 *  @param model 上传模型
 */
-(void)uploadVideoKpieWithModel:(WX_UploadHandleModel*)model
{
//    {"description":"#歌舞青春##教育培训#",
//    "gpsx":0,
//    "gpsy":0,
//    "isapply":true,
//    "picturejpg":"http://images.kpie.com.cn/videos/20161028/5bd59c74-e888-4521-ad4a-961aadc3a68d",
//    "userid":"f809c2c7f60840d88914d287504a367d",
//    "videomp4":"http://videos.kpie.com.cn/videos/20161028/e73bb234-ce3f-4ae8-bfee-29652f92c89d.mp4",
//    "videotitle":""}

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:model.description_video forKey:@"description"];
    [dic setValue:model.gpsX_Video.length > 0 ? model.gpsX_Video : @"0" forKey:@"gpsx"];
    [dic setValue:model.gpsY_Video.length > 0 ? model.gpsY_Video : @"0" forKey:@"gpsy"];
    [dic setValue:[NSNumber numberWithBool:[model.teachApply boolValue]] forKey:@"isapply"];
    [dic setValue:model.path_Image forKey:@"picturejpg"];
    [dic setValue:model.userID_User forKey:@"userid"];
    [dic setValue:model.path_Video forKey:@"videomp4"];
    [dic setValue:model.title_Video forKey:@"videotitle"];
    
    if (model.strID_Video.length>0) {
    
        [dic setValue:model.strID_Video forKey:@"scriptid"];
    }

    
//http://192.168.1.233:8080/comments/post?videoid=8aad310a564f7b7f01565f09e9b10dd0&content=哈哈&userid=8a29f34850a856d40150adf9b23c0147&isvoice=false
    
//    http://192.168.1.233:8080/video/upload?userid=8a29f34850a856d40150adf9b23c0147&gpsy=0&videomp4=http://sz-kpie-test.oss-cn-shenzhen.aliyuncs.com/videos/20161104/413dcb04-5852-4def-acbf-c0e7a60652e8.mp4&picturejpg=http://sz-kpie-test.oss-cn-shenzhen.aliyuncs.com/videos/20161104/ad7bae91-f48d-4eb6-b11b-f05f8d099433.png&isapply=0&description=&gpsx=0
    
//    [dic setValue:model.userID_Video forKey:@"video.userid"];
//    [dic setValue:model.strID_Video forKey:@"strid"];
//    [dic setValue:model.themeid_Video forKey:@"video.themeid"];
//    [dic setValue:model.token_User forKey:@"token"];
    if (model.videoId_VideoType == 2) {
        [dic setValue:model.videoID_Activity forKey:@"videoid"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [BYC_HttpServers PostWithProgress:KQNWS_PostUploadVideoUrl parametersWithToken:dic UploadProgress:^(CGFloat uploadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WX_UploadDisplay uploadValue:uploadProgress*0.1+0.9];
            });
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            WX_UploadHandle *uploadHandle           =   [WX_UploadHandle sharedWX_UploadHandle];

            uploadHandle.model_Share.share_VideoID  =   responseObject[@"data"][@"videoid"];
            if (model.isFromDraftBox) {
                WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];
                if (![manager.dataBase executeUpdate:@"delete from DraftBox1 where mediaTitle = ?",model.title_DraftBox]){
                    QNWSLog(@"数据库删除失败");
                }
            }
            NSInteger upLoad_Result = [(NSNumber*)responseObject[@"success"] integerValue];
            if(upLoad_Result == 1){
                model.ENUM_UploadType = ENUM_KpieSuccess;
            }else{
                model.ENUM_UploadType = ENUM_KpieFail;
            }
            NSString *str_Msg   =   responseObject[@"msg"];
            if (str_Msg.length>0) {
                [[UIView alloc] showAndHideHUDWithTitle:str_Msg WithState:BYC_MBProgressHUDHideProgress];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            QNWSLog(@"本地上传失败,error == %@",error);
            model.ENUM_UploadType = ENUM_KpieFail;
        }];
    });
}


-(void)timeOut
{
    _timeNum ++;
    if (_timeNum>= 30) {
        [[UIView alloc] showAndHideHUDWithTitle:@"网络超时,请重试" WithState:BYC_MBProgressHUDHideProgress];
    }
}

/**
 *  视频信息存入数据库
 *
 *  @param model    模型
 *  @param complete 完成回调
 */
-(void)writeToDBBoxUseFMDBWithModel:(WX_DBBoxModel*)model Compeleted:(void(^)(ENUM_WriteToDBoxType type))complete
{
    _model_DBBox = model;
    
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:@"Media"];
    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.mp4",_model_DBBox.mediaTitle]];
    /// 是否存在
    BOOL isEqual = NO;
    /// 是否更新
    BOOL isUpdate = NO;
    WX_FMDBManager *manager = [WX_FMDBManager sharedWX_FMDBManager];
    FMResultSet *rs = [manager.dataBase executeQuery:@"select * from DraftBox1"];
    if (rs == nil) {
        if (![manager.dataBase executeUpdate:@"create table if not exists DraftBox1(id integer primary key autoincrement,title text,mediaTitle text,mediaPath text,imgDataStr text,contents text,glocation text, type text, videoID text)"]) {
            QNWSLog(@"数据库---DraftBox1表创建失败");
        }else{
            QNWSLog(@"数据库--DraftBox表创建成功");
        }
    }else{
        while ([rs next]) {
            NSString *media_Path = [rs stringForColumn:@"mediaPath"];
            NSString *media_Contents = [rs stringForColumn:@"contents"];
            NSString *media_Glocation = [rs stringForColumn:@"glocation"];
            NSString *media_Title = [rs stringForColumn:@"mediaTitle"];
            
            if ([media_Title isEqualToString:_model_DBBox.mediaTitle] ) {
                isEqual = YES;
                if (![media_Contents isEqualToString:model.contents]) {
                    /// 更新语句
                    NSString * update = [NSString stringWithFormat:@"update DraftBox1 set contents = '%@' where mediaPath = '%@'",model.contents,media_Path];
                    BOOL isSuccess = [manager.dataBase executeUpdate:update];
                    
                    if (!isSuccess) {
                        QNWSLog(@"视频信息更新失败");
                    }else{
                        QNWSLog(@"视频信息更新成功");
                        isUpdate = YES;
                    }
                    
                }
                if (![media_Glocation isEqualToString:model.location] && model.location.length > 0){
                    /// 更新语句
                    NSString * update = [NSString stringWithFormat:@"update DraftBox1 set glocation = '%@' where mediaPath = '%@'",model.location,media_Path];
                    BOOL isSuccess = [manager.dataBase executeUpdate:update];
                    
                    if (!isSuccess) {
                        QNWSLog(@"地点数据更新失败");
                    }else{
                        QNWSLog(@"地点数据更新成功");
                        isUpdate = YES;
                    }
                }
            }
        }
    }
    
    if (isUpdate && isEqual){
        complete(ENUM_UpdataSuccess);

    }else if (!isUpdate && isEqual) {
        complete(ENUM_AlreadyExisted);
        
    }else if(!isEqual) {
        if (![manager.dataBase executeUpdate:@"insert into DraftBox1(title,mediaTitle,mediaPath,imgDataStr,contents,glocation,type,videoID) values(?,?,?,?,?,?,?,?)",model.title,model.mediaTitle,filePath,model.imgDataStr,model.contents,model.location,[NSString stringWithFormat:@"%zi",model.media_Type],model.videoID]) {
            QNWSLog(@"视频拍摄数据库信息----- 插入失败");
        }else{
            complete(ENUM_WriteSuccess);

        }
    }
}

/**
 *  上传失败,保存到草稿箱
 */
-(void)uploadFailedWriteToDBox
{
    WX_DBBoxModel *model_DBox   =   [[WX_DBBoxModel alloc]init];
    model_DBox.title            =   _model_UploadHandle.title_Video;
    model_DBox.mediaTitle       =   _model_UploadHandle.title_DraftBox;
    model_DBox.contents         =   _model_UploadHandle.description_video;
    model_DBox.location         =   _model_UploadHandle.loaction;
    model_DBox.imgDataStr       =   _model_UploadHandle.str_ImageData;
    model_DBox.media_Type       =   _model_UploadHandle.videoId_VideoType;
    model_DBox.videoID          =   _model_UploadHandle.videoID_Activity;
    
    [self writeToDBBoxUseFMDBWithModel:model_DBox Compeleted:^(ENUM_WriteToDBoxType type) {
        switch (type) {
            case ENUM_WriteSuccess:
            {
                dispatch_async(dispatch_get_main_queue(), ^{

                    [[UIView alloc] showAndHideHUDWithTitle:@"上传失败,已保存到草稿箱" WithState:BYC_MBProgressHUDHideProgress];
                });

            }
                break;
            case ENUM_UpdataSuccess:
            {
                dispatch_async(dispatch_get_main_queue(), ^{

                    [[UIView alloc] showAndHideHUDWithTitle:@"上传失败,已保存到草稿箱" WithState:BYC_MBProgressHUDHideProgress];
                });

            }
                break;
            case ENUM_AlreadyExisted:
            {
                dispatch_async(dispatch_get_main_queue(), ^{

                    [[UIView alloc] showAndHideHUDWithTitle:@"上传失败,保存到草稿箱失败" WithState:BYC_MBProgressHUDHideProgress];
            });

            }
                break;
                
            default:
                break;
        }
    }];
}

/**
 *  监听管理
 *
 *  @param operation 创建或者删除
 */
-(void)ObserverManagerWithAddOrRemove:(BOOL)operation
{
    if (operation) {
        if (_isRemove)[_model_UploadHandle addObserver:self forKeyPath:@"ENUM_UploadType" options:NSKeyValueObservingOptionInitial context:nil];
        _isRemove = NO;
    }else{
        
        if (!_isRemove)[_model_UploadHandle removeObserver:self forKeyPath:@"ENUM_UploadType"];
        _isRemove = YES;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"ENUM_UploadType"]) {
        
        switch (_model_UploadHandle.ENUM_UploadType) {
            case ENUM_AliyunVideoSuccess:
            {
                [self uploadAliyunImageComplete:^(BOOL complete) {
                    
                }];
            }
                break;
            case ENUM_AliyunVideoFail:
            {
                [self uploadFailedWriteToDBox];
                
                [self ObserverManagerWithAddOrRemove:NO];
                
                [WX_UploadDisplay removeFromSuperview];

                [self resetStatusDefault];
            }
                break;
                
            case ENUM_AliyunImageSuccess:
            {
                [self uploadVideoKpieWithModel:_model_UploadHandle];
                
            }
                break;
            case ENUM_AliyunImageFail:
            {
                [self uploadFailedWriteToDBox];
                
                [self ObserverManagerWithAddOrRemove:NO];
                
                [WX_UploadDisplay removeFromSuperview];

                [self resetStatusDefault];
            }
                break;
            case ENUM_KpieSuccess:
            {
                dispatch_async(dispatch_get_main_queue(), ^{

                    [[UIView alloc] showAndHideHUDWithTitle:@"视频上传成功" WithState:BYC_MBProgressHUDHideProgress];
                });
                [QNWSNotificationCenter postNotificationName:KNotification_RefreshFocusVCData object:nil];
                
                [self ObserverManagerWithAddOrRemove:NO];
                
                if (self.isShare)[self needShareVideoWithModel:_model_Share NeedShareCounts:_integer_NeedShareCounts ShareQQ:_isShareQQ ShareWeChat:_isShareWeChat ShareWeChatMonents:_isShareWeChatMonents ShareWeiBo:_isShareWeibo];
                
                [self resetStatusDefault];
                
            }
                break;
            case ENUM_KpieFail:
            {
                [self uploadFailedWriteToDBox];
                
                [self ObserverManagerWithAddOrRemove:NO];
                
                [WX_UploadDisplay removeFromSuperview];
                
                [self resetStatusDefault];
            }
                break;
            default:
                break;
        }
    }
    

}

-(void)needShareVideoWithModel:(WX_ShareModel *)model NeedShareCounts:(NSInteger)counts ShareQQ:(BOOL)isShareQQ ShareWeChat:(BOOL)isShareWeChat ShareWeChatMonents:(BOOL)isWeChatMonents ShareWeiBo:(BOOL)isShareWeiBo
{
    [WX_ShareHandle WX_ShareVideoWithModel:model NeedShareCounts:counts ShareQQ:isShareQQ ShareWeChat:isShareWeChat ShareWeChatMonents:isWeChatMonents ShareWeiBo:isShareWeiBo];
}


/**
 重置单例状态
 */
-(void)resetStatusDefault
{
    self.model_UploadHandle         =   nil;
    self.model_DBBox                =   nil;
    self.model_Share                =   nil;
    self.uploadProgress             =   nil;
    self.isRemove                   =   NO;
    self.isShare                    =   NO;
    self.integer_NeedShareCounts    =   0;
    self.isShareQQ                  =   NO;
    self.isShareWeChat              =   NO;
    self.isShareWeChatMonents       =   NO;
    self.isShareWeibo               =   NO;
    self.isUploading                =   NO;
    
}
-(void)dealloc
{
    QNWSLog(@"%s 掉了",__func__);
}

@end
