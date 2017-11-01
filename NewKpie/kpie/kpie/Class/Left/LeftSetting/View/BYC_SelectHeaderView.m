//
//  BYC_SelectHeaderView.m
//  kpie
//
//  Created by 元朝 on 15/11/17.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_SelectHeaderView.h"
#import "BYC_ImageFromColor.h"

@interface BYC_SelectHeaderView()<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {

    UIView *_BGView;
}

@end
@implementation BYC_SelectHeaderView

- (void)selectCamera {
    
    _BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _BGView.backgroundColor = KUIColorFromRGBA(0x000000, .5);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearView)];
    [_BGView addGestureRecognizer:tap];
    UIView *selectView = [[UIView alloc] init];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.backgroundColor = KUIColorBaseGreenNormal;
    [cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    cameraButton.tag = 7;
    [cameraButton setTitleColor:KUIColorFromRGB(0x2D343C) forState:UIControlStateHighlighted];
    [selectView addSubview:cameraButton];
    
    [cameraButton setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorBaseGreenHighlight withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
    [cameraButton addTarget:self action:@selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchDown | UIControlEventTouchDragOutside];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.backgroundColor = KUIColorBaseGreenNormal;
    [photoButton setTitle:@"从相册选择" forState:UIControlStateNormal];
    photoButton.tag = 8;
    [photoButton setTitleColor:KUIColorFromRGB(0x2D343C) forState:UIControlStateHighlighted];
    [selectView addSubview:photoButton];
    
    [photoButton setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorBaseGreenHighlight withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
    [photoButton addTarget:self action:@selector(buttonAction:) forControlEvents: UIControlEventTouchUpInside |  UIControlEventTouchDown | UIControlEventTouchDragOutside];
    
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_BGView];
    [_BGView addSubview:selectView];
    
    selectView.layer.cornerRadius = 10.f;
    selectView.layer.masksToBounds = YES;
    
    selectView.translatesAutoresizingMaskIntoConstraints = NO;
    cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    photoButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    
    NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:selectView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_BGView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1
                                                                    constant:0];
    
    NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:selectView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_BGView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1
                                                                    constant:0];
    
    NSLayoutConstraint *constraintW = [NSLayoutConstraint constraintWithItem:selectView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_BGView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:.75f
                                                                    constant:0];
    
    
    NSLayoutConstraint *constraintH = [NSLayoutConstraint constraintWithItem:selectView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1
                                                                    constant:150];
    
    [window addConstraints:@[constraintX,constraintY,constraintW]];
    [selectView addConstraints:@[constraintH]];
    
    NSLayoutConstraint *cameraButtonConstraintX = [NSLayoutConstraint constraintWithItem:cameraButton
                                                                               attribute:NSLayoutAttributeLeft
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:selectView
                                                                               attribute:NSLayoutAttributeLeft
                                                                              multiplier:1
                                                                                constant:0];
    
    NSLayoutConstraint *cameraButtonConstraintY = [NSLayoutConstraint constraintWithItem:cameraButton
                                                                               attribute:NSLayoutAttributeTop
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:selectView
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1
                                                                                constant:0];
    
    NSLayoutConstraint *cameraButtonConstraintW = [NSLayoutConstraint constraintWithItem:cameraButton
                                                                               attribute:NSLayoutAttributeRight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:selectView
                                                                               attribute:NSLayoutAttributeRight
                                                                              multiplier:1
                                                                                constant:0];
    
    NSLayoutConstraint *cameraButtonConstraintH = [NSLayoutConstraint constraintWithItem:cameraButton
                                                                               attribute:NSLayoutAttributeHeight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:selectView
                                                                               attribute:NSLayoutAttributeHeight
                                                                              multiplier:0.5f
                                                                                constant:0];
    
    [selectView addConstraints:@[cameraButtonConstraintX,cameraButtonConstraintY,cameraButtonConstraintW,cameraButtonConstraintH]];
    
    
    NSLayoutConstraint *photoButtonConstraintX = [NSLayoutConstraint constraintWithItem:photoButton
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:selectView
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1
                                                                               constant:0];
    
    NSLayoutConstraint *photoButtonConstraintY = [NSLayoutConstraint constraintWithItem:photoButton
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:selectView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1
                                                                               constant:0];
    
    NSLayoutConstraint *photoButtonConstraintW = [NSLayoutConstraint constraintWithItem:photoButton
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:selectView
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1
                                                                               constant:0];
    
    NSLayoutConstraint *photoButtonConstraintH = [NSLayoutConstraint constraintWithItem:photoButton
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:selectView
                                                                              attribute:NSLayoutAttributeHeight
                                                                             multiplier:0.5f
                                                                               constant:-0.5];
    
    [selectView addConstraints:@[photoButtonConstraintX,photoButtonConstraintY,photoButtonConstraintW,photoButtonConstraintH]];
    
}

- (void)disappearView {
    
    [_BGView removeFromSuperview];
    _BGView = nil;

}

- (void)buttonAction:(UIButton *)button {

    switch (button.tag) {
        case 7://拍照
            if (button.tracking == 0 && button.highlighted == 1) {
                
                
                [self takePhoto];
                [self disappearView];
            }else {
                
            }
            break;
        case 8://从相册选择
            if (button.tracking == 0 && button.highlighted == 1) {
                
                
                [self LocalPhoto];
                [self disappearView];
                
            }else {
                  
            }
            break;
            
        default:
            break;
            
    }
}


#pragma mark ---  头像选取

//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [_personalDataVC presentViewController:picker animated:YES completion:nil];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        [_personalDataVC presentViewController:picker animated:YES completion:nil];
    }else {
        [self showAndHideHUDWithTitle:@"该设备无摄像头" WithState:BYC_MBProgressHUDHideProgress];
    }
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
            //把图片转成NSData类型的数据
            //返回为JPEG图像。
        NSData *data = UIImageJPEGRepresentation(image, 0.2);
        
        self.returnImageDataBlock(image , data);
    }
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc {
    
    [self disappearView];
}

@end
