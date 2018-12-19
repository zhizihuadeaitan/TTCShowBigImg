//
//  UIImageView+TTCTool.h
//  TTCShowBigImgDemo
//
//  Created by 赵婷 on 2018/12/18.
//  Copyright © 2018年 赵婷. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageView (TTCTool)

/** 解析gif文件数据的方法 block中会将解析的数据传递出来 */
- (void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray,NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths, NSArray<NSNumber *>* heights))dataBlock;

/** 为UIImageView添加一个设置gif图内容的方法： */
- (void)yh_setImage:(NSURL *)imageUrl;

@end

