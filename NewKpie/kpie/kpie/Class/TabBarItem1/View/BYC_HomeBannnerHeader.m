//
//  BYC_HomeBannnerHeader.m
//  kpie
//
//  Created by 元朝 on 15/10/28.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_HomeBannnerHeader.h"
#import "BYC_ScrollViewPanGestureRecognizer.h"
#import "BYC_HomeVCBannerModel.h"
#import "WX_VoideDViewController.h"
#import "BYC_HomeViewController.h"
#import "BYC_OtherViewControllerModel.h"
#import "BYC_HTML5ViewController.h"
#import "BYC_MTBannerModel.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_MTColumnViewcontroller.h"
#import "BYC_JumpToVCHandler.h"
#import "HL_JumpToVideoPlayVC.h"


#define pageControll_Height 20
@interface BYC_HomeBannnerHeader()<UIScrollViewDelegate> {

    int _count;//计数器,用来循环滚动
}

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_BG;
@property (weak, nonatomic) IBOutlet UILabel *lab_Title;
@property (weak, nonatomic) IBOutlet UIView *view_PageBG;
@property (nonatomic, strong)  UIPageControl *pageControll;

@end

@implementation BYC_HomeBannnerHeader

+ (instancetype)getSelfObject {

   return  (BYC_HomeBannnerHeader *)[[[NSBundle mainBundle] loadNibNamed:@"BYC_HomeBannnerHeader" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    //记录滑动手势
    [BYC_ScrollViewPanGestureRecognizer sharePanGestureWith:self.scroll_BG];
    //创建控件
    [self createScrollViewWithPageControl];
}

#if 1
-(void)setArray_bannnerModels:(NSArray *)array_bannnerModels
{

    if (_array_bannnerModels != array_bannnerModels) {
        
        _array_bannnerModels = array_bannnerModels;
        
        if (_isFrmoColumn) {
            
            _scroll_BG.contentSize = CGSizeMake(screenWidth*(_array_bannnerModels.count + 2), 0);
        }else {
            
            _scroll_BG.contentSize = CGSizeMake(self.frame.size.width*(_array_bannnerModels.count + 2), 0);
        }
        
        //设置页数
        _pageControll.numberOfPages = _array_bannnerModels.count;
        
        //往滚动视图上添加6张图片
        for (int i=0; i<(_array_bannnerModels.count + 2); i++)
        {
            
            CGRect rect;
            if (_isFrmoColumn) {
                
                rect = CGRectMake(i*screenWidth, 0, screenWidth, _bannerHeight);
            }else {
                
                rect = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            }
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:rect];
            BYC_HomeVCBannerModel *model;
            if (i ==0) {
                model = [_array_bannnerModels lastObject];
                if (model.type == ENUM_HomeVCBannerTypeAction) {
                    
                    
                    [imgView sd_setImageWithURL: [NSURL URLWithString:[model.picturejpg componentsSeparatedByString:@","][0]] placeholderImage:nil];
                }else {
                    
                    if ([model isMemberOfClass:[BYC_MTBannerModel class]]) {
                        [imgView sd_setImageWithURL: [NSURL URLWithString:((BYC_MTBannerModel *)model).secondcover] placeholderImage:nil];
                    }else {
                        
                        [imgView sd_setImageWithURL: [NSURL URLWithString:model.picturejpg] placeholderImage:nil];
                    }
                }
                
                _lab_Title.text = model.videotitle;
            }else if(i == _array_bannnerModels.count + 1) {
                model = [_array_bannnerModels firstObject];
                
                if (model.type == ENUM_HomeVCBannerTypeAction) {
                    
                    
                    [imgView sd_setImageWithURL: [NSURL URLWithString:[model.picturejpg componentsSeparatedByString:@","][0]] placeholderImage:nil];
                }else {
                    
                    if ([model isMemberOfClass:[BYC_MTBannerModel class]]) {
                        [imgView sd_setImageWithURL: [NSURL URLWithString:((BYC_MTBannerModel *)model).secondcover] placeholderImage:nil];
                    }else {
                        
                        [imgView sd_setImageWithURL: [NSURL URLWithString:model.picturejpg] placeholderImage:nil];
                    }
                }
                _lab_Title.text = model.videotitle;
            }else {
                model = _array_bannnerModels[i - 1];
                if (model.type == ENUM_HomeVCBannerTypeAction) {
                    
                    [imgView sd_setImageWithURL: [NSURL URLWithString:[model.picturejpg componentsSeparatedByString:@","][0]] placeholderImage:nil];
                }else {
                    
                    if ([model isMemberOfClass:[BYC_MTBannerModel class]]) {
                        [imgView sd_setImageWithURL: [NSURL URLWithString:((BYC_MTBannerModel *)model).secondcover] placeholderImage:nil];
                    }else {
                        
                        [imgView sd_setImageWithURL: [NSURL URLWithString:model.picturejpg] placeholderImage:nil];
                    }
                }
                _lab_Title.text = model.videotitle;
            }
            
            imgView.tag = 110+i;
            imgView.userInteractionEnabled = YES;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgInfo
                                                                                       :)];
            [imgView addGestureRecognizer:tap];
            
            if (model.modelType == HomeVCBannerModelTypeVedio) {
                
                UIButton *buttonPlay = [UIButton buttonWithType:UIButtonTypeCustom];
                [buttonPlay setImage:[UIImage imageNamed:@"btn-play-n"] forState:UIControlStateNormal];
                [buttonPlay setImage:[UIImage imageNamed:@"btn-play-h"] forState:UIControlStateHighlighted];
                buttonPlay.userInteractionEnabled = NO;
                [imgView addSubview:buttonPlay];
                [buttonPlay mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.center.equalTo(buttonPlay.superview);
                }];
            }
            
            [_scroll_BG addSubview:imgView];
        }
    }
}
#endif


