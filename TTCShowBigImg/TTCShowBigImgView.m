//
//  TTCShowBigImgView.m
//  TTCShowBigImgDemo
//
//  Created by 赵婷 on 2018/12/17.
//  Copyright © 2018年 赵婷. All rights reserved.
//

#import "TTCShowBigImgView.h"

#define TTCPicCell @"TTCPicCollectionViewCell"
/**
 *  视图展示结构,基于CollectionView
 */
@interface TTCShowBigImgView()<UICollectionViewDelegate,UICollectionViewDataSource>


/** 要展示的图片 */
@property (nonatomic, strong) NSMutableArray *imgArr;
/** 图片缓存 */
@property(nonatomic, strong) NSMutableDictionary *imageDictM;
/** 线程缓存 */
@property(nonatomic, strong) NSMutableDictionary *operationsDictM;
/** 执行子线程的队列 */
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation TTCShowBigImgView

//初始化 网络图片
-(instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray *)imgs withImgeType:(IMAGETYPE)imageType
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        if (imageType) {
            _imageType = imageType;
        }
        else
        {
            _imageType = IMAGETYPE_URL;
        }
        
        self.backgroundColor = [UIColor blackColor];
        
        
        
        _selectInteger = 0;
        _imgArr = [NSMutableArray arrayWithArray:imgs];
        
        self.collectionView.frame = CGRectMake(0,0, frame.size.width, frame.size.height );
        [self addSubview:self.collectionView];
        
        [self createUI];
        
        
    }
    return self;
}

- (void)saveMethod
{
    //    [SVProgressHUD show];
    
    switch (_imageType) {
        case IMAGETYPE_URL:
        {
            NSString *urlString = self.imgArr[self.selectInteger];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
            
            if ([urlString containsString:@".gif"]) {
                [self saveGif:data];
                
            }
            else
            {
                UIImage *image = [UIImage imageWithData:data]; // 取得图片
                //保存图片
                [self saveImage:image];
            }
        }
            break;
            
            
        default:
        {
            if (self.imgArr.count > 0) {
                UIImage *image = self.imgArr[self.selectInteger];
                //保存图片
                [self saveImage:image];
            }
        }
            break;
    }
    
}
- (void)setImageType:(IMAGETYPE)imageType
{
    _imageType = imageType;
    [self.collectionView reloadData];
}
- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.tag = 4;
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveMethod) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _saveBtn;
}
- (void)saveGif:(NSData *)gifData
{
    
    // 保存到本地相册
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:gifData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        //        [TTCGCDQueue executeInMainQueue:^{
        //            [SVProgressHUD dismiss];
        //        }];
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                [SVProgressHUD showSuccessWithStatus:@"图片保存失败"];
            });
            
        }
        else
        {
            NSLog(@"Success at %@", [assetURL path] );
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //                [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
            });
            
            
        }
    }] ;
}
//    // 本地沙盒目录

//
//
//     UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//}
- (void)saveImage:(UIImage *)image {
    
    // 本地沙盒目录
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyImage"];
    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
    BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
    if (success){
        NSLog(@"写入本地成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [SVProgressHUD dismiss];
            //
            //            [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
            
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [SVProgressHUD dismiss];
            
        });
        
        
        
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        // Fail
    } else {
        // Success
    }
}
- (UIButton *)delBtn
{
    if (!_delBtn) {
        UIImage *img = [UIImage imageNamed:@"Img_closex"];
        
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.tag = 4;
        [self.superview addSubview:_delBtn];
        _delBtn.frame = CGRectMake(10 ,40 , img.size.width * 2, img.size.height*2);
        [_delBtn setImage:img forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delMethod) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _delBtn;
}
- (void)delMethod
{
    self.hidden = YES;
    [self removeFromSuperview];
    
}

- (void)setImgArr:(NSMutableArray *)imgArr
{
    _imgArr = imgArr;
    
    self.imgCountLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)_selectInteger + 1,(unsigned long)imgArr.count];
    
    [self.collectionView reloadData];
    
    
}
- (void)setSelectInteger:(NSInteger)selectInteger
{
    _selectInteger = selectInteger;
    if (self.imgArr.count > 0) {
        self.imgCountLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)_selectInteger + 1,(unsigned long)self.imgArr.count];
        
    }
    else
    {
        if (self.imgArr.count > 0) {
            self.imgCountLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)_selectInteger + 1,(unsigned long)self.imgArr.count];
            
        }
        
        
    }
    [self.imgCountLabel sizeThatFits:[self sizeWithText:self.imgCountLabel.text font:FONT_TEXTSIZE(12) maxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)]];
    
    
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width * _selectInteger, 0 ) animated:NO];
    
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    if (!text) {
        text = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:2.0f];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [text length])];
    
    CGSize realSize = CGSizeZero;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    CGRect textRect = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil];
    realSize = textRect.size;
