//
//  WX_AddTopicViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_AddTopicViewController.h"
#import "WX_UploadVideoViewController.h"
#import "WX_AddTopicCollectionViewCell.h"
#import "WX_AddTopicModel.h"
#import "WX_UploadVideoViewController.h"



@interface WX_AddTopicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, retain)  NSMutableArray            * dataArray;
@property(nonatomic, retain)  UICollectionView          *topicCollcetionView;

@end

@implementation WX_AddTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
}

-(void)createUI
{
    self.dataArray = [[NSMutableArray alloc]init];
    
    self.title = @"添加热门话题";
    
    [self createCollection];
    
    [self loadDataFromNetwork];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 55, 44);
    [backBtn setTitle:@" " forState:UIControlStateNormal];
     backBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-n"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon-back-h"] forState:UIControlStateHighlighted];
    [backBtn setTitleColor:KUIColorBaseGreenNormal forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, -8);
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createCollection
{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.minimumLineSpacing = 2;
    flowlayout.itemSize = CGSizeMake(screenWidth/2-2, screenHeight/10);
    
    self.topicCollcetionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight -KHeightNavigationBar) collectionViewLayout:flowlayout];
    self.topicCollcetionView.dataSource = self;
    self.topicCollcetionView.delegate = self;
    self.topicCollcetionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topicCollcetionView];
    
    [self.topicCollcetionView registerClass:[WX_AddTopicCollectionViewCell class] forCellWithReuseIdentifier:@"WX_AddTopicCollectionViewCell"];
    
    
}

-(void)loadDataFromNetwork
{
    [self.dataArray removeAllObjects];
    
    NSDictionary *dic = @{@"page":@"1",@"rows":@"20"};
    [BYC_HttpServers Get:KQNWS_GetEliteListVideoThemeUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL isSuccess = responseObject[@"success"];
        NSString *str_Msg = responseObject[@"msg"];
        if (isSuccess) {
            //        NSDictionary *dic = (NSDictionary *)responseObject;
            NSArray *array = responseObject[@"data"];
            
            for (NSDictionary *dic in array) {
                WX_AddTopicModel *model = [[WX_AddTopicModel alloc]init];
                [model saveDataWithDic:dic];
                [self.dataArray addObject:model];
            }
            
            [self.topicCollcetionView reloadData];
            
        }else{
            [self.view showAndHideHUDWithTitle:str_Msg WithState:BYC_MBProgressHUDHideProgress];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QNWSLog(@"话题接口数据请求失败");
        QNWSLog(@"error == %@",error);
    }];
}

#pragma mark ----------------- UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WX_AddTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WX_AddTopicCollectionViewCell" forIndexPath:indexPath];
    WX_AddTopicModel *topicModel = self.dataArray[indexPath.row];
    cell.topiclabel.text = topicModel.themeName;
    cell.topiclabel.userInteractionEnabled = YES;
    cell.topiclabel.tag = 300 +indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [cell.topiclabel addGestureRecognizer:tap];
    return cell;
   
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tap:(UITapGestureRecognizer*)tap
{
    NSInteger row = tap.view.tag -300;
    WX_AddTopicModel *model = self.dataArray[row];
    if (self.block) {
        self.block(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
