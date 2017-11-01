//
//  HL_AddFocusViewController.m
//  kpie
//
//  Created by sunheli on 16/9/21.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "HL_AddFocusViewController.h"
#import "HL_AddFocusHandles.h"


@interface HL_AddFocusViewController ()

@property (nonatomic, strong)HL_AddFocusHandles *addFocusHandlesView;

@end

@implementation HL_AddFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加关注";
    [self.view addSubview:self.addFocusHandlesView.view_AddFocus];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.addFocusHandlesView.indexPath != nil) {
       [self.addFocusHandlesView.collectionView reloadItemsAtIndexPaths:@[self.addFocusHandlesView.indexPath]]; 
    }
    else{
      [self.addFocusHandlesView.collectionView reloadData];  
    }
}

-(HL_AddFocusHandles *)addFocusHandlesView{
    
    if (!_addFocusHandlesView) {
        _addFocusHandlesView = [[HL_AddFocusHandles alloc]initAddFocusListCollectionViewHandle];
        
    }
    return _addFocusHandlesView;
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
