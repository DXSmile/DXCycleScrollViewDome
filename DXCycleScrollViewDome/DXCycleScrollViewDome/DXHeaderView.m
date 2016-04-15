//
//  DXHeaderView.m
//  UIImageViewTest
//
//  Created by DXSmile on 14-10-11.
//  Copyright (c) 2014年 DXSmile. All rights reserved.
//


#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#import "DXHeaderView.h"
#import "UIImageView+WebCache.h"



@implementation DXHeaderView

- (id)initWithFrame:(CGRect)frame isCircularly:(BOOL)isCircularly;
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //是否循环滚动
        _isCircularly = isCircularly;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startTimer:) name:@"beginTimer" object:nil];
    }
    return self;
}

- (void)setImages:(NSMutableArray *)images
{
    if (!_images)
    {
        _images = [[NSMutableArray alloc] initWithArray:images];
    }else
    {
        [_images removeAllObjects];
        [_images addObjectsFromArray:images];
    }
    
    if (_images.count>0)
    {
        [self initviews];
    }
}

//加载视图
- (void)initviews
{
    _fagNum = 0;
    if (_isCircularly)   // ===>> 这里就将3张图片变成了5张
    {
        // 把最后一张图片插入第一页   
        [_images insertObject:_images[_images.count-1] atIndex:0];
        // 把第二张图片加到最后
        [_images addObject:_images[1]];
    }
    
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
        _scrollView.contentSize = CGSizeMake(self.images.count * self.frame.size.width, self.frame.size.height);
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView flashScrollIndicators];
        
        [self addImagesViewForScrollView:_images];
        
        if (_isCircularly)
        {
            _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        }
        [self addSubview:_scrollView];
        
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width*(1-(_images.count-2)*0.03), self.frame.size.height * 0.9, 0, 0)];
        _pageControl.numberOfPages = self.images.count;
        if (_isCircularly) {
            _pageControl.numberOfPages = self.images.count-2;
        }
        _pageControl.currentPage   = 0;
        
        [self addSubview:_pageControl];
    }
    else
    {
        [self removeAllSubView];
        
        _scrollView.contentSize = CGSizeMake(self.images.count * self.frame.size.width, self.frame.size.height);
        [self addImagesViewForScrollView:_images];
        
        if (_isCircularly)
        {
            _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        }
        
        _pageControl.frame = CGRectMake(self.frame.size.width*(1-(_images.count-2)*0.03), self.frame.size.height * 0.9, 0, 0);
        _pageControl.numberOfPages = self.images.count;
        if (_isCircularly) {
            _pageControl.numberOfPages = self.images.count-2;
        }
        _pageControl.currentPage   = 0;
        [self setPageControlLocation:_pageControlLocation];
    }
   
}

- (void)setPageControlLocation:(YRPageControlLocation)pageControlLocation
{
    _pageControlLocation = pageControlLocation;
    if (pageControlLocation == DXHeaderViewPageControlLeft)
    {
        _pageControl.frame = CGRectMake(0, self.frame.size.height * 0.9, 0, 0);
    }
    else if (pageControlLocation == DXHeaderViewPageControlCenter)
    {
        _pageControl.center = CGPointMake(kScreenWidth/2, self.frame.size.height*0.9);
    }
    else if (pageControlLocation == DXHeaderViewPageControlRight)
    {
        _pageControl.frame = CGRectMake(self.frame.size.width*(1-(_images.count-2)*0.03), self.frame.size.height * 0.9, 0, 0);
    }else{}
}

- (void)addImagesViewForScrollView:(NSArray *)array
{
    float x = 0;
    for (int i = 0 ; i < array.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, self.frame.size.width, self.frame.size.height)];
        if ([array[i] hasPrefix:@"http://"])
        {
            //[imageView setImageWithURL:[NSURL URLWithString:array[i]]];
             [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:array[i]];
        }
        imageView.tag = i +99;
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewSelectAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
        
        x += kScreenWidth;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginTimer" object:nil];
}

-(void)startTimer:(id)obj
{
//    timeInterval = self.timeInterval;
    if (_timer || !_isCircularly) return;
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(pageCountUpdata:) userInfo:nil repeats:YES];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(pageCountUpdata:) userInfo:nil repeats:YES];
}


#pragma mark --UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageNum = scrollView.contentOffset.x / kScreenWidth;
    if (_isCircularly)
    {
        if (pageNum <= 1)
        {
            _pageControl.currentPage = 0;
        }
        else if(pageNum >= _images.count-2)
        {
            _pageControl.currentPage = _images.count - 3;
        }
        else
        {
            _pageControl.currentPage = pageNum - 1;
        }
    }
    else _pageControl.currentPage = pageNum;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_isCircularly)
    {
        // 获取当前的图片页面索引
        NSInteger pageNum = scrollView.contentOffset.x / kScreenWidth;
        
        if (pageNum < 1) // 如果为第0张图片,就让其悄悄变成倒数第二张
        {
            scrollView.contentOffset = CGPointMake((_images.count-2) * kScreenWidth, 0);
        }
        else if (pageNum > _images.count-2) // 如果是最后一张图片,就悄悄的变成顺数第二张
        {
            scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        }
    }
}

//滚动视图图片点击相应方法
- (void)imageViewSelectAction:(UITapGestureRecognizer*)touch
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectedAtIndex:)])
    {
        [self.delegate headerView:self didSelectedAtIndex:touch.view.tag-100];
    }
}

//NSTimer的响应方法
- (void)pageCountUpdata:(id)sender
{
    static NSInteger num = 0;
    if (num <= _images.count -2 && num != _pageControl.currentPage)
    {
        num = _pageControl.currentPage+1;
    }
    else
    {
        if (num > _images.count-2)
        {
            num = 0;
        }
        num++;
    }
    [self changeScrollView:num];
}
- (void)changeScrollView:(NSInteger)integer
{
    if (integer == _images.count -2)
    {
        [UIView animateWithDuration:0.5f animations:^{
            [_scrollView setContentOffset:CGPointMake((integer+1)*kScreenWidth, 0)];
        } completion:^(BOOL finished) {
            [self scrollViewDidEndDecelerating:_scrollView];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            [_scrollView setContentOffset:CGPointMake((integer+1)*kScreenWidth, 0)];
        }];
    }
}

- (void)setAutoRolling:(BOOL)autoRolling
{
    _autoRolling = autoRolling;
    if (!_autoRolling)
    {
        [_timer invalidate];
        _timer = nil;
    }
    else
    {
        [self startTimer:nil];
    }
}

- (void)removeAllSubView
{
    [_scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        if ([obj isKindOfClass:[UIImageView class]])
        {
            UIView *vi = (UIView *)obj;
            [vi removeFromSuperview];
        }
    }];
}


- (void)dealloc
{
    if (_images)
    {
        _images = nil;
    }
    if (_scrollView)
    {
        _scrollView = nil;
    }
    if (_pageControl)
    {
        _pageControl = nil;
    }
    [_timer invalidate];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"beginTimer" object:nil];
}

@end
