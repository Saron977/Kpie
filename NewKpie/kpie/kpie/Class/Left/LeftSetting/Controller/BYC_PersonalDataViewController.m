//
//  BYC_PersonalDataViewController.m
//  kpie
//
//  Created by 元朝 on 15/11/11.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_PersonalDataViewController.h"
#import "BYC_ImageFromColor.h"
#import "BYC_SelectHeaderView.h"
#import "BYC_PickerControlView.h"
#import "BYC_AccountTool.h"
#import "BYC_BaseNavigationController.h"
#import "BYC_AliyunOSSUpload.h"
#import "BYC_ShowTitleOnWindow.h"
#import "NSString+BYC_HaseCode.h"
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import "BYC_HttpServers+BYC_Settings.h"
#import "UITextField+BYC_Tool.h"
#import "BYC_Tool.h"

@interface BYC_PersonalDataViewController()<UITextFieldDelegate,NSURLSessionDelegate> {

    //用户个人资料
    BYC_AccountModel *_userModel;
    
    UIView *_BGView;
    BYC_SelectHeaderView *_selectHeaderView;
    /**oss*/
    id<OSSCredentialProvider> _credential;
    OSSClient *_ossClient;
    NSString  *_objectKey;
    
    //记录之前的数据
    UIImage  *_imageHeader;
    NSNumber *_numberSex;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *button_items;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_Header;
@property (weak, nonatomic) IBOutlet UITextField *textField_Nickname;
@property (weak, nonatomic) IBOutlet UITextField *textField_Sex;
@property (weak, nonatomic) IBOutlet UILabel     *label_Nationality;
@property (weak, nonatomic) IBOutlet UITextField *textField_area;
@property (weak, nonatomic) IBOutlet UITextField *textField_PersonalNote;
@property (weak, nonatomic) IBOutlet UITextField *textF_PhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *textF_Email;



@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label_items;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageV_items;
/**头像数据*/
@property (nonatomic, strong)   NSData *imageData;
/**头像路径*/
@property (nonatomic, copy)     NSString *imagePath;
/**记录头像数据*/
@property (nonatomic, copy)     NSData *recordimageData;

@end
@implementation BYC_PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化用户数据
    [self initData];
    
    [self settingbuttonitems];
    _imageV_Header.layer.cornerRadius = _imageV_Header.kwidth / 2;
    _imageV_Header.layer.masksToBounds = YES;
    
    UIBarButtonItem *item  = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveUserInfo)];
    self.navigationItem.rightBarButtonItem = item;
    self.title = @"完善个人资料";
    
    if (_isLogin || _isRegistered || _isStarOpenApp) {//移除之前的返回方法接收新的返回的方法SEL
        
        [((BYC_BaseNavigationController *)self.navigationController).leftButton removeTarget:self.navigationController action:((BYC_BaseNavigationController *)self.navigationController).backActionSEL forControlEvents:UIControlEventTouchUpInside];
        [((BYC_BaseNavigationController *)self.navigationController).leftButton addTarget:self action:@selector(backRootVCAction) forControlEvents:UIControlEventTouchUpInside];
         self.navigationController.interactivePopGestureRecognizer.enabled = NO; //禁用ios7手势滑动返回功能
    }
    _textField_Nickname.tintColor = KUIColorBaseGreenNormal;
    [self exeTextFieldAction];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    _textField_Nickname.delegate = self;
    _textField_PersonalNote.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    _textField_Nickname.delegate = nil;
    _textField_PersonalNote.delegate = nil;
    
}
- (void)initData {

    _userModel = [BYC_AccountTool userAccount];
    
    UIImageView *imageV = [[UIImageView alloc] init];
    
    if (_isStarOpenApp) {//奇葩，在appdelegate里面打开此页面，不走SDWebImage的回调。导致不能给_imageHeader赋值
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_userModel.headportrait]];
        _imageHeader = [UIImage imageWithData:imageData];
        _imageV_Header.image = _imageHeader;
    }else {
    
        [imageV sd_setImageWithURL:[NSURL URLWithString:_userModel.headportrait] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            _imageHeader = image;
            _imageV_Header.image = _imageHeader;
        }];
    }
    if (_userModel.sex == 0)_textField_Sex.text = @"男";
    else if(_userModel.sex == 1) _textField_Sex.text = @"女";
    else _textField_Sex.text = @"保密";
    _textField_Nickname.text = _userModel.nickname;
    if (_userModel.userInfo.nationality.length > 0 && ![_userModel.userInfo.nationality isEqualToString:@"null"] && ![_userModel.userInfo.nationality isEqual:[NSNull null]])
        _label_Nationality.text = _userModel.userInfo.nationality;
    _textField_area.text = _userModel.userInfo.city;
    if (_userModel.userInfo.mydescription.length > 0)_textField_PersonalNote.text = _userModel.userInfo.mydescription;
    
    _textF_PhoneNum.text = _userModel.userInfo.contact;
    _textF_Email.text = _userModel.userInfo.emailaddress;
}

