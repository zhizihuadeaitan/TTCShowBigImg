//
//  MGPicCollectionViewCell.m
//  CatmallToC
//
//  Created by 无名氏 on 2018/4/26.
//  Copyright © 2018年 Catmall. All rights reserved.
//

#import "TTCPicCollectionViewCell.h"

@implementation TTCPicCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = YES;
        [self.contentView addSubview:self.scrollView];
        self.scrollView.opaque = YES;
        [self.scrollView addSubview:self.imageView];
        self.imageView.opaque = YES;
        
    }
    return self;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        //一个手指
        UITapGestureRecognizer *singleClickDog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singliDogTap:)];
        singleClickDog.numberOfTapsRequired = 1;
        singleClickDog.numberOfTouchesRequired = 1;
        [_imageView addGestureRecognizer:singleClickDog];
        
        //双击
        UITapGestureRecognizer *doubleClickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        //需要点两下
        doubleClickTap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:doubleClickTap];
        
        //如果双击了，则不响应单击事件
        [singleClickDog requireGestureRecognizerToFail:doubleClickTap];
        
        //两个手指
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTwoFingerTap:)];
        //需要两个手指touch
        twoFingerTap.numberOfTouchesRequired = 2;
        [_imageView addGestureRecognizer:twoFingerTap];
        
        [_scrollView setZoomScale:1];
        
    }
    
    return _imageView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height )];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
    }
    return _scrollView;
}

#pragma mark - ScrollView Delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
//缩放系数(倍数)
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}


#pragma mark - 事件处理
- (void)singliDogTap:(UITapGestureRecognizer *)gestureRecognizer
{
    
    if (_myBlock)
    {
        _myBlock(gestureRecognizer.numberOfTapsRequired);
    }
}
- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    if (_myBlock)
    {
        _myBlock(gestureRecognizer.numberOfTapsRequired);
    }
    if (gestureRecognizer.numberOfTapsRequired == 2)
    {
        if(_scrollView.zoomScale == 1){
            float newScale = [_scrollView zoomScale] *2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
        }else{
            float newScale = [_scrollView zoomScale]/2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
        }
    }
}

- (void)handelTwoFingerTap:(UITapGestureRecognizer *)gestureRecongnizer
{
    if (_myBlock)
    {
        _myBlock(gestureRecongnizer.numberOfTapsRequired);
    }
    float newScale = [_scrollView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecongnizer locationInView:gestureRecongnizer.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark - 缩放大小获取方法
- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    //大小
    zoomRect.size.height = _scrollView.frame.size.height/scale;
    zoomRect.size.width = _scrollView.frame.size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}
@end
