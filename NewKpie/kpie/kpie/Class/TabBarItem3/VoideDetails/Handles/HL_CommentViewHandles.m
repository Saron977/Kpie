//
//  HL_CommentViewHandles.m
//  kpie
//
//  Created by sunheli on 16/9/5.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_CommentViewHandles.h"
#import "BYC_HttpServers+HL_VideoPlayVC.h"

#define TableViewCellHeight  80
//// 每一页的评论数
#define KCOMMENTS_OF_PAGE 40
@interface HL_CommentViewHandles ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@end

@implementation HL_CommentViewHandles

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)teacherArray{
    if (!_teacherArray) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
}
-(NSMutableArray *)userArray{
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

-(instancetype)initCommentViewHandles{
    if (self = [super init]) {
      [self createCommentsTableView];  
    }
    return self;
}
-(void)createCommentsTableView{
    if(!self.videoScrollView){
        self.videoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20+screenHeight*0.48, screenWidth, screenHeight -20-screenHeight*0.48 -50)];
        self.videoScrollView.backgroundColor = KUIColorFromRGB(0xFFFFFF);
        self.videoScrollView.delegate = self;
        self.videoScrollView.scrollsToTop = YES;
        }
    self.commentTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,0, screenWidth, screenHeight -20-screenHeight*0.48 - 65) style:UITableViewStyleGrouped];
    self.commentTableView.backgroundColor = KUIColorFromRGB(0xFFFFFF);
#pragma mark ----------- tableView 添加长按点击手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(moreSelect:)];
    longPress.minimumPressDuration = 1.0f;
    [self.commentTableView addGestureRecognizer:longPress];
    [self.videoScrollView addSubview:self.commentTableView];
    self.commentTableView.scrollEnabled = NO;
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    [self.commentTableView registerClass:[WX_CommentsTableViewCell class] forCellReuseIdentifier:@"CommentsTableViewCell"];
    QNWSWeakSelf(self);
    //上拉加载
        self.videoScrollView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.userArray.count > 0 && self.focusListModel != nil) {
                [weakself loadMoreCommentData];
            }
        }];
}

-(void)loadMoreCommentData{
    WX_CommentModel *model = [WX_CommentModel new];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        model = [self.userArray lastObject];        
        QNWSDictionarySetObjectForKey(parameters, self.focusListModel.userid, @"toUserId")
        QNWSDictionarySetObjectForKey(parameters, @2, @"upType")
        QNWSDictionarySetObjectForKey(parameters, [BYC_AccountTool userAccount].userid == nil ? @"" : [BYC_AccountTool userAccount].userid, @"userId")
        QNWSDictionarySetObjectForKey(parameters, self.focusListModel.videoid, @"videoId")
        QNWSDictionarySetObjectForKey(parameters, model.postdatetime, @"postdatetime")
        QNWSDictionarySetObjectForKey(parameters, model.commentid, @"commentId");
        [BYC_HttpServers requestVideoPlayInfoWithWithParameters:parameters success:^(HL_VideoPlayPageModel *videoPlayPageModel) {
            if (videoPlayPageModel.array_OrdCommentModels.count > 0) {
                [self.userArray addObjectsFromArray:videoPlayPageModel.array_OrdCommentModels];
                [self.videoScrollView.footer endRefreshing];
            }
            {
                [self.videoScrollView.footer endRefreshingWithNoMoreData];
            }
            [self showCommentsWithComRowArray:self.userArray TcRowsArray:self.teacherArray];
        } failure:^(NSError *error) {
            [self.videoScrollView.footer endRefreshing];
        }];
}

-(void)setHeight_tableViewHeader:(CGFloat)height_tableViewHeader{
    
    _height_tableViewHeader = height_tableViewHeader;
}

#pragma mark ---------- 长按删除评论
-(void)moreSelect:(UILongPressGestureRecognizer *)gesture
{

    [BYC_LoginAndRigesterView checkLoginStateBlock:^(BOOL isLogin){
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            CGPoint point = [gesture locationInView:self.commentTableView];
            NSIndexPath *indexPath = [self.commentTableView indexPathForRowAtPoint:point];
            if (indexPath == nil) {
                return;
            }
            BYC_AccountModel *accountModel = [BYC_AccountTool userAccount];
            self.deleteCommentModel  = self.dataArray[indexPath.section][indexPath.row];
            // 视频拥有者 ||  评论发表者
            if ([accountModel.userid isEqualToString:self.focusListModel.userid] || [accountModel.userid isEqualToString:self.deleteCommentModel.userid]) {
                UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您想要删除评论 ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
                [alter show];
                
            }else{
                self.deleteCommentModel = nil;
                return;
            }
        }
    }];
}

#pragma mark ------------- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        
        if (buttonIndex == 0) {
            /// 取消删除操作
            self.deleteCommentModel = nil;
            self.isDelete = NO;
            return;
        }else if (buttonIndex == 1){
            
            /// 确认删除操作
            self.isDelete = YES;
            NSArray *arr_parameters = @[self.deleteCommentModel.commentid,self.deleteCommentModel.videoid];
            [self deleteComment:arr_parameters];
        }
}

#pragma mark -------- 删除评论接口
-(void)deleteComment:(NSArray *)arr{
    [BYC_HttpServers requestVideoPlayVCDeletCommentsWithParameters:arr success:^(BOOL isSuccess) {
        if (isSuccess) {
            [QNWSNotificationCenter postNotificationName:@"deletComment" object:nil];
        }
    } failure:^(NSError *error) {
        
    }];
    self.deleteCommentModel = nil;
}

