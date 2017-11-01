//
//  WX_MoreMusicCell.m
//  kpie
//
//  Created by 王傲擎 on 15/11/12.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_MoreMusicCell.h"
#import "WX_FMDBManager.h"
#import "WX_ProgressHUD.h"

@implementation WX_MoreMusicCell
{
    
    NSMutableData                   *_recData;//接收下载数据
    NSString                        *_filePath;//文件路径
    NSFileManager                   *_fileManager;
    NSFileHandle                    *_fileHandle;//文件操作句柄
    NSURLConnection                 *_downConnection;//下载链接对象
    WX_FMDBManager                  *_manager;
    NSMutableArray                  *_alreadyMusicArray;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    
}


- (IBAction)downTheMusic:(id)sender {
    
//     [self showAndHideHUDWithTitle:@"正在下载" WithState:BYC_MBProgressHUDHideProgress];
    
    [QNWSNotificationCenter postNotificationName:@"showCoverView" object:@"isDown"];
    [WX_ProgressHUD show:@"正在下载"];
    
    _recData = [NSMutableData new];
    
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docArray objectAtIndex:0];
    _filePath = [path stringByAppendingPathComponent:@"Music"];
    _fileManager = [NSFileManager defaultManager];
    [_fileManager createDirectoryAtPath:_filePath withIntermediateDirectories:YES attributes:nil error:nil];
    _filePath = [_filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",self.model.musicName]];
    QNWSLog(@"filePath==%@",_filePath);
    
    [self downTheMusic];
}

-(void)downTheMusic
{
    //创建可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.model.musicUrl]];
    
    //NSFileManager:文件管理类.管理文件的创建,删除,是否存在
    //NSFileHandle:文件操作类.文件的读,写.文件指针的移动
    _fileManager = [NSFileManager defaultManager];
    
    //判断文件是否存在
    if([_fileManager fileExistsAtPath:_filePath])
    {
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
        
    }else
    {
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
    
    QNWSLog(@"request=%@",request);
}
#pragma mark -NSURLConnectionDataDelegate
//接收到了响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    QNWSLog(@"expectedContentLength==%lld",response.expectedContentLength);
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
    //写入沙盒
    [_fileHandle writeData:_recData];
    
    NSString *message = [NSString stringWithFormat:@"%@ 下载完成",self.model.musicName];
//    [self showAndHideHUDWithTitle:message WithState:BYC_MBProgressHUDHideProgress];
    
    [WX_ProgressHUD show:message];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
    
    
    /// 写入数据库
    _manager = [WX_FMDBManager sharedWX_FMDBManager];
    
    if (![_manager.dataBase executeUpdate:@"insert into Music(musicID,musicName,musicUrl,pictureJPG,musicType,timeStamp,musicPath) values(?,?,?,?,?,?,?)",self.model.musicID,self.model.musicName,self.model.musicUrl,self.model.pictureJPG,self.model.musicType,self.model.timeStamp,_filePath]) {
        QNWSLog(@"视频拍摄数据库信息----- 插入失败");
    }else{
        if (self.block) {
            self.block(YES);
        }
    }
    
    [QNWSNotificationCenter postNotificationName:@"showCoverView" object:@"success"];
 
}
//下载失败
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    QNWSLog(@"下载失败,error=%@",error);
    
    [WX_ProgressHUD show:@"下载失败"];
    
    [QNWSNotificationCenter postNotificationName:@"showCoverView" object:@"fail"];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dismissTheHUD) userInfo:nil repeats:NO];
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.titleLabel.textColor = KUIColorFromRGB(0x4BC8BD);
//        classLabel.textColor = KUIColorFromRGB(0x4BC8BD);
//        selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-h."];
    }else {
        self.titleLabel.textColor = KUIColorFromRGB(0x34f5e);
//        classLabel.textColor = KUIColorFromRGB(0xffffff);
//        selectImgView.image = [UIImage imageNamed:@"icon-xuanzhe-n."];
        
    }
}

-(void)dismissTheHUD
{
    [WX_ProgressHUD dismiss];
}

@end
