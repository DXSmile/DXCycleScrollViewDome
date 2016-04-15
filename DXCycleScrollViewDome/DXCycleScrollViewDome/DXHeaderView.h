//
//  DXHeaderView.h
//  UIImageViewTest
//
//  Created by DXSmile on 14-10-11.
//  Copyright (c) 2014年 DXSmile. All rights reserved.
//
//  循环滚动的scorllView

#import <UIKit/UIKit.h>


typedef enum : NSUInteger
{
    DXHeaderViewPageControlLeft = 0,
    DXHeaderViewPageControlCenter,
    DXHeaderViewPageControlRight,
} YRPageControlLocation;


@class DXHeaderView;
@protocol DXHeaderViewDelegate <NSObject>

-(void)headerView:(DXHeaderView *)DXHeaderView didSelectedAtIndex:(NSInteger)index;

@end



@interface DXHeaderView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    __weak NSTimer *_timer;
    NSInteger _fagNum;
    
    
    BOOL _isCircularly;   //循环滚动
}

@property (nonatomic, unsafe_unretained)id<DXHeaderViewDelegate>delegate;
//图片数组（字符串形式）
@property (nonatomic, strong) NSMutableArray *images;
//pageController的位置
@property (nonatomic, assign) YRPageControlLocation pageControlLocation;
//自动滚动
@property (nonatomic, unsafe_unretained) BOOL autoRolling;

- (id)initWithFrame:(CGRect)frame isCircularly:(BOOL)isCircularly;
@end
