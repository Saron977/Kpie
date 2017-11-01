//
//  BYC_MTVideoGroupModel.h
//  kpie
//
//  Created by 元朝 on 16/4/12.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import "BYC_BaseModel.h"

@interface BYC_MTVideoGroupModel : BYC_BaseModel

/**栏目组编号*/
@property (nonatomic, copy)  NSString  *videoGroup_Id;
/**栏目组名称*/
@property (nonatomic, copy)  NSString  *videoGroup_Name;



/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/

@property (nonatomic, assign) NSInteger isshow;

@property (nonatomic, copy) NSString *groupname;

@property (nonatomic, copy) NSString *memo;

@property (nonatomic, copy) NSString *groupid;

@property (nonatomic, copy) NSString *columnid;

@property (nonatomic, assign) NSInteger createdate;

/*🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻新接口模型🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻*/

@end
