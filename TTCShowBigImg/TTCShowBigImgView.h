//
//  TTCShowBigImgView.h
//  TTCShowBigImgDemo
//
//  Created by 赵婷 on 2018/12/17.
//  Copyright © 2018年 赵婷. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@import UIKit;

typedef NS_ENUM(NSUInteger,IMAGETYPE) {
    IMAGETYPE_ASSETS = 1,//相册图片
    IMAGETYPE_URL = 2,//网络图片
    IMAGETYPE_IMAGE = 3//本地图片
};

#import "TTCPicCollectionViewCell.h"

@class TTCShowBigImgView;

typedef void(^XHPicBlock)(CLICKEVENTTYPE clickType);

@interface TTCShowBigImgView : UIView

@property (nonatomic, assign) IMAGETYPE imageType;

/** 关闭按钮 */
@property (nonatomic, strong) UIButton *delBtn;
/** 保存按钮 */
@property (nonatomic, strong) UIButton *saveBtn;
/** 首次展示第几张图 */
@property (nonatomic, assign) NSInteger selectInteger;
/** 点击事件 */
@property (nonatomic, copy) XHPicBlock eventBlock;

@property (nonatomic, strong) UICollectionView *collectionView;
/** 查看到第几张图 */
@property (nonatomic, strong) UILabel *imgCountLabel;
/** 弹出框 */
@property (nonatomic, strong) UILabel *showMessageLabel;
/** 弹出框展示信息*/
@property (nonatomic, copy) NSString *showMessageStr;


- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray *)imgs withImgeType:(IMAGETYPE)imageType;

@end