#pragma mark -----获取评论数据
-(void)commentsFromNetWithComList_Array:(NSMutableArray *)comList_Array TcList_Array:(NSMutableArray *)tcList_Array andWithModel:(BYC_BaseVideoModel *)focusListModel{
    
    self.focusListModel = focusListModel;
    [self.dataArray removeAllObjects];
    [self.teacherArray removeAllObjects];
    [self.userArray removeAllObjects];
    if (comList_Array.count == 0 && tcList_Array.count == 0) {
        self.focusListModel.comments = 0;
        CGFloat tableViewHight = _height_tableViewHeader;
        self.commentTableView.frame = CGRectMake(0, 0, screenWidth, tableViewHight);
        self.videoScrollView.contentSize = CGSizeMake(0,tableViewHight+10);
        self.videoScrollView.footer.hidden = YES;
    }
    else{
        [self.videoScrollView.footer endRefreshing];
        self.videoScrollView.footer.hidden = NO;
        self.userArray = comList_Array;
        self.teacherArray = tcList_Array;
        [self showCommentsWithComRowArray:comList_Array TcRowsArray:tcList_Array];
        ;
    }
    [self.commentTableView reloadData];
    
}
-(void)showCommentsWithComRowArray:(NSMutableArray *)comRowsArray TcRowsArray:(NSArray *)tcRowsArray
{
    [self.dataArray removeAllObjects];
#pragma mark -------------- 名师点评
    if (self.teacherArray.count >0) {
        [self.dataArray addObject:self.teacherArray];
    }
    if (self.userArray.count >0) {
        [self.dataArray addObject:self.userArray];
    }
    
    if (self.dataArray.count > 0) {
        /// 根据cell 自适应tableview高度
        CGFloat tableViewHight = _height_tableViewHeader;
        for (WX_CommentModel *commentModel in self.teacherArray) {
            if (!commentModel.isvoice) {
                tableViewHight = tableViewHight + [WX_CommentsTableViewCell cellHeightWithString:commentModel];
            }else{
                tableViewHight += TableViewCellHeight;
            }
        }
        for (WX_CommentModel *commentModel in self.userArray) {
            if (!commentModel.isvoice) {
                tableViewHight = tableViewHight + [WX_CommentsTableViewCell cellHeightWithString:commentModel];
            }else{
                tableViewHight  += TableViewCellHeight;
            }
        }
        QNWSLog(@"tableViewHight == %f",tableViewHight);
        if (self.dataArray.count > 1) {
            self.commentTableView.frame = CGRectMake(0, 0, screenWidth, tableViewHight+TableViewCellHeight+10);
            self.videoScrollView.contentSize = CGSizeMake(0,tableViewHight+TableViewCellHeight+10);

        }
        else{
            self.commentTableView.frame = CGRectMake(0, 0, screenWidth, tableViewHight+40);
            self.videoScrollView.contentSize = CGSizeMake(0,tableViewHight+40);
        }
    }

    [self.commentTableView reloadData];
}

#pragma mark ---------------- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = self.dataArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WX_CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsTableViewCell"];
    if (self.dataArray.count >0) {
        NSArray *array = self.dataArray[indexPath.section];
        WX_CommentModel *model = array[indexPath.row];
        if (self.teacherArray.count > 0 && indexPath.section == 0) {
            [cell setCellWithModel:model UserType:10];
        }else{
                [cell setCellWithModel:model UserType:0];
        }
        
    }
    cell.userArray = self.userArray;
    cell.teachArray = self.teacherArray;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WX_CommentModel *model;
    if (self.dataArray.count > 0) {
        model = self.dataArray[indexPath.section][indexPath.row];
        if (!model.isvoice)return [WX_CommentsTableViewCell cellHeightWithString:model];  //文字
        else return TableViewCellHeight;  //语音
    }
    else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return TableViewCellHeight;  //语音
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc]init];
    sectionView.backgroundColor = KUIColorBackgroundModule1;
    if (self.teacherArray.count > 0 && self.userArray.count > 0) {
        /// 有名师的状态下
        if (section == 0) {
            [self initSectionViewWithType:0 WithView:sectionView];
        }
        else{
           [self initSectionViewWithType:1 WithView:sectionView];
        }
    }
    else if(self.userArray.count > 0){
        /// 没有名师
        [self initSectionViewWithType:1 WithView:sectionView];
    }
    else if (self.teacherArray.count > 0){
       [self initSectionViewWithType:0 WithView:sectionView];
    }
    return sectionView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.videoScrollView.contentOffset.y <= 0) {
        self.videoScrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
}

#pragma mark ------------ 名师, 用户 评论区
// 0 ----名师, 1-----用户 评论
-(void)initSectionViewWithType:(NSInteger)type WithView:(UIView*)sectionView
{
    UIImageView *image_view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_img_pinglunbiaoqian"]];
    [sectionView addSubview:image_view];
    [image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionView.mas_centerY);
        make.left.equalTo(sectionView.mas_left).offset(12);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *lable_title = [[UILabel alloc]init];
    lable_title.enabled = NO;
    lable_title.font = [UIFont systemFontOfSize:13];
    lable_title.textColor = KUIColorWordsBlack1;
    [sectionView addSubview:lable_title];
    [lable_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionView.mas_centerY);
        make.left.equalTo(image_view.mas_right).offset(4);
    }];
    
    if (type == 0) {
        lable_title.text = @"名师点评";
        
    }else if (type == 1){
        lable_title.text = @"最新评论";
        
    }
    [lable_title sizeToFit];
}


@end
