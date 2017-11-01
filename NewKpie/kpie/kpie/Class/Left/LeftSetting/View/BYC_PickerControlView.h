//
//  BYC_PickerControlView.h
//  kpie
//
//  Created by 元朝 on 15/11/17.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    resourceSelectSex = 1,//性别选择
    resourceSelectCity,   //城市选择
} ResourceSelectType;

typedef void(^pickerControlViewBlock)(NSArray *cityArray , BOOL isOk);
@interface BYC_PickerControlView : UIView

@property (nonatomic, strong)  pickerControlViewBlock  pickerControlViewBlock;

- (instancetype)initWithResourceType:(ResourceSelectType)resourceSelectType;


/**显示*/
-(void)show;
@end
