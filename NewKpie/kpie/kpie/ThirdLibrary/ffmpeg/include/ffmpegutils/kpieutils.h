//
//  kpieutils.h
//  ffmpegutils
//
//  Created by Shamozhu on 16/1/7.
//  Copyright © 2016年 kpie. All rights reserved.
//

#ifndef kpieutils_h
#define kpieutils_h
#include <unistd.h>
#include <stdio.h>


int ffmpeg_main(int argc, char **argv, char *logPath);
int* getVideoInfo(const char* videoPath);
int getSpaceCount(char* str);
int createVideoByPhoto(char** fileName, int fileCount, const char* outFileName, int** pSize, const char* photoAAC, char* logPath);
int runCmd(char *pCmd, char *logPath);

/**
 * @param fileName 文件列表
 * @param fileCount 文件个数
 * @param templateNO 效果编号
 * @param offset 文字出现时间偏移值
 * @param overlayMax 隐藏文字时间点值
 * @param videoFadeIn 文字淡入效果时长
 * @outFileName 输出视频文件路径
 * return int 成功 0 其它失败
 */
int createOverlayVideo(char** fileName, int fileCount, int templateNO, float offset, float overlayMax, float videoFadeIn, const char* outFileName, char* logPath);



#endif /* kpieutils_h */
