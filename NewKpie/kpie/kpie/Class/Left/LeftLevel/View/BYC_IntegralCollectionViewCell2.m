//
//  BYC_IntegralCollectionViewCell2.m
//  kpie
//
//  Created by 元朝 on 16/1/29.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_IntegralCollectionViewCell2.h"
#import "BYC_MyLevelModel.h"

@interface BYC_IntegralCollectionViewCell2()

@property (weak, nonatomic) IBOutlet UILabel *label_Event;
@property (weak, nonatomic) IBOutlet UILabel *label_Value;
@property (weak, nonatomic) IBOutlet UILabel *label_Limit;

@end

@implementation BYC_IntegralCollectionViewCell2

-(void)setIndexPath:(NSIndexPath *)indexPath {
    
    QNWSLog(@"indexPath.section == %d  indexPath.item == %d",indexPath.section,indexPath.row);
    
    if (indexPath.item == 0) {
        
        _label_Event.text    = @"事件";
        _label_Limit.text    = indexPath.section == 2 ? @"当日上限" : @"上限";
        _label_Value.text    = @"单次获得";
        
        _label_Event.textColor    = [UIColor whiteColor];
        _label_Limit.textColor    = [UIColor whiteColor];
        _label_Value.textColor    = [UIColor whiteColor];
        switch (indexPath.section) {
            case 1:
                self.backgroundColor = KUIColorFromRGB(0X6E3D4D);
                break;
            case 2:
                self.backgroundColor = KUIColorFromRGB(0X225B57);
                break;
            case 3:
                self.backgroundColor = KUIColorFromRGB(0X6E5A35);
                break;
            default:
                break;
        }
    }else {
        
        [self setColorWithIndexPath:indexPath];
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setColorWithIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 1:
            _label_Event.backgroundColor = KUIColorFromRGBA(0X6E3D4D, indexPath.item % 2 ? 0.4f : 0.2f);
            _label_Value.backgroundColor = KUIColorFromRGBA(0X6E3D4D, indexPath.item % 2 ? 0.4f : 0.2f);
            _label_Limit.backgroundColor = KUIColorFromRGBA(0X6E3D4D, indexPath.item % 2 ? 0.4f : 0.2f);
            break;
        case 2:
            _label_Event.backgroundColor = KUIColorFromRGBA(0X225B57, indexPath.item % 2 ? 0.4f : 0.2f);
            _label_Value.backgroundColor = KUIColorFromRGBA(0X225B57, indexPath.item % 2 ? 0.4f : 0.2f);
            _label_Limit.backgroundColor = KUIColorFromRGBA(0X225B57, indexPath.item % 2 ? 0.4f : 0.2f);
            break;
        case 3:
            _label_Event.backgroundColor = KUIColorFromRGBA(0X6E5A35, indexPath.item % 2 ? 0.4f : 0.2f);
            _label_Value.backgroundColor = KUIColorFromRGBA(0X6E5A35, indexPath.item % 2 ? 0.4f : 0.2f);
            _label_Limit.backgroundColor = KUIColorFromRGBA(0X6E5A35, indexPath.item % 2 ? 0.4f : 0.2f);
            break;
        default:
            break;
    }
}

-(void)setModel:(BYC_MyLevelModel *)model {

    _model = model;
    _label_Event.text    = _model.eventname;
    _label_Value.text    = _model.score;
    _label_Limit.text    = [NSString stringWithFormat:@"%@/%@",_model.growth,_model.daylimit];
}
@end
