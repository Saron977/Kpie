//
//  BYC_SearchBar.m
//  kpie
//
//  Created by 元朝 on 16/5/10.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_SearchBar.h"
#import "UIView+BYC_GetViewController.h"
#import "BYC_MainNavigationController.h"

#define LEFTANDRIGHT_GAP 10
#define TOP_GAP 7

@interface BYC_SearchBar()<UITextFieldDelegate>

@property (nonatomic, strong)  UITextField             *textFiled_SearchBar;
/**当前状态*/
@property (nonatomic, assign)  ENUM_ShowInterfaceType  showInterfaceType_Current;
/**上一个状态*/
@property (nonatomic, assign)  ENUM_ShowInterfaceType  showInterfaceType_Last;
/**跳转到指定的状态*/
@property (nonatomic, assign)  ENUM_ShowInterfaceType  showInterfaceType_Assign;
/**搜索关键词*/
@property (nonatomic, copy)  NSString  *keyWords;

@end

@implementation BYC_SearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, KHeightStateBar,screenWidth, KHeightNavigationBar - KHeightStateBar)];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self _initParams];
        [self _initSubViews];
    }
    return self;
}

- (void)_initParams {

    _showInterfaceType_Current = ENUM_ShowInterfaceTypeIsHistory;
    _showInterfaceType_Last    = ENUM_ShowInterfaceTypeIsHistory;
    
    //注册选中要搜索的结果的通知
    [QNWSNotificationCenter addObserver:self selector:@selector(receiveNotificationAction:) name:@"SearchListCollectionDidSelectItemNotification" object:nil];
}

- (void)_initSubViews
{
    
    UIButton *button_Cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_Cancel setTitle:@"取消" forState:UIControlStateNormal];
    button_Cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [button_Cancel setTitleColor:KUIColorFromRGB(0XE5E5E5) forState:UIControlStateNormal];
    [button_Cancel addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: button_Cancel];
    [button_Cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.trailing.bottom.equalTo(button_Cancel.superview);
        make.width.offset(50);
    }];
    
    _textFiled_SearchBar = ({
        
        UITextField *textFiled = [[UITextField alloc] init];
        textFiled.backgroundColor = [UIColor whiteColor];
        textFiled.layer.cornerRadius = 5;
        textFiled.returnKeyType = UIReturnKeySearch;
        textFiled.placeholder = @"搜索昵称、内容";
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sousuo_chaxun_n"]];
        CGRect rect = leftImageView.frame;
        rect.size.width += 20;
        leftImageView.frame = rect;
        leftImageView.contentMode = UIViewContentModeCenter;
        textFiled.leftView= leftImageView;
        textFiled.leftViewMode = UITextFieldViewModeAlways;
        textFiled.font = [UIFont systemFontOfSize:13];
        textFiled.delegate = self;
        [self addSubview:textFiled];
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.leading.equalTo(textFiled.superview).insets(UIEdgeInsetsMake(7, 10, 0, 0));
            make.trailing.equalTo(button_Cancel.mas_leading);
            make.height.offset(30);
            
        }];
        
        textFiled;
    });
    
    [QNWSNotificationCenter addObserver:self selector:@selector(textFieldBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:_textFiled_SearchBar];
    [QNWSNotificationCenter addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_textFiled_SearchBar];

}


- (void)buttonAction {

    [KMainNavigationVC popViewControllerAnimated:YES];
}


- (void)becomeFirstResponder {

    [self.textFiled_SearchBar becomeFirstResponder];
}
#pragma mark - UITextFieldDelegate
//根据上一个状态选择当前状态
- (void)selectInterfaceType {

    switch (_showInterfaceType_Last) {
        
        case ENUM_ShowInterfaceTypeIsHistory: {
            self.showInterfaceType_Current = ENUM_ShowInterfaceTypeIsHistory;
            break;
        }
        case ENUM_ShowInterfaceTypeIsSearchList: {
            self.showInterfaceType_Current = ENUM_ShowInterfaceTypeIsHistory;
            break;
        }
        case ENUM_ShowInterfaceTypeIsResultList: {
            self.showInterfaceType_Current = ENUM_ShowInterfaceTypeIsResultList;
            break;
        }
    }
}

-(void)textFieldBeginEditing:(NSNotification *)notification {
    
    UITextField *textField = (UITextField *)notification.object;
    if (textField.text.length > 0)
        self.showInterfaceType_Current = ENUM_ShowInterfaceTypeIsSearchList;
    //推送实时搜索列表操作类进行网络请求
    @try {
        
        [QNWSNotificationCenter postNotificationName:@"RealTimeKeywordsRequstNotification" object:nil userInfo:@{@"SearchText":textField.text}];
    } @catch (NSException *exception) {QNWSShowException(exception);}
}
-(void)textFieldChanged:(NSNotification *)notification {
    
    UITextField *textField = (UITextField *)notification.object;

    if (textField.text.length > 0)
        self.showInterfaceType_Current = ENUM_ShowInterfaceTypeIsSearchList;
     else if (_showInterfaceType_Last == ENUM_ShowInterfaceTypeIsHistory)
         self.showInterfaceType_Current = ENUM_ShowInterfaceTypeIsHistory;
     else self.showInterfaceType_Current = ENUM_ShowInterfaceTypeIsResultList;
    
    //推送实时搜索列表操作类进行网络请求
    @try {

        [QNWSNotificationCenter postNotificationName:@"RealTimeKeywordsRequstNotification" object:nil userInfo:@{@"SearchText":textField.text}];
    } @catch (NSException *exception) {QNWSShowException(exception);}
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {

    [self selectInterfaceType];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    self.keyWords = textField.text;
    [self textFieldEndEditing];
    return YES;
}

- (void)textFieldEndEditing {

    [_textFiled_SearchBar resignFirstResponder];
        //文本为空
    if (_textFiled_SearchBar.text.length == 0) [self selectInterfaceType];
    //搜索同时不为空，那就显示结果列表
    else self.showInterfaceType_Current = ENUM_ShowInterfaceTypeIsResultList;
}

#pragma mark - set方法
-(void)setShowInterfaceType_Current:(ENUM_ShowInterfaceType)showInterfaceType_Current {

    if (_delegate_SearchBar && [_delegate_SearchBar respondsToSelector:@selector(searchBar:showInterfaceType:)]) {
        
        if (_showInterfaceType_Current != showInterfaceType_Current)
        _showInterfaceType_Last = _showInterfaceType_Current;
        _showInterfaceType_Current = showInterfaceType_Current;
        [_delegate_SearchBar searchBar:self showInterfaceType:_showInterfaceType_Current];
    }
}

-(void)setKeyWords:(NSString *)keyWords {

    _keyWords = keyWords;
    //关键词进行网络请求
    [QNWSNotificationCenter postNotificationName:@"SearchKeyWordsNotification" object:nil userInfo:@{@"text":_keyWords}];
}

- (void)receiveNotificationAction:(NSNotification *)notification {

    _textFiled_SearchBar.text = notification.userInfo[@"text"];
    [self textFieldEndEditing];
}

-(void)dealloc {

    [QNWSNotificationCenter removeObserver:self];
}
@end
