//
//  HL_VideodetailView.h
//  kpie
//
//  Created by sunheli on 16/7/16.
//  Copyright © 2016年 QNWS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYC_BackFocusListCellModel.h"
#import "BYC_BaseVideoModel.h"

typedef NS_ENUM(NSUInteger, BYC_FocusCollectionViewCellSelected) {
    BYC_FocusCollectionViewCellSelectedShoot = 1,  //合拍按钮
    BYC_FocusCollectionViewCellSelectedFocus,       //关注按钮
};
typedef BYC_BackFocusListCellModel *(^ClickButtonBlock)(BYC_FocusCollectionViewCellSelected selectButton ,BYC_BaseVideoModel *model);
typedef void (^ClickHeaderButtonBlock)(BYC_BaseVideoModel *model);

@interface HL_VideodetailView : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextViewDelegate>

@property (nonatomic, strong) UIView        *view_userMassage;    /**<  用户基本信息栏*/
@property (nonatomic, strong) UIImageView   *imageV_userIcon;
@property (nonatomic, strong) UILabel       *lable_userNickName;
@property (nonatomic, strong) UIImageView   *imageV_userSex;
@property (nonatomic, strong) UILabel       *lable_ReleaseTime;
@property (nonatomic, strong) UIImageView   *imageV_playedICon;
@property (nonatomic, strong) UILabel       *lable_playedCount;
@property (nonatomic, strong) UIButton      *button_shoot;        /**<     合拍按钮*/
@property (nonatomic, strong) UIButton      *button_Focus;          /**<     关注按钮*/

@property (nonatomic, strong) UITextView       *lable_VideoDescription;     /**<    视频简介*/

@property (nonatomic, strong) UIView        *view_script;

@property (nonatomic, strong) UIView            *view_like;                   /**<    点赞过的*/
@property (nonatomic, strong) UILabel           *lable_likeCount;             /**<    点赞过的人数*/
@property (nonatomic, strong) UICollectionView  *collectionView_likeIcon;     /**<    点赞过的人的头像CollectionView*/
@property (nonatomic, strong) UIImageView       *imageV_likeIcon;              /**<    点赞过的人的头像*/

@property (nonatomic, strong) UIButton          *button_morelike;
@property (nonatomic, strong) UIView            *view_script2;

@property (nonatomic, strong) BYC_BaseVideoModel *focusListModel;

@property (nonatomic, strong) NSArray     *likeArr;

/**  存放主题 */
@property (nonatomic, strong) NSMutableArray                *array_Topic;
/**  存放网址 */
@property (nonatomic, strong) NSMutableArray                *array_Url;


@property (nonatomic, copy)  ClickButtonBlock  selectButton;
@property (nonatomic, copy)  ClickHeaderButtonBlock  clickHeaderButtonBlock;

+(CGFloat)returnHeightOfFocusHeaderView:(BYC_BaseVideoModel *)model;

@end
