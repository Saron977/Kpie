//
//  BYC_ShowHeaderImageViewController.m
//  kpie
//
//  Created by 元朝 on 15/12/18.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_ShowHeaderImageViewController.h"
#import "BYC_MainNavigationController.h"
@interface BYC_ShowHeaderImageViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong)  UIImage  *image_Header;
@property (nonatomic, strong)  UIActionSheet *actionSheet;
@end

@implementation BYC_ShowHeaderImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initViews];
    
    [self initScroll];
}

- (void)initViews {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"保存到手机"
                                  otherButtonTitles:nil];
    
    _actionSheet = actionSheet;
}

- (void)initScroll {

    //1.创建小的滑动视图(主要是为了缩放)
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    scrollView.tag = 201;
    scrollView.bounces = NO;
    //设置缩放比例
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideVC)];
    [imageView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showSaveHeaderImage)];
    [imageView addGestureRecognizer:longPress];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = 2016;
    [scrollView addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _image_Header = image;
    }];

    //设置服用的滑动视图取消放大效果
    [scrollView setZoomScale:1.0];
}

- (void)showSaveHeaderImage {

    [_actionSheet showInView:self.view];
}

#pragma mark - UIScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:2016];
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
     UIImageView *imageView =  (UIImageView *)[scrollView viewWithTag:2016];
    imageView.center = CGPointMake(xcenter, ycenter);

}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0://保存到本地
        {
        
            [self saveImageToPhotoAlbum:_image_Header];
        }
            break;
            
        default:
            break;
    }
}
//保存照片至相册
- (void)saveImageToPhotoAlbum:(UIImage*)image {
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{

    if (error != NULL) {
        
    [self.view showAndHideHUDWithTitle:@"保存失败" WithState:BYC_MBProgressHUDHideProgress];
    }else {
    [self.view showAndHideHUDWithTitle:@"保存成功" WithState:BYC_MBProgressHUDHideProgress];
    }
}

- (void)hideVC {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