#else
    realSize = [txt sizeWithFont:font constrainedToSize:size];
#endif
    
    realSize.width = ceilf(realSize.width);
    realSize.height = ceilf(realSize.height);
    return realSize;
}
//    self.pageControl.currentPage = selectInteger;
//    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView//当滑动条动时小圆点和图片也动
{
    // 计算页数
    int index = scrollView.contentOffset.x/self.frame.size.width;
    
    _selectInteger = index;
    if (self.imgArr.count > 0) {
        self.imgCountLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)_selectInteger + 1,(unsigned long)self.imgArr.count];
        
    }
    [self.imgCountLabel sizeThatFits:[self sizeWithText:self.imgCountLabel.text font:FONT_TEXTSIZE(12) maxSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)]];
    
}


#pragma mark--methd
- (void)pageClick:(UIPageControl *)page
{
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width*page.currentPage, 0 ) animated:YES];
}


/**
 *  CollectionView 代理
 */
#pragma mark - Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _imgArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.frame.size.width, _collectionView.frame.size.height);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TTCPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TTCPicCell forIndexPath:indexPath];
    if(cell == nil)
        
    {
        cell = [[TTCPicCollectionViewCell alloc]init];
        
    }
    cell.imageView.image = nil;
    switch (_imageType) {
        case IMAGETYPE_URL:
        {
            //网络图片
            UIImage *img = [self imageForCell_imageURL:_imgArr[indexPath.item] indexPath:indexPath];
            [cell.imageView setImage:img];
        }
            break;
        case IMAGETYPE_IMAGE:
        {
            //本地图片
            [cell.imageView setImage:_imgArr[indexPath.item]];
            
        }
            break;
        case IMAGETYPE_ASSETS:
        {
            //相册图片
            if ([_imgArr [indexPath.item]isKindOfClass:[ALAsset class]])
            {
                @autoreleasepool {
                    //这里尽量不用thumbnail属性，因为太模糊了，可以用aspectRatioThumbnail比例缩略图代替
                    ALAsset *asset = _imgArr [indexPath.item];
                    //这里就不要用thumbnail属性了，太模糊
                    __block UIImage * image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        if (asset.defaultRepresentation.fullScreenImage) {
                            
                            image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                        }
                        if (!image)
                        {
                            if (asset.aspectRatioThumbnail) {
                                image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                            }
                            if (image)
                            {
                                [self.imgArr replaceObjectAtIndex:indexPath.item withObject:image];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [cell.imageView setImage:image];
                                    
                                });
                                
                                
                            }
                            else
                            {
                                if (asset.thumbnail) {
                                    
                                    image = [UIImage imageWithCGImage:asset.thumbnail];
                                }
                                if (image)
                                {
                                    [_imgArr replaceObjectAtIndex:indexPath.item withObject:image];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [cell.imageView setImage:image];
                                        
                                    });
                                }
                            }
                            
                        }
                        else
                        {
                            [self.imgArr replaceObjectAtIndex:indexPath.item withObject:image];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [cell.imageView setImage:image];
                                
                            });
                        }
                    });
                }
                
            }
            
        }
            break;
        default:
            break;
    }
    
    __weak typeof (self)weakSelf = self;
    cell.myBlock = ^(CLICKEVENTTYPE clickType){
        
        if (weakSelf.eventBlock) {
            weakSelf.eventBlock(clickType);
        }
        
    };
    return cell;
}
- (UIImage *)imageForCell_imageURL:(NSString *)imageURL indexPath:(NSIndexPath *)indexPath{
    
    //1.从内存中读取缓存图片
    UIImage *image = [self.imageDictM objectForKey:imageURL];
    if (image) {
        NSLog(@"从内存中读取图片缓存");
        return image;
    }
    
    //2.如果内存中不存在，再去沙盒中查看是否有缓存图片
    
    //保存到沙河缓存
    NSString *caches= [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];//文件夹路径
    //获得图片名称,不能包含/   "http://p19.qhimg.com/dr/48_48_/t0164ad383c622aabef.png"
    NSString *fileName = [imageURL lastPathComponent];
    //拼接图片的全路径
    NSString *imageCachePath = [caches  stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imageCachePath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:imageCachePath];
        UIImage *image = [UIImage imageWithData:imageData];
        NSLog(@"从沙盒中读取图片缓存");
        return image;
    }
    
    //3.1 如果沙盒中不存在，再看看线程池中是否存在正在下载该图片的子线程
    //3.2 如果该子线程�不存在, 则开启新的子线程来下载图片，并在下载成功后刷新对应视图
    
    NSBlockOperation *operation = [self.operationsDictM objectForKey:imageURL];
    if (!operation) {
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            //开始下载图片
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            UIImage *downloadImage = [UIImage imageWithData:imageData];
            
            //容错处理
            if (!downloadImage) {
                [self.operationsDictM removeObjectForKey:imageURL];
                return;
            }
            
            //将下载后的图片保存到内存和沙盒中
            [self.imageDictM setObject:downloadImage forKey:imageURL];
            [imageData writeToFile:imageCachePath atomically:YES];
            
            //线程执行完成后, 要将其从线程池中移走
            [self.operationsDictM removeObjectForKey:imageURL];
            
            //切换到主线程中刷新图片
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]]];
                //                [self.collectionView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationBottom];
            }];
        }];
        //添加线程到缓存池中
        [self.operationsDictM setObject:blockOperation forKey:imageURL];
        //子线程添加到队列中，开始执行
        [self.queue addOperation:blockOperation];
    }
    
    //4. 返回占位图片
    return [UIImage imageNamed:@""];
}


