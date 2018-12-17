//
//  TTCPicCollectionViewCell.h
//  CatmallToC
//
//  Created by 无名氏 on 2018/4/26.
//  Copyright © 2018年 Catmall. All rights reserved.
//

@import UIKit;

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define TabbarSafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)
//屏幕适配
#define WIDTH ([UIScreen mainScreen].bounds.size.width / 375)
#define HEIGHT (SCREEN_HEIGHT == 812.0 ? 1: SCREEN_HEIGHT/667.0)
#define TabBar_HEIGHT  49
#define FONT_TEXTSIZE(size) [UIFont systemFontOfSize:size * HEIGHT]

typedef NS_ENUM(NSUInteger,CLICKEVENTTYPE) {
    CLICKEVENTTYPE_CLICK = 1,//单击事件
    CLICKEVENTTYPE_DOUBLE = 2,//双击事件
};

typedef void(^HiddenBlcok)(CLICKEVENTTYPE clickType);

@interface TTCPicCollectionViewCell : UICollectionViewCell <UIScrollViewDelegate>
@property (nonatomic, copy) HiddenBlcok myBlock;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end
