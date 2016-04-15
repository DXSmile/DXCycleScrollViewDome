//
//  ViewController.m
//  DXCycleScrollViewDome
//
//  Created by xiongdexi on 16/3/27.
//  Copyright © 2016年 DXSmile. All rights reserved.
//

#import "ViewController.h"
#import "DXHeaderView.h"

@interface ViewController ()

@end

@implementation ViewController{
    DXHeaderView *bannersView;
    
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self loadHeardView];
}


// 无限图片轮播器: 自己封装的, 超级屌  只需要实现下面的代码即可
-(void)loadHeardView{
    
    // 使用自己封装的类
    bannersView = [[DXHeaderView alloc] initWithFrame:(CGRect){0,0,self.view.frame.size.width,250} isCircularly:YES];
    bannersView.images = [NSMutableArray arrayWithArray:@[@"cai1.jpg",@"cai2.jpg",@"cai3.jpg",@"cai3.jpg",@"cai3.jpg"]];
    bannersView.pageControlLocation = DXHeaderViewPageControlCenter;
    self.tableView.tableHeaderView=bannersView;
}



@end