- (void)exeTextFieldAction {
    
    [_textF_PhoneNum.rac_textSignal subscribeNext:^(id x) {
        
        if (!_textF_PhoneNum.isFirstResponder && _textF_PhoneNum.text.length > 0) {
        
            if (![BYC_Tool isMobileNumber:x])  {
                
                QNWSShowAndHideHUD(@"请输入正确的手机号码", 0);
                return;
            }
        }
        
        if (![_textF_PhoneNum textFieldPhoneNumberShowRightView:NO])
            _textF_PhoneNum.text  = [_textF_PhoneNum.text substringToIndex:_textF_PhoneNum.text.length - 1];
    }];
    
    [_textF_Email.rac_textSignal subscribeNext:^(id x) {

        if (!_textF_Email.isFirstResponder && _textF_Email.text.length > 0) [BYC_Tool isEmailWithText:x];
    }];
}

- (void)settingbuttonitems {
    
    for (UIButton *button in _button_items) {
        
        [button setBackgroundImage:[BYC_ImageFromColor imageFromColor:KUIColorFromRGBA(0x000000, .2) withImageFrame:CGRectMake(0, 0, screenWidth, 50)] forState:UIControlStateHighlighted];
         [button addTarget:self action:@selector(buttonAction:) forControlEvents: UIControlEventTouchDown | UIControlEventTouchDragOutside];
    }
}

