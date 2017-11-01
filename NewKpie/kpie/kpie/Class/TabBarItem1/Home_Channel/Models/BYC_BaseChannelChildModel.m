//
//  BYC_BaseChannelChildModel.m
//  kpie
//
//  Created by 元朝 on 16/7/22.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseChannelChildModel.h"

@interface BYC_BaseChannelChildModel()

/**最New 其他数据模型*/
@property (nonatomic, strong)  BYC_OtherViewControllerModel *model_New_Other;
/**最New banner模型数据数组*/
@property (nonatomic, strong)  NSArray<BYC_BaseChannelBannerModel *> *arr_New_BannerModels;
/**最New 视频模型数据数组*/
@property (nonatomic, strong)  NSArray<BYC_HomeViewControllerModel *> *arr_New_VideoModels;

/**最Hot 其他数据模型*/
@property (nonatomic, strong)  BYC_OtherViewControllerModel *model_Hot_Other;
/**最Hot banner模型数据数组*/
@property (nonatomic, strong)  NSArray<BYC_BaseChannelBannerModel *> *arr_Hot_BannerModels;
/**最Hot 视频模型数据数组*/
@property (nonatomic, strong)  NSArray<BYC_HomeViewControllerModel *> *arr_Hot_VideoModels;

/**必须首先设置type_Flag标识 的标识*/
@property (nonatomic, assign)  BOOL  isFirstSetupFlag;
/**必须首先设置type标识 的标识*/
@property (nonatomic, assign)  BOOL  isSetupFlag;

@end

@implementation BYC_BaseChannelChildModel

+ (instancetype)baseChannelChildModelWithOtherModel:(BYC_OtherViewControllerModel *)otherModel arr_BannerModels:(NSArray<BYC_BaseChannelBannerModel *> *)arr_BannerModels arr_VideoModels:(NSArray<BYC_HomeViewControllerModel *> *)arr_VideoModels{

    BYC_BaseChannelChildModel *model = [BYC_BaseChannelChildModel new];
    model.type                                          = ENUM_BaseChannelChildModelTypeNew;
    if (otherModel != nil) model.model_Other            = otherModel;
    if (arr_BannerModels.count > 0) model.arr_BannerModels = arr_BannerModels;
    if (arr_VideoModels.count > 0) model.arr_VideoModels   = arr_VideoModels;

    return model;
}

- (void)baseChannelChildModelWithOtherModel:(BYC_OtherViewControllerModel *)otherModel arr_BannerModels:(NSArray<BYC_BaseChannelBannerModel *> *)arr_BannerModels arr_VideoModels:(NSArray<BYC_HomeViewControllerModel *> *)arr_VideoModels type:(ENUM_BaseChannelChildModelType)type_Flag {

    self.type_Flag                                     = type_Flag;
    if (otherModel != nil) self.model_Other            = otherModel;
    if (arr_BannerModels.count > 0) self.arr_BannerModels = arr_BannerModels;
    if (arr_VideoModels.count > 0) self.arr_VideoModels   = arr_VideoModels;
}

//必须首先设置，要是从新赋值的话，也必须从新设置，不然赋值混乱。但是，（目前情况只能类方法断言的到。要是属性通过类方法赋值了之后，在挨个挨个在赋值不能完全断言的到，得需要注意）
-(void)setType_Flag:(ENUM_BaseChannelChildModelType)type_Flag {

    _type_Flag = type_Flag;
    _isFirstSetupFlag = YES;
}

-(void)setType:(ENUM_BaseChannelChildModelType)type {

    _type = type;
    _isSetupFlag = YES;
}

-(void)setModel_Other:(BYC_OtherViewControllerModel *)model_Other {

    NSAssert(_isFirstSetupFlag, @"必须首先设置_type_Flag标识");
    switch (_type_Flag) {
        case ENUM_BaseChannelChildModelTypeNew: {
            _model_New_Other = model_Other;
            break;
        }
        case ENUM_BaseChannelChildModelTypeHot: {
            _model_Hot_Other = model_Other;
            break;
        }
    }
}

-(void)setArr_BannerModels:(NSArray<BYC_BaseChannelBannerModel *> *)arr_BannerModels {

    NSAssert(_isFirstSetupFlag, @"必须首先设置_type_Flag标识");
    switch (_type_Flag) {
        case ENUM_BaseChannelChildModelTypeNew: {
            _arr_New_BannerModels = arr_BannerModels;
            break;
        }
        case ENUM_BaseChannelChildModelTypeHot: {
            _arr_Hot_BannerModels = arr_BannerModels;
            break;
        }
    }
}

-(void)setArr_VideoModels:(NSArray<BYC_HomeViewControllerModel *> *)arr_VideoModels {

    NSAssert(_isFirstSetupFlag, @"必须首先设置_type_Flag标识");
    switch (_type_Flag) {
        case ENUM_BaseChannelChildModelTypeNew: {
            _arr_New_VideoModels = arr_VideoModels;
            break;
        }
        case ENUM_BaseChannelChildModelTypeHot: {
            _arr_Hot_VideoModels = arr_VideoModels;
            break;
        }
    }
}

-(BYC_OtherViewControllerModel *)model_Other {

    NSAssert(_isSetupFlag, @"必须首先设置type标识");
    
    switch (_type) {
        case ENUM_BaseChannelChildModelTypeNew: {
            return  _model_New_Other;
            break;
        }
        case ENUM_BaseChannelChildModelTypeHot: {
            return  _model_Hot_Other;
            break;
        }
    }
}

-(NSArray<BYC_BaseChannelBannerModel *> *)arr_BannerModels {

    NSAssert(_isSetupFlag, @"必须首先设置type标识");
    
    switch (_type) {
        case ENUM_BaseChannelChildModelTypeNew: {
            return  _arr_New_BannerModels;
            break;
        }
        case ENUM_BaseChannelChildModelTypeHot: {
            return  _arr_Hot_BannerModels;
            break;
        }
    }
}

-(NSArray<BYC_HomeViewControllerModel *> *)arr_VideoModels {

    NSAssert(_isSetupFlag, @"必须首先设置type标识");
    
    switch (_type) {
        case ENUM_BaseChannelChildModelTypeNew: {
            return  _arr_New_VideoModels;
            break;
        }
        case ENUM_BaseChannelChildModelTypeHot: {
            return  _arr_Hot_VideoModels;
            break;
        }
    }
}

- (NSArray<BYC_HomeViewControllerModel *> *)getVideoDataWithType:(ENUM_BaseChannelChildModelType)type_Flag {

    ENUM_BaseChannelChildModelType type_Current = self.type;
    self.type = type_Flag;
    NSArray<BYC_HomeViewControllerModel *> *arr_VideoModels = self.arr_VideoModels;
    self.type = type_Current;
    return arr_VideoModels;
}

@end
