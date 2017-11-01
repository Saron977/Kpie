//
//  BYC_PickerControlView.m
//  kpie
//
//  Created by 元朝 on 15/11/17.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_PickerControlView.h"

@interface BYC_PickerControlView()<UIPickerViewDataSource,UIPickerViewDelegate> {

    UIView    *_pickerBGControl;
    UIView    *_dataPickerView;
    UIView    *_baseView;
    UIPickerView  *_pickerView;
    ResourceSelectType _resourceSelectType;
    UITapGestureRecognizer *_tap;
}
/**省份数据*/
@property (strong, nonatomic) NSArray *provinces;
/**城市数据*/
@property (strong, nonatomic) NSArray *cities;

@property (assign, nonatomic) ushort selectedProvince;
@property (assign, nonatomic) ushort selectedCity;

/**选择后的结果*/
@property (nonatomic, strong) NSArray *resultArray;
@end

@implementation BYC_PickerControlView


- (instancetype)initWithResourceType:(ResourceSelectType)resourceSelectType
{
    self = [super init];
    if (self) {
        _resourceSelectType = resourceSelectType;
        self.backgroundColor = KUIColorBaseGreenNormal;
        self.frame = CGRectMake(0, screenHeight, screenWidth, 266);
        
        if (resourceSelectType == resourceSelectCity) {
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"allCity" ofType:@"plist"];
            _provinces = [NSArray arrayWithContentsOfFile:path];
            _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
        }
    
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.frame = CGRectMake(0, 50, screenWidth, self.kheight - 50);
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)];
        [_baseView addGestureRecognizer:_tap];
        _baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [[UIApplication sharedApplication].keyWindow addSubview:_baseView];
        _baseView.hidden = YES;
        
        [self initToolBar];

    }
    return self;
}

- (void)initToolBar {

    UIView * toolBar = [[UIView alloc] init];
    toolBar.frame = CGRectMake(0, 0, screenWidth, 50);
    toolBar.backgroundColor = KUIColorBaseGreenNormal;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 5, 60, 40);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(pickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(screenWidth - 60 -10, 5, 60, 40);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    rightButton.tag = 2;
    [rightButton addTarget:self action:@selector(pickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:rightButton];
    
    [self addSubview:toolBar];
}

-(NSArray *)resultArray {

    if (!_resultArray) {
        
        _resultArray = [NSArray array];
    }
    
    return  _resultArray;
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _resourceSelectType != resourceSelectCity ? 1 : 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return _resourceSelectType != resourceSelectCity ? 2 : _provinces.count;
            break;
        case 1:
            return _cities.count;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

//这种方法创建可以自定义不同组要显示的view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    switch (component) {
        case 0:
        {
            label.text =  _resourceSelectType != resourceSelectCity ?  row == 0 ? @"男" : @"女" :[[_provinces objectAtIndex:row] objectForKey:@"local_name"];
        }
            break;
        case 1:
        {
            label.text =  [[_cities objectAtIndex:row] objectForKey:@"local_name"];
        }
            break;
        default:
            break;
    }
    
    
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            if (_resourceSelectType == resourceSelectCity) {
                
                _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
                [_pickerView reloadComponent:1];
                [_pickerView selectRow:0 inComponent:1 animated:YES];
                
                _selectedCity = 0;
            }
            _selectedProvince = row;
        }
            break;
        case 1:
            _selectedCity = row;
            break;
        default:
            break;
    }
    
    if (_resourceSelectType == resourceSelectCity) {
        
        NSMutableArray *MResultArray = [NSMutableArray array];
        NSString *selectedP = [[_provinces objectAtIndex:_selectedProvince] objectForKey:@"local_name"];
        [MResultArray addObject:selectedP];
        if (_cities.count > 0) {
            NSString *selectedC = [[_cities objectAtIndex:_selectedCity] objectForKey:@"local_name"];
            [MResultArray addObject:selectedC];
        }
        
        _resultArray = MResultArray;
    }
    
}


-(void)show{
    _baseView.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = screenHeight;
        frame.origin.y -= frame.size.height;
        self.frame = frame;
    }];
}

-(void)hiddenSelf{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y += frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        _baseView.hidden = YES;
        [self removeFromSuperview];
        self.pickerControlViewBlock(nil , NO);
        [_baseView removeGestureRecognizer:_tap];
    }];
}

#pragma mark - 点击事件
- (void)pickerViewBtnClick:(UIButton *)button {

    if (button.tag == 2) {
        if (_resourceSelectType == resourceSelectCity) {
            
            if (!_resultArray) {
                
                NSMutableArray *MResultArray = [NSMutableArray array];
                NSString *selectedP = [[_provinces objectAtIndex:_selectedProvince] objectForKey:@"local_name"];
                [MResultArray addObject:selectedP];
                if (_cities.count > 0) {
                    NSString *selectedC = [[_cities objectAtIndex:_selectedCity] objectForKey:@"local_name"];
                    [MResultArray addObject:selectedC];
                }
                _resultArray = MResultArray;
            }
            
            self.pickerControlViewBlock(_resultArray , YES);
        }else {
        
            
            self.pickerControlViewBlock(_selectedProvince == 0 ? @[@"男"] : @[@"女"] , YES);
        }
        QNWSLog(@"点击了确定");
    }
        [self hiddenSelf];
}

-(void)dealloc {

    QNWSLog(@"%@类  死了",[self class]);
}
@end
