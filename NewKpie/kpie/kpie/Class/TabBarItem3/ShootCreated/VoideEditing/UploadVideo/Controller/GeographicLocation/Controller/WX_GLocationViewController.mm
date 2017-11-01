//
//  WX_GLocationViewController.m
//  kpie
//
//  Created by 王傲擎 on 15/11/20.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "WX_GLocationViewController.h"
#import "WX_GeoLoctionTableViewCell.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>


@interface WX_GLocationViewController ()<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, retain) NSMutableArray         *searchArray;
@property(nonatomic, retain) BMKLocationService     *location;
@property(nonatomic, retain) BMKGeoCodeSearch       *geoCodeSearch;
@property(nonatomic, retain) UITableView            *locationTableView;
@property(nonatomic, assign) BOOL                   isFail;



@end

@implementation WX_GLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    
    [self createLocationFromNet];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.location stopUserLocationService];
    self.location.delegate = nil;
    self.geoCodeSearch.delegate = nil;
    self.location = nil;
    self.geoCodeSearch = nil;
    
    
}

-(void)createUI
{
    self.searchArray = [[NSMutableArray alloc]init];
    
    self.isFail = NO;
    
    self.title = @"选择当前位置";
    
    self.locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KHeightNavigationBar, screenWidth, screenHeight-KHeightNavigationBar)];
    self.locationTableView.backgroundColor = [UIColor clearColor];
    self.locationTableView.dataSource = self;
    self.locationTableView.delegate = self;
    self.locationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.locationTableView];
    
    [self.locationTableView registerNib:[UINib nibWithNibName:@"WX_GeoLoctionTableViewCell" bundle:nil] forCellReuseIdentifier:@"WX_GeoLoctionTableViewCell"];
    
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

-(void)createLocationFromNet
{
    self.location = [[BMKLocationService alloc]init];
    self.location.delegate = self;
    [self.location startUserLocationService];
}

#pragma mark ---------------- UITableViewDelegate,UITableViewDataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WX_GeoLoctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WX_GeoLoctionTableViewCell"];
    
    BMKPoiInfo *info = self.searchArray[indexPath.row];
    [cell creatTheCellWithName:info.name Adress:info.address];
    
    UIView *backView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
    
    cell.backGView.tag = 300 +indexPath.row;
    cell.backGView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [cell.backGView addGestureRecognizer:tap];
    
    [cell setBackgroundView:[[UIView alloc]init]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//       return YES;
//}


-(void)tap:(UITapGestureRecognizer*)tap
{
    NSInteger row = tap.view.tag - 300;
    BMKPoiInfo *info = self.searchArray[row];
    WX_GlocationModel *model = [[WX_GlocationModel alloc]init];
    model.longitude = [NSString stringWithFormat:@"%f",info.pt.longitude];
    model.latitude = [NSString stringWithFormat:@"%f",info.pt.latitude];
    model.address = info.name;
    
    if (self.block) {
        self.block(model);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark ---------------- BMKLocationServiceDelegate
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    self.geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = userLocation.location.coordinate;
    
    if (!self.isFail) {
        if ([self.geoCodeSearch reverseGeoCode:option]) {
            QNWSLog(@"检索成功,即将获取附近位置信息");
        }else{
            self.isFail = YES;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"附近信息检索失败,请打开定位或核查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }

}

#pragma mark ------------- BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    if (self.searchArray.count == 0) {
        for (BMKPoiInfo *info in result.poiList) {
            QNWSLog(@"name == %@",info.name);
            QNWSLog(@"address == %@ ",info.address);
        }
        [self.searchArray addObjectsFromArray:result.poiList];
        [self.locationTableView reloadData];
    }
    
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
