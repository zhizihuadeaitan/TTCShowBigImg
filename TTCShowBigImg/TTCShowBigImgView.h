//
//  TTCShowBigImgView.h
//  TTCShowBigImgDemo
//
//  Created by 赵婷 on 2018/12/17.
//  Copyright © 2018年 赵婷. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImageView+TTCTool.h"

@import UIKit;

#import "TTCPicCollectionViewCell.h"

@class TTCShowBigImgView;

typedef void(^XHPicBlock)(CLICKEVENTTYPE clickType);

@interface TTCShowBigImgView : UIView


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


- (instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray *)imgs;

@end