- (void)saveUserInfo {
    [self.view endEditing:YES];
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionary];
    QNWSDictionarySetObjectForKey(mDic, userInfoDic, @"userInfo")
    QNWSDictionarySetObjectForKey(userInfoDic, _userModel.userid, @"userid")
    
    if (_imageData == nil && _imageV_Header.image == nil) {
        
        [self.view showAndHideHUDWithTitle:@"请选择头像" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }else {
            
        if (_imageData) {
            
            _objectKey = [NSString createFileName:@"userHeaderImage.png" andType:ENUM_ResourceTypeUsers];
            _imagePath = [NSString stringWithFormat:@"%@%@",KQNWS_OSSFilePath,_objectKey];
            QNWSDictionarySetObjectForKey(mDic, _imagePath, @"headportrait")
        }else {
            QNWSDictionarySetObjectForKey(mDic, _userModel.headportrait, @"headportrait")
            _imagePath = _userModel.headportrait;
        }
    }
    if (!(_textField_Nickname.text.length > 0)) {
        
        [self.view showAndHideHUDWithTitle:@"请填写昵称" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }else {
        
        if (![self wetherCorrect])return;
        QNWSDictionarySetObjectForKey(mDic, _textField_Nickname.text, @"nickname")
    }
    
    if (!(_textField_Sex.text.length > 0)) {
        
        [self.view showAndHideHUDWithTitle:@"请填写性别" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }else {
        if ([_textField_Sex.text isEqualToString:@"男"]) _numberSex = [NSNumber numberWithInt:0];
        else {
            
            if ([_textField_Sex.text isEqualToString:@"女"]) _numberSex = [NSNumber numberWithInt:1];
            else _numberSex = [NSNumber numberWithInt:2];//保密
        }
        
        QNWSDictionarySetObjectForKey(mDic, _numberSex, @"sex")
    }
    QNWSDictionarySetObjectForKey(userInfoDic, _label_Nationality.text, @"nationality")
    QNWSDictionarySetObjectForKey(userInfoDic, _textField_area.text, @"city")
    if (_textField_PersonalNote.text.length > 0 )QNWSDictionarySetObjectForKey(userInfoDic, _textField_PersonalNote.text, @"mydescription")
    else QNWSDictionarySetObjectForKey(userInfoDic, @"这个人很懒,什么都没有留下...", @"mydescription")
        
        
    if (_textF_PhoneNum.text.length > 0 && ![BYC_Tool isMobileNumber:_textF_PhoneNum.text])  {
    
        QNWSShowAndHideHUD(@"请输入正确的手机号码", 0);
        return;
    }

    if (![BYC_Tool isEmailWithText:_textF_Email.text] && _textF_Email.text.length > 0)  {return;}
    QNWSDictionarySetObjectForKey(userInfoDic, _textF_PhoneNum.text, @"contact")
    QNWSDictionarySetObjectForKey(userInfoDic, _textF_Email.text, @"emailaddress")
        
    if (([_imageData isEqualToData: _recordimageData] || (_imageData == nil && _imageV_Header.image != nil)) && [_userModel.nickname isEqualToString:_textField_Nickname.text] && [_numberSex integerValue] == _userModel.sex &&  ([_label_Nationality.text isEqualToString: _userModel.userInfo.nationality] ||  _userModel.userInfo.nationality.length ==0 ) && [_textField_area.text isEqualToString: _userModel.userInfo.city] && [_textField_PersonalNote.text isEqualToString: _userModel.userInfo.mydescription] && [_textF_PhoneNum.text isEqualToString: _userModel.userInfo.contact] && [_textF_Email.text isEqualToString: _userModel.userInfo.emailaddress]) {
        
        [self.view showAndHideHUDWithTitle:@"没有修改资料，无需保存" WithState:BYC_MBProgressHUDHideProgress];
        return;
    }

    QNWSDictionarySetObjectForKey(mDic, _userModel.userid, @"userid")
    
    [self.view showHUDWithTitle:@"正在上传个人资料" WithState:BYC_MBProgressHUDShowTurnplateProgress];
    
    if (_imageData != nil) {
        
        //阿里云上传数据
        [BYC_AliyunOSSUpload uploadWithObjectKey:_objectKey Data:_imageData andType:resourceTypeImage completion:^(BOOL finished) {
            
            if (finished)[self requestDataWithParameters:mDic];//成功
            else {//失败
            
                _imagePath = _userModel.headportrait;
                [self.view hideHUDWithTitle:@"上传失败" WithState:BYC_MBProgressHUDHideProgress];
            }
        }];
    }else [self requestDataWithParameters:mDic];//直接上传。不包含头像
}


- (void)requestDataWithParameters:(id)parameters {

    [BYC_HttpServers requestSaveUserInfoDataWithParameters:parameters success:^(AFHTTPRequestOperation *operation) {
        
        _recordimageData         = _imageData;//记录地址
        _userModel.headportrait  = _imagePath;
        _userModel.nickname      = _textField_Nickname.text;
        _userModel.sex           = [_numberSex integerValue];
        _userModel.userInfo.nationality   = _label_Nationality.text;
        _userModel.userInfo.city          = _textField_area.text;
        _userModel.userInfo.mydescription = _textField_PersonalNote.text;
        _userModel.userInfo.contact       = _textF_PhoneNum.text;
        _userModel.userInfo.emailaddress  = _textF_Email.text;
        
        if (self.view.isDisplayHUD) [self.view hideHUDWithTitle:@"更改成功" WithState:BYC_MBProgressHUDHideProgress];
        
        if (_isLogin || _isRegistered) {//登录页过来
            
            self.navigationController.interactivePopGestureRecognizer.enabled = YES; //启用ios7手势滑动返回功能
            [((BYC_BaseNavigationController *)self.navigationController).leftButton addTarget:self.navigationController action:((BYC_BaseNavigationController *)self.navigationController).backActionSEL forControlEvents:UIControlEventTouchUpInside];
             [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if (_isStarOpenApp) {//刚刚打开APP就push过来
            
            self.navigationController.interactivePopGestureRecognizer.enabled = YES; //启用ios7手势滑动返回功能
            [((BYC_BaseNavigationController *)self.navigationController).leftButton addTarget:self.navigationController action:((BYC_BaseNavigationController *)self.navigationController).backActionSEL forControlEvents:UIControlEventTouchUpInside];
            if (self.delegate && self.onStartClick) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.delegate performSelector:self.onStartClick];
#pragma clang diagnostic pop
                
            }
            [self.view removeFromSuperview];
        } 
    } failure:nil];
}

- (void)backRootVCAction {

    [self.view showAndHideHUDWithTitle:@"请完善个人资料，才能返回" WithState:BYC_MBProgressHUDHideProgress];
}

- (IBAction)buttonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    UIColor *color = sender.tracking == 0 || sender.state == 0 ? KUIColorWordsBlack1 : KUIColorBaseGreenNormal;
    UIImage *image = sender.tracking == 0 || sender.state == 0 ? [UIImage imageNamed:@"wode_icon_xiayibu_n"] : [UIImage imageNamed:@"icon-jr-h"];
     CGSize  size   = sender.tracking ==0  || sender.state == 0 ? CGSizeMake(16, 16) : CGSizeMake(8, 16);
    
    ((UILabel *)_label_items[sender.tag - 1]).textColor = color;
    ((UIImageView *)_imageV_items[sender.tag - 1]).image = image;
    ((UIImageView *)_imageV_items[sender.tag - 1]).mj_size = size;
    
    switch (sender.tag) {
        case 1://头像
        {
            
            if (sender.tracking == 0 && sender.highlighted == 1) {
                
                _selectHeaderView = [[BYC_SelectHeaderView alloc] init];
                _selectHeaderView.personalDataVC = self;
                [_selectHeaderView selectCamera];
                
                 __weak __typeof(self) weakSelf = self;
                _selectHeaderView.returnImageDataBlock = ^(UIImage *image , NSData *data){
                
                    weakSelf.imageV_Header.image = image;
                    weakSelf.imageData = data;
                };
            }
        }
            break;
        case 2://昵称
            _textField_Nickname.textColor = color;
            break;
        case 3://性别
            break;
        case 4://国籍

            if (sender.tracking == 0 && sender.highlighted == 1) {
                [self.view endEditing:YES];
                [self.view showAndHideHUDWithTitle:@"别点啦，暂时只支持中国大陆！" WithState:BYC_MBProgressHUDHideProgress];
            }
            _label_Nationality.textColor = color;
            break;
        case 5://城市
            break;
        case 6://个人说明
            _textField_PersonalNote.textColor = color;
            break;
        default:
            break;
    }
    
}


- (IBAction)tapHideKeyBoard:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
    
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _textField_area || textField == _textField_Sex) {
        textField.userInteractionEnabled = NO;
        [self.view endEditing:YES];
        
        BYC_PickerControlView *myAreaPickerView = [[BYC_PickerControlView alloc] initWithResourceType:textField == _textField_area ? resourceSelectCity : resourceSelectSex];
        
         __weak __typeof(self) weakSelf = self;
        myAreaPickerView.pickerControlViewBlock = ^(NSArray *cityArray , BOOL isOk){

            if (isOk) {
                
                textField.text = textField == weakSelf.textField_area ? [NSString stringWithFormat:@"%@ %@",cityArray[0],cityArray[1]] : [NSString stringWithFormat:@"%@",cityArray[0]];
            }
            
            textField.userInteractionEnabled = YES;
        };
        [myAreaPickerView show];
        
        return NO;
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    

        
    if ([textField isFirstResponder]) {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            
            [self.view showAndHideHUDWithTitle:@"请重新输入,不能包含Emoji表情" WithState:BYC_MBProgressHUDHideProgress];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    if (textField == _textField_Nickname) return [self wetherCorrect];
    if (textField == _textField_PersonalNote && _textField_PersonalNote.text.length > 70) {
        
        [BYC_ShowTitleOnWindow showAnimationKeyBoardCuewords:@"个人说明不能超过70个单词哦😔"];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)wetherCorrect {

    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5(\u00A0)|(\u3000))]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    
    if(![pred evaluateWithObject: _textField_Nickname.text])
    {
        
        [BYC_ShowTitleOnWindow showAnimationKeyBoardCuewords:@"昵称只能由中文、字母或数字组成"];
        return NO;
        
    }
    
    NSError *error;
    NSString *censorWordsString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CensorWords" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *censorWordsArray =  [censorWordsString componentsSeparatedByString:@"\n"];
    
    for (NSString *censorWords in censorWordsArray) {
        
        NSString *string = [censorWords stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
        if([_textField_Nickname.text rangeOfString:string].location !=NSNotFound)
        {
            
            [BYC_ShowTitleOnWindow showAnimationKeyBoardCuewords:@"请重新输入,昵称不能输入敏感词汇"];
            return NO;
        }else if (_textField_Nickname.text.length > 12) {
            
            [BYC_ShowTitleOnWindow showAnimationKeyBoardCuewords:@"昵称不能超过12个单词哦😔"];
            return NO;
        }
    }
    return YES;
}

@end