-(void)createScrollViewWithPageControl
{
    
   _scroll_BG.contentOffset = CGPointMake(screenWidth, 0);
    //滚动区域
    _scroll_BG.delegate = self;
    _scroll_BG.pagingEnabled = YES;
    //默认显示第二张图(偏移一张图的宽度)

    _scroll_BG.showsHorizontalScrollIndicator = NO;
    
    //page视图
    _pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(0,0, self.view_PageBG.frame.size.width,self.view_PageBG.frame.size.height)];

//    //设置背景颜色
//    _pageControll.backgroundColor = [UIColor colorWithRed:64 green:62 blue:62 alpha:0.5];
    
    //未选中颜色
    _pageControll.pageIndicatorTintColor = [UIColor whiteColor];
    
    //当前page的颜色
    _pageControll.currentPageIndicatorTintColor = KUIColorBaseGreenNormal;
    
    //添加事件
    [_pageControll addTarget:self action:@selector(imgChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.view_PageBG addSubview:_pageControll];
    
    //在最后一页放之后第一页
    //在第一页之前放最后一页
    //再改变偏移量来达到效果
    //让滚动视图,自己滚
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(getOut:) userInfo:nil repeats:YES];
    //已经偏移了一个图片的大小
    _count = 1;
}

-(void)clickImgInfo:(UITapGestureRecognizer *)tap
{
    NSInteger num = (NSInteger)(long)tap.view.tag-111;
    
    if (num < 0) num = _array_bannnerModels.count - 1;
    else if(num >= _array_bannnerModels.count) num = 0;
    else num = num;

    BYC_HomeVCBannerModel *homeModel = _array_bannnerModels[num];
    
    if(homeModel.modelType == HomeVCBannerModelTypeVedio){
        [HL_JumpToVideoPlayVC jumpToVCWithModel:homeModel andVideoTepy:homeModel.isvr andisComment:NO andFromType:ENU_FromOtherVideo];
    }else if(homeModel.modelType == HomeVCBannerModelTypeWeb){
        
        BYC_HTML5ViewController *HTML5VC = [[BYC_HTML5ViewController alloc] initWithHTML5String:[homeModel isMemberOfClass:[BYC_MTBannerModel class]] ? ((BYC_MTBannerModel *)homeModel).secondcoverpath : homeModel.videomp4];
        [[self getBGViewController].navigationController pushViewController:HTML5VC animated:YES];
    }
    else if(homeModel.modelType == HomeVCBannerModelTypeImage) {return;}
    else{
        
        BYC_OtherViewControllerModel *otherModel = [[BYC_OtherViewControllerModel alloc] init];
        NSArray *arr_Temp      = [homeModel.picturejpg componentsSeparatedByString:@","];
        if(arr_Temp.count > 1) otherModel.columnname  =  arr_Temp[2];
        if(arr_Temp.count > 1) otherModel.secondcover  =  arr_Temp[1];
        else otherModel.secondcover  =  homeModel.picturejpg;
        otherModel.columndesc = homeModel.video_Description;
        otherModel.columnid = homeModel.videomp4;

        [BYC_JumpToVCHandler jumpToColumnWithColumnId:otherModel.columnid];
    }
}

- (void)getOut:(NSTimer *)timer
{
    _count ++;
    
    NSInteger num = _array_bannnerModels.count + 1;
    if (_count >= num)
    {
        _count = 1;
        //瞬间回到起点,解决晃一下的问题
        _scroll_BG.contentOffset = CGPointMake(0, 0);
    }
    //再从起点开始跑
    [_scroll_BG setContentOffset:CGPointMake(_count *self.frame.size.width, 0) animated:YES];
    
        _pageControll.currentPage = _count-1;
    
    if (_array_bannnerModels.count > 0) {

        BYC_HomeVCBannerModel *model = _array_bannnerModels[_pageControll.currentPage];
        _lab_Title.text = model.videotitle;
    }
}

- (void)imgChange:(UIPageControl *)page
{
    //当前页*图片宽度
    [_scroll_BG setContentOffset:CGPointMake((page.currentPage+1)* self.frame.size.width, 0) animated:YES];
    _count = (int)page.currentPage;
    
}

#pragma mark -UIScrollViewDelegate

//滑动scroollView,UIPageControl跟随变化
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //取到当前图片的位置
    int index = scrollView.contentOffset.x/self.frame.size.width;
    //将位置设置给UIPageControl,来实现联动
    _pageControll.currentPage = index -1;
    BYC_HomeVCBannerModel *model;
    if (_array_bannnerModels.count > 0) {

        model = _array_bannnerModels[_pageControll.currentPage];
    }
    
    _lab_Title.text = model.videotitle;
    //停止加速的代理里面,来更改
    
    //如果到了第6张图,让他回到第二张
    if (index == (_array_bannnerModels.count + 1))
    {
        scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        _pageControll.currentPage = 0;
    }
    
    //如果到了第一张,让它偏移到第五张
    if (index ==0)
    {
        //因为偏移量是从0开始.所以乘以4才是第五张的位置
        scrollView.contentOffset = CGPointMake(self.frame.size.width*_array_bannnerModels.count, 0);
        _pageControll.currentPage = _array_bannnerModels.count - 1;
    }
    _count = (int)_pageControll.currentPage;
    
}

-(void)layoutSubviews {

    [super layoutSubviews];

    if (_isFrmoColumn) {
        
        self.frame = CGRectMake(0, 0, screenWidth, _bannerHeight);
    }
}

-(void)dealloc
{
    QNWSLog(@"%s 关闭",__func__);
}
@end
