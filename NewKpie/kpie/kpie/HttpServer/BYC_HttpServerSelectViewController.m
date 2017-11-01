//
//  BYC_HttpServerSelectViewController.m
//  kpie
//
//  Created by 元朝 on 16/6/6.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_HttpServerSelectViewController.h"
#import "BYC_PropertyManager.h"

NSString * const key_IP = @"IP";

@interface BYC_HttpServerSelectViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *_tableView;
    NSArray     *_array_dataSource;
    NSString    *_string_selectedHost;
}

@end

@implementation BYC_HttpServerSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array_dataSource = @[
                    @"http://api.kpie.com.cn/",
                    @"http://192.168.22.189:8088/",
                    ];
    self.title = @"服务器选择 PS:点我手动选择";
    [self setupNavBar];
    [self initTableView];
}

- (void)setupNavBar {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
}

- (void)tapAction {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"手动选择服务器" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
       textField.placeholder = @"自己填写服务器,省略http://和末尾/";
    }];
    
    UIAlertAction *action_OK = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        _string_selectedHost =[[@"http://" stringByAppendingString: alertController.textFields.firstObject.text] stringByAppendingString:@"/"];
        [self exeOpenApp];
        
    }];
    
    UIAlertAction *action_Cancel = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action_Cancel];
    [alertController addAction:action_OK];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)initTableView {
    
    //创建tableView
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    _tableView.rowHeight = 50;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 140)];
    _tableView.tableFooterView = footer;
    
    //确定按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake((screenWidth - 120)/2, 50, 120, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
}

- (void)btnDidClick:(UIButton *)btn {
    
    btn.enabled = NO;
    
    [self exeOpenApp];
}

- (void)exeOpenApp {
    
    if(_string_selectedHost == nil) {
        [[[UIAlertView alloc] initWithTitle:@"警告" message:@"请选择服务器主机!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
        return;
    }

    NSString *str_IP = QNWSUserDefaultsObjectForKey(key_IP);
    if (![str_IP isEqualToString:_string_selectedHost]) {
        QNWSUserDefaultsSetObjectForKey(_string_selectedHost, key_IP);
        //清除登陆状态
        [BYC_AccountTool clearUserAccount];
    }
    
    QNWS_Main_HostIP = _string_selectedHost;
    _makeSure();
}

#pragma mark - TableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _array_dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = _array_dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _string_selectedHost = _array_dataSource[indexPath.row];
}

- (void)dealloc {

    QNWSLog(@"选择结束");
}

@end
