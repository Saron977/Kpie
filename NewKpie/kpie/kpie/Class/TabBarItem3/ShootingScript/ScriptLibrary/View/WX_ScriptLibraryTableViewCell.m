//
//  WX_ScriptLibraryTableViewCell.m
//  kpie
//
//  Created by 王傲擎 on 16/4/11.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "WX_ScriptLibraryTableViewCell.h"
#import "WX_FMDBManager.h"
#import "WX_ProgressHUD.h"

@implementation WX_ScriptLibraryTableViewCell
{
    NSMutableData                   *_recData;              /**<    接收下载数据  */
    NSString                        *_filePath;             /**<    文件路径    */
    NSFileManager                   *_fileManager;
    NSFileHandle                    *_fileHandle;           /**<    文件操作句柄  */
    NSURLConnection                 *_downConnection;       /**<    下载链接对象  */
    WX_FMDBManager                  *_manager;
    NSInteger                       _downNum;               /**<   下载个数 2个 0__1 */

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _scriptTitleImgView.layer.masksToBounds = YES;
    _scriptTitleImgView.layer.cornerRadius = 10.f;
    // Initialization code
}


// 点击下载
- (IBAction)DownloadScript:(id)sender {
    UIButton *btn = (UIButton *)sender;
    _downNum = 0;
    if (btn.selected) {
        return;
    }else{
        
        [QNWSNotificationCenter postNotificationName:@"touchMoreButton" object:[NSNumber numberWithBool:NO]];
        
        [WX_ProgressHUD show:@"正在下载"];
        
        _recData = [NSMutableData new];
        
        [self createDownLoadWithScriptNum:0];
    }
}


#pragma mark ------ 下载剧本

-(void)createDownLoadWithScriptNum:(NSInteger)scriptNum
{
    _manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    _filePath = [path stringByAppendingPathComponent:@"Script"];
    _fileManager = [NSFileManager defaultManager];
    [_fileManager createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil];

    WX_ScriptInfoModel *infoModel = _scriptModel.videoLenArray[scriptNum];
    
    _filePath = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",infoModel.videoLen_ShootName]];
    QNWSLog(@"filePath==%@",_filePath);
    
    [self downTheScriptWithUrlStr:infoModel.videoLen_lensurl];
}

-(void)downTheScriptWithUrlStr:(NSString*)urlStr
{
    
    
    QNWSLog(@"urlStr == %@",urlStr);
    //创建可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    //NSFileManager:文件管理类.管理文件的创建,删除,是否存在
    //NSFileHandle:文件操作类.文件的读,写.文件指针的移动
    _fileManager = [NSFileManager defaultManager];
    
    //判断文件是否存在
    if([_fileManager fileExistsAtPath:_filePath]){
        //存在.接着前面的部分往后追加(断点续传)
        
        //获取文件操作句柄
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_filePath];
        
        //将句柄移动到文件末尾
        [_fileHandle seekToEndOfFile];
        
        //获取到已下载文件的长度
        long long fileLength = _fileHandle.offsetInFile;
        
        //设置range头域
        [request addValue:[NSString stringWithFormat:@"bytes=%lld-",fileLength] forHTTPHeaderField:@"Range"];
        
        //发起请求
        _downConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
    }else{
        //不存在.从零开始下载
        
        //创建这个文件
        [_fileManager createFileAtPath:_filePath contents:nil attributes:nil];
        
        //获取文件操作句柄
        //fileHandleForUpdatingAtPath  读和写
        //fileHandleForReadingAtPath   只读
        //fileHandleForWritingAtPath   只写
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:_filePath];
        
        //发起网络请求
        _downConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
}

#pragma mark -NSURLConnectionDataDelegate
//接收到了响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    //    QNWSLog(@"expectedContentLength==%lld",response.expectedContentLength);
    //总长度是2048
    //文件不存在 expectedContentLength   2048
    //文件存在,长度是1024   expectedContentLength  1024
    _recData.length = 0;
    
    
}
//接收到了数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //数据拼接
    [_recData appendData:data];
    
    
}

#pragma mark ------------ NSURLConnectionDataDelegate
//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_fileHandle writeData:_recData];
    
    if (_downNum < _scriptModel.videoLenArray.count) {
        
        WX_ScriptInfoModel *infoModel = _scriptModel.videoLenArray[_downNum];
        
        
        if (![_manager.dataBase executeUpdate:@"insert into Script3(titleName,scriptID,scriptName,scriptUrl,pictureJPGUrl,actioninfo,timelength,jpgurl,content) values(?,?,?,?,?,?,?,?,?)",_scriptModel.scriptname,_scriptModel.scriptID,infoModel.videoLen_ShootName,infoModel.videoLen_lensurl,infoModel.videoLen_lensjpgurl,infoModel.videoLen_actioninfo,infoModel.videoLen_timelength,infoModel.videoLen_lensjpgurl,_scriptModel.scriptcontent]){
            QNWSLog(@"视频拍摄数据库信息----- 插入失败");
        }else{
            QNWSLog(@"写入信息成功");
        }
        
        
        if (_downNum < _scriptModel.videoLenArray.count -1) {
            
            [self createDownLoadWithScriptNum:_downNum+1];
        }else{
            [WX_ProgressHUD showSuccess:@"下载成功"];
             [QNWSNotificationCenter postNotificationName:@"touchMoreButton" object:[NSNumber numberWithBool:YES]];
            [QNWSNotificationCenter postNotificationName:@"alreadyDownloadScript" object:nil];
        }
        
        _downNum++;
    }else{
        
        [WX_ProgressHUD showSuccess:@"下载失败"];
         [QNWSNotificationCenter postNotificationName:@"touchMoreButton" object:[NSNumber numberWithBool:YES]];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];

        
    }
    
}
//下载失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    QNWSLog(@"下载失败,error=%@",error);
    
    [WX_ProgressHUD show:@"下载失败"];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
    
     [QNWSNotificationCenter postNotificationName:@"touchMoreButton" object:[NSNumber numberWithBool:YES]];
    
}

#pragma mark ------ 下载失败, 清空模型
-(void)dismissTheHUD
{
    [WX_ProgressHUD dismiss];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
