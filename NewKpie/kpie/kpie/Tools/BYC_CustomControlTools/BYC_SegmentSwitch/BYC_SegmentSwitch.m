//
//  BYC_SegmentSwitch.m
//  kpie
//
//  Created by 元朝 on 16/7/1.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_SegmentSwitch.h"

//默认控件的高度为44
static CGFloat  const float_ItemHeight = 30.0f;
//默认控件的item宽度为108(注意:当标题文字超过2两个的时候宽度自己在去根据文本宽度去设定，这里暂未实现)
static CGFloat  const float_ItemWidth = 54.0f;

@interface BYC_Layer : CALayer
@end

@implementation BYC_Layer

-(void)setBounds:(CGRect)bounds {
    
    [super setBounds:bounds];
    self.cornerRadius = self.bounds.size.height / 2.0;
    self.rasterizationScale = [UIScreen mainScreen].scale;
    self.shouldRasterize = YES;
}
@end

@interface BYC_SegmentSwitch()

/**包含的标题数组，要求必须大于等于2*/
@property (nonatomic, strong)  NSArray <NSString *> *array_Items;
/**这个就是指示视图，标示选中了那个标题*/
@property (nonatomic, strong)  UIView  *view_Indicator;
/**这个是放置前段Lable的视图，用于以后穿越*/
@property (nonatomic, strong)  UIView  *view_SelectedLabelsBase;
/**这个是提供layer层mask属性*/
@property (nonatomic, strong)  UIView  *view_SelectedLabelsMask;
/**每个item宽度*/
@property (nonatomic, assign)  CGFloat float_EachItemWidth;
/**是滑动状态*/
@property (nonatomic, assign)  BOOL    isScroll;
/**是点击状态*/
@property (nonatomic, assign)  BOOL    isClick;

@end

@implementation BYC_SegmentSwitch

+(Class)layerClass {
    
    return [BYC_Layer class];
}

- (instancetype)initWithConfigureItems:(NSArray <NSString *> *)items {
    
    CGRect rect = CGRectMake((screenWidth - float_ItemWidth * items.count) / 2.0f, KHeightStateBar + (KHeightNavigationBar - KHeightStateBar - float_ItemHeight) / 2.0f, float_ItemWidth * items.count, float_ItemHeight);
    self = [super initWithFrame:rect];
    if (self) {
        
        [self initParame];
        self.array_Items = items;
        
    }
    return self;
}

- (void)initParame {

    _float_MarginInset                = 5;
    self.color_Selected         = KUIColorBaseGreenNormal;
    self.color_Background       = [UIColor whiteColor];
    self.color_Title_Selected   = _color_Background;
    self.color_Title_Background = _color_Selected;
    
    _view_Indicator = ({
        
        UIView *view = [[UIView alloc] init];
        object_setClass(view.layer, [BYC_Layer class]);
        view.backgroundColor = _color_Selected;
        view;
    });
    
    _view_SelectedLabelsMask = ({
        
        UIView *view = [[UIView alloc] init];
        object_setClass(view.layer,[BYC_Layer class]);
        view.layer.backgroundColor = [UIColor blueColor].CGColor;
        view;
    });
    
    _view_SelectedLabelsBase = ({
        
        UIView *view = [[UIView alloc] init];
        view.frame = self.bounds;
        view.layer.mask = _view_SelectedLabelsMask.layer;
        view;
    });

    self.backgroundColor = _color_Background;
    [self addObserver:self forKeyPath:@"view_Indicator.frame" options:NSKeyValueObservingOptionNew context:nil];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)switchToItemIndex:(int)index {
    
    if (index == _int_SelectedCurrentIndex) return;
    _isClick = YES;
    _int_SelectedLastIndex    = _int_SelectedCurrentIndex;
    _int_SelectedCurrentIndex = index;
    if (_delegate && [_delegate respondsToSelector:@selector(segmentSwitch:didSelectItemAtIndexPath:)])
        [_delegate segmentSwitch:self didSelectItemAtIndexPath:_int_SelectedCurrentIndex];
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:.5 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = CGRectMake(self.float_MarginInset + index*self.float_EachItemWidth, self.float_MarginInset, self.view_Indicator.frame.size.width, self.view_Indicator.frame.size.height);
        self.view_Indicator.frame = rect;
    } completion:^(BOOL finished) {
        if (finished) _isClick = NO;
    }];
}

