//
//  MJRefreshHeader+BYC_RefreshGifHeader.m
//  kpie
//
//  Created by 元朝 on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "MJRefreshHeader+BYC_RefreshGifHeader.h"
#import "BYC_RuntTime.h"

@interface MJRefreshHeader()

/**刷新动画的图片数组*/
@property (nonatomic,strong) NSMutableArray *mArr_RefreshImages;
/**普通状态下的图片数组*/
@property (nonatomic,strong) NSMutableArray *mArr_NormalImages;

@end

@implementation MJRefreshHeader (BYC_RefreshGifHeader)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingMethod];
    });
}

+(void)swizzlingMethod{
    
    SwizzlingMethod([MJRefreshHeader class], @selector(headerWithRefreshingBlock:), @selector(byc_HeaderWithRefreshingBlock:));
}

- (NSMutableArray *)mArr_RefreshImages {
    
    return [self excCreateImagesWithKey:@selector(mArr_RefreshImages)];
}

- (NSMutableArray *)mArr_NormalImages {
    
    return [self excCreateImagesWithKey:@selector(mArr_NormalImages)];
}

- (NSMutableArray *)excCreateImagesWithKey:(const void *)key {

    NSMutableArray *mArr_Images = objc_getAssociatedObject(self, key);
    if (mArr_Images == nil) {
        mArr_Images = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 38; i++) {
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gif%d",i]];
            [mArr_Images addObject:image];
        }
        objc_setAssociatedObject(self, key, mArr_Images, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return mArr_Images;
}

+ (instancetype)byc_HeaderWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {

    MJRefreshGifHeader *header =[MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(excRefreshAction)];
    header.refreshingBlock = refreshingBlock;
    [header setImages:header.mArr_RefreshImages forState:MJRefreshStateRefreshing];
    [header setImages:header.mArr_NormalImages  forState:MJRefreshStateIdle];
    [header setImages:header.mArr_RefreshImages forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden= YES;
    return header;
}

- (void)excRefreshAction {

    QNWSBlockSafe(self.refreshingBlock);
}

@end