#pragma mark - 事件

#pragma mark - 懒加载

//这里可以粘贴图片上分享/保存等按钮 备用
-(void)createUI
{
    [self addSubview:self.delBtn];
    _delBtn.frame = CGRectMake(0, 10 * HEIGHT+ TabbarSafeAreaBottomHeight, 60 * WIDTH, 50 * HEIGHT);
    
    _delBtn.userInteractionEnabled = YES;
    
    [self addSubview:self.saveBtn];
    _saveBtn.frame = CGRectMake(SCREEN_WIDTH - 70 * WIDTH, 10 * HEIGHT+ TabbarSafeAreaBottomHeight, 70 * WIDTH, TabBar_HEIGHT + TabbarSafeAreaBottomHeight);
    
    _saveBtn.userInteractionEnabled = YES;
    
    
    [self addSubview:self.imgCountLabel];
    _imgCountLabel.frame = CGRectMake(15 * WIDTH, SCREEN_HEIGHT - TabBar_HEIGHT - TabbarSafeAreaBottomHeight, 70 * WIDTH, TabBar_HEIGHT + TabbarSafeAreaBottomHeight);
    
    
}
- (UILabel *)imgCountLabel
{
    if (!_imgCountLabel)
    {
        _imgCountLabel = [[UILabel alloc]init];
        _imgCountLabel.textColor = [UIColor whiteColor];
        _imgCountLabel.font = FONT_TEXTSIZE(12);
    }
    return _imgCountLabel;
}
- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    
    return _flowLayout;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TTCPicCollectionViewCell class] forCellWithReuseIdentifier:TTCPicCell];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSMutableDictionary *)imageDictM
{
    if (!_imageDictM) {
        //初始化图片缓存池
        _imageDictM = [NSMutableDictionary dictionary];
        
    }
    return _imageDictM;
}

- (NSMutableDictionary *)operationsDictM
{
    if (!_operationsDictM) {
        //初始化线程缓存池
        _operationsDictM = [NSMutableDictionary dictionary];
        
    }
    return _operationsDictM;
}
- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}

@end