#pragma mark - set
-(void)setArray_Items:(NSArray<NSString *> *)array_Items {

    _array_Items = array_Items;
    [self initialViews];
}

-(void)setColor_Selected:(UIColor *)color_Selected {

    _color_Selected = color_Selected;
//    self.color_Title_Background = _color_Selected;
}

-(void)setColor_Background:(UIColor *)color_Background {

    _color_Background = color_Background;
//    self.color_Title_Selected = _color_Background;
}

-(void)setColor_Title_Selected:(UIColor *)color_Title_Selected {

    _color_Title_Selected = color_Title_Selected;
}

-(void)setColor_Title_Background:(UIColor *)color_Title_Background {

    _color_Title_Background = color_Title_Background;
}

-(void)setFloat_Progress:(CGFloat)float_Progress {

    _isScroll = YES;
    _float_Progress = float_Progress;
    if (!_isClick) [self updateview_IndicatorOrigin];
}

#pragma mark - get

-(CGFloat)float_EachItemWidth {

    if (self.array_Items.count == 0) return 0;
    return self.bounds.size.width / self.array_Items.count;
}

- (void)updateview_IndicatorOrigin {

    if (_float_Progress >= 0) {
        
        CGFloat itemX = _float_MarginInset + _float_Progress / screenWidth * float_ItemWidth;
        CGRect rect = CGRectMake(itemX , _view_Indicator.frame.origin.y, self.view_Indicator.frame.size.width, self.view_Indicator.frame.size.height);
        _view_Indicator.frame = rect;
    }else {
    
        CGFloat itemX = self.view_Indicator.frame.origin.x;
        CGRect rect = CGRectMake(itemX, self.view_Indicator.frame.origin.y, (self.float_EachItemWidth-_float_MarginInset*2)*(1-log(1 - _float_Progress)), _view_Indicator.frame.size.height);
        _view_Indicator.frame = rect;
    }
}

- (void)initialViews {

    
    for (int i = 0; i < self.array_Items.count; i++) {
        
        NSString *item = _array_Items[i];
        UILabel *unselectedLabel = [[UILabel alloc] init];
        unselectedLabel.frame = CGRectMake(self.float_EachItemWidth*i, 0, self.float_EachItemWidth, self.bounds.size.height);
        unselectedLabel.text = item;
        unselectedLabel.textColor = _color_Title_Background;
        unselectedLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:unselectedLabel];
    }
    
    _view_Indicator.frame = CGRectMake(_float_MarginInset, _float_MarginInset, self.float_EachItemWidth - _float_MarginInset*2, self.bounds.size.height - _float_MarginInset*2);
    
    [self addSubview:_view_Indicator];
    [self addSubview:_view_SelectedLabelsBase];
    
    for (int i = 0; i < self.array_Items.count; i++) {
        
        NSString *item = _array_Items[i];
        UILabel *selectedLabel = [[UILabel alloc] init];
        selectedLabel.frame = CGRectMake(self.float_EachItemWidth*i, 0, self.float_EachItemWidth, self.bounds.size.height);
        selectedLabel.text = item;
        selectedLabel.textColor = _color_Title_Selected;
        if (self.array_Items.count < 2) {
            selectedLabel.font = [UIFont boldSystemFontOfSize:18];
        }
        selectedLabel.textAlignment = NSTextAlignmentCenter;
        [_view_SelectedLabelsBase addSubview:selectedLabel];
    }

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {

    CGPoint location = [gesture locationInView:self];
    int index = floor(location.x / self.float_EachItemWidth);
    [self switchToItemIndex:index];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"view_Indicator.frame"]) {
    
         _view_SelectedLabelsMask.frame = _view_Indicator.frame;
        
        if (_isScroll) {
            
            int index                 = _view_Indicator.frame.origin.x / float_ItemWidth;
            if (index != _int_SelectedCurrentIndex) {
                
                _isScroll = NO;
                _int_SelectedLastIndex    = _int_SelectedCurrentIndex;
                _int_SelectedCurrentIndex = index;
            }
        }
    }
}

- (void)layoutSubviews {

    [super layoutSubviews];
    if (self.array_Items.count > 1) {
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = KUIColorBackgroundCuttingLine.CGColor;
        
    }else {
        
        self.layer.cornerRadius = 0;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.shouldRasterize = NO;
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"view_Indicator.frame"];
}
@end
