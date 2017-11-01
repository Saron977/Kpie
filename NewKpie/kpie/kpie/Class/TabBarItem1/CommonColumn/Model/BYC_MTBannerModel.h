//
//  BYC_MTBannerModel.h
//  kpie
//
//  Created by 元朝 on 16/4/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HomeVCBannerModel.h"

@interface BYC_MTBannerModel : BYC_HomeVCBannerModel

/**跳转地址*/
@property (nonatomic, copy)  NSString  *secCover_Path;
/**封面类型 0图片 1 视频 2 网址*/
@property (nonatomic, copy)  NSString  *secCover_Type;
/**封面地址*/
@property (nonatomic, copy)  NSString  *secCover_Url;


+ (NSArray *)initModelsWithArray:(NSArray *)array;



/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/
/**封面类型 0图片 1 视频 2 网址*/
@property (nonatomic, assign) NSInteger secondcovertype;

@property (nonatomic, copy) NSString *columnid;

@property (nonatomic, copy) NSString *secondcoverid;
/**封面地址*/
@property (nonatomic, copy) NSString *secondcover;

@property (nonatomic, copy) NSString *video;


@property (nonatomic, copy) NSString *secondcoverpath;
/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/
@end
