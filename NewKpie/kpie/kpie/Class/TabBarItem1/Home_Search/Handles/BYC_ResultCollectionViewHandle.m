//
//  BYC_ResultCollectionViewHandle.m
//  kpie
//
//  Created by 元朝 on 16/5/17.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_ResultCollectionViewHandle.h"
#import "BYC_ResultUsersCollectionViewHandle.h"
#import "BYC_SelecteItemView.h"
#import "BYC_AccountTool.h"
#import "BYC_SearchAccountModel.h"
#import "BYC_HistoryKeywordsHandel.h"

@interface BYC_ResultCollectionViewHandle()<UIScrollViewDelegate,BYC_SelecteItemViewDelegate>

/**顶部视图*/
@property (nonatomic, strong)  BYC_SelecteItemView  *selecteItemView_TopBar;
/**内容滑动视图*/
@property (nonatomic, strong)  UIScrollView  *scrollView;
/**搜索用户列表*/
@property (nonatomic, strong)  BYC_ResultUsersCollectionViewHandle  *handle_ResultUsersCollectionView;

@end

@implementation BYC_ResultCollectionViewHandle

- (instancetype)initResultCollectionViewHandle {
    
    self = [self init];
    if (self) {
        
        [self initParameters];
        [self setupViewContainer];
    }
    
    return self;
}

- (void)initParameters {

    [QNWSNotificationCenter addObserver:self selector:@selector(kLoginSuccessed) name:KSTR_KLoginSuccessed object:nil];
}

- (void)setupViewContainer {

    _view_Container = ({
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - KHeightNavigationBar)];
        view;
    });
    
    _selecteItemView_TopBar = ({
    
        BYC_SelecteItemView *selecteItemView = [[BYC_SelecteItemView alloc] init];
        selecteItemView.delegate_SelecteItemView = self;
        selecteItemView.array_Titles = @[@"用户",@"内容"];
        [_view_Container addSubview:selecteItemView];
        [selecteItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.leading.trailing.equalTo(selecteItemView.superview);
            make.height.offset(37);
        }];
        selecteItemView;
    });

    _scrollView = ({
    
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.contentSize = CGSizeMake(screenWidth * 2, scrollView.kheight);
        scrollView.showsHorizontalScrollIndicator = NO;
        [_view_Container addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.trailing.bottom.equalTo(scrollView.superview);
            make.top.equalTo(_selecteItemView_TopBar.mas_bottom);
        }];
        scrollView;
    });
    
    [self setupScrollViewSubViews];
}

- (void)setupScrollViewSubViews {

    @try {
        [_scrollView addSubview:self.handle_ResultUsersCollectionView.collectionView];
        [_scrollView addSubview:self.handle_ResultDynamicCollectionView.tableView];
    } @catch (NSException *exception) {
        QNWSLog(@"exception = %@",exception);
    }

}

#pragma mark - get方法
-(BYC_ResultUsersCollectionViewHandle *)handle_ResultUsersCollectionView {

    __weak __typeof(self) weakSelf = self;
    if (_handle_ResultUsersCollectionView == nil) _handle_ResultUsersCollectionView = [[BYC_ResultUsersCollectionViewHandle alloc] initResultUsersCollectionViewHandle:^(int count) {
        weakSelf.selecteItemView_TopBar.array_Titles = @[[NSString stringWithFormat:@"用户(%d)",count],weakSelf.selecteItemView_TopBar.array_Titles[1]];
    }];
    return _handle_ResultUsersCollectionView;
}

-(BYC_ResultDynamicCollectionViewHandle *)handle_ResultDynamicCollectionView {

    __weak __typeof(self) weakSelf = self;
    if (_handle_ResultDynamicCollectionView == nil) _handle_ResultDynamicCollectionView = [[BYC_ResultDynamicCollectionViewHandle alloc] initResultDynamicCollectionViewHandle:^(int count) {
        weakSelf.selecteItemView_TopBar.array_Titles = @[weakSelf.selecteItemView_TopBar.array_Titles[0],[NSString stringWithFormat:@"视频(%d)",count]];
    }];
    return _handle_ResultDynamicCollectionView;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [_selecteItemView_TopBar bottomViewScrollOffset:scrollView.contentOffset.x];
}

#pragma mark - BYC_SelecteItemViewDelegate

-(void)selecteItemView:(BYC_SelecteItemView *)selecteItemView selectedIndex:(NSUInteger)index {

    [_scrollView setContentOffset:CGPointMake(screenWidth * index, 0) animated:YES];
}

-(void)setString_KeyWords:(NSString *)string_KeyWords {

    if (string_KeyWords.length == 0) return;
    _string_KeyWords = string_KeyWords;
    self.handle_ResultUsersCollectionView.string_KeyWords = _string_KeyWords;
    self.handle_ResultDynamicCollectionView.string_KeyWords = _string_KeyWords;
    [BYC_HistoryKeywordsHandel handleHistoryKeyword:_string_KeyWords];
}

- (void)kLoginSuccessed {
    
    if (_string_KeyWords) {
    
        self.handle_ResultUsersCollectionView.isLoginReloadData = YES;
        self.handle_ResultDynamicCollectionView.isLoginReloadData = YES;
        self.string_KeyWords = _string_KeyWords;
    }
}

-(void)dealloc {
    
    [QNWSNotificationCenter removeObserver:self];
}
@end