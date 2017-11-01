//
//  UIImageView+BYC_FadeInImage.m
//  kpie
//
//  Created by 元朝 on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "UIImageView+BYC_FadeInImage.h"
#import "BYC_RuntTime.h"

@implementation UIImageView (BYC_FadeInImage)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingMethod];
    });
}

+(void)swizzlingMethod{

    SwizzlingMethod([UIImageView class], @selector(sd_setImageWithURL: placeholderImage: options: progress: completed:), @selector(byc_setImageWithURL:placeholderImage:options:progress:completed:));
}

- (void)byc_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:( SDWebImageCompletionBlock)completedBlock {
    
    SDWebImageCompletionBlock completedBlock1 = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && cacheType == SDImageCacheTypeNone) {
            
            self.alpha = 0.0f;
            [UIView animateWithDuration:0.75f animations:^{
                
                self.alpha = 1.0f;
            }];
        }else self.alpha = 1.0f;
        QNWSBlockSafe(completedBlock,image, error, cacheType, url);
    };
    [self byc_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock1];
}

@end
