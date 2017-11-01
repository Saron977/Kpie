//
//  ffmpegutils.h
//  ffmpegutils
//
//  Created by Shamozhu on 15/11/16.
//  Copyright © 2015年 kpie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ffmpegutils : NSObject {
    
    
}
/**
 *  日志路径
 */
@property (nonatomic) char *logPath;
@property (nonatomic) BOOL isDebug;

/**
 *  执行视频处理命令
 *
 *  @param arg 命令字符串
 *
 *  @return 成功0,其它失败
 */
-(int)runFfmpeg:(NSString*) arg;

/**
 *  处理拍摄的视频
 *
 *  @param sourcePath 视频源文件路径
 *  @param outPath    处理好的视频输出路径
 *  @param flag       旋转角度，对应拍摄的摄像头，前置 2(逆时针90度), 后置 1（顺时针90度）
 *
 *  @return 成功0,其它失败
 */
-(int)rotationVideo:(NSString*) sourcePath AndCrop:(NSString*) outPath WithFlag:(int) flag;


/**
 *  处理拍摄的视频
 *
 *  @param sourcePath 视频拼接格式文件
 *  @param outPath    处理好的视频输
 *
 *  @return 成功0,其它失败
 */
-(int)concatVideo:(NSString*) sourcePath OutTo:(NSString*) outPath;



-(int)createVideo:(NSMutableArray*) sourcePath WithStart:(NSMutableArray*) startArray AndEnd:(NSMutableArray*) endArray DisableSound:(BOOL) disableSound HasMusicPath:(NSString*)hasMusic LogoPath:(NSString*) logoPath ToPath:(NSString*) path;



-(int)importVideo:(NSString*) inPath InVideoWidth:(int) in_w AndHeight:(int) in_h AtOffsetX:(int) offsetX AndOffsetY:(int) offsetY OutputVideoWidth:(int) o_w AndHeigth:(int) o_h WithStart:(int) start AndWithEnd:(int) end AndRotate:(int) rotate AndOutputVideoPath:(NSString*) outPath;

/**
 * @param fileName 图片路径列表
 * @param fileCount 图片个数
 * @outFileName 输出视频文件路径
 * @photoAAC 空音频流文件
 * @sizeArray 图片旋转角度，长，宽参数数组，数组中每一项为一个NSMutableArray*里面存放NSNumber* 旋转角度，长，宽数值
 * 旋转角度：0不旋转，1顺时针90，2逆时针90，3顺时针180，4逆时针180
 * return int 成功 0 其它失败
 * */
-(int)createVideoByPhotoPath:(NSMutableArray*) fileName WithCount:(NSNumber*) fileCount AndOutPath:(NSString*) outFileName AndAACPath:(NSString*) photoAAC WithSize:(NSMutableArray*) sizeArray;

/**
 获取视频信息
 */
-(NSMutableArray*)getVideoInfo:(NSString*) videoPath;

@end


