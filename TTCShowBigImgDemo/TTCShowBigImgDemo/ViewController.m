//
//  ViewController.m
//  TTCShowBigImgDemo
//
//  Created by 赵婷 on 2018/12/17.
//  Copyright © 2018年 赵婷. All rights reserved.
//

#import "ViewController.h"
#import "TTCShowBigImgView.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *showBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.showBtn];
    _showBtn.frame = CGRectMake((SCREEN_WIDTH - 80 * WIDTH) / 2, 200 * HEIGHT, 80 * WIDTH, 40 * HEIGHT);
    [_showBtn addTarget:self action:@selector(showBigImg) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)showBigImg
{
    NSArray *imgUrlArr = @[
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606647710.jpeg",
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606643171.jpeg",
                           @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-11/201811181656686643.gif",
                           @"201811181656686643.gif",
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606642752.jpeg",
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606644453.jpeg",
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606648834.jpeg",
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606641755.jpeg",
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606646296.jpeg",
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606644797.jpeg",
                           @"http://uploads.mallguang.top/dynamic/20181206/15440606644348.jpeg",
                           
                           ];
    TTCShowBigImgView *picView = [[TTCShowBigImgView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withImgs:imgUrlArr];
    [self.view addSubview:picView];//加载到当前页面
    //    [[UIApplication sharedApplication].keyWindow addSubview:picView];//加载到window
    picView.selectInteger = 0;
    picView.eventBlock = ^(CLICKEVENTTYPE clickType){
        switch (clickType) {
            case CLICKEVENTTYPE_CLICK:
            {
                //可以执行单击图片进行的操作
            }
                break;
            case CLICKEVENTTYPE_DOUBLE:
            {
                //可以执行双击图片进行的操作
            }
                break;
                
            default:
                break;
        }
        
    };
}
- (UIButton *)showBtn
{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTitle:@"展示大图" forState:UIControlStateNormal];
        [_showBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _showBtn;
}
@end
