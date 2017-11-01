//
//  HL_SearchBar.h
//  kpie
//
//  Created by sunheli on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HL_SearchBar;
@protocol SearchBarDelegate <NSObject>

@optional

- (void)searchBarDidtouch:(HL_SearchBar *)searchBar;

- (void)searchBar:(HL_SearchBar *)searchBar didSearch:(NSString *)text;

- (void)searchBar:(HL_SearchBar *)searchBar textDidChange:(NSString *)searchText;

@end

@interface HL_SearchBar : UIView


@property (nonatomic,weak) id<SearchBarDelegate> delegate;
//是否可以编辑
@property (nonatomic,assign) BOOL canEditing;

//占位文字
@property (nonatomic,copy) NSString *placeHolder;

//背景颜色
@property (nonatomic,strong) UIColor *bgColor;

@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) UITextField *textField;
@end
