//
//  PhotoScrollViewController.m
//  Album1408
//
//  Created by zhang_ying on 14-9-4.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//


#import "ListPhotoTableViewController.h"
#import "PhotoScrollViewController.h"
#import "ListPhotoLViewController.h"
#import "PhotoEntity.h"
#import "MMCommon.h"

@interface PhotoScrollViewController ()

@end

@implementation PhotoScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"アルバム";
	self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *seteiButton;
    
    if(_islastpageList == YES){
        seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(backTolistAction:)];
    }else{
         seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"縮略図" style:UIBarButtonItemStyleDone target:self action:@selector(backToLAction:)];
    }
    self.navigationItem.rightBarButtonItem = seteiButton;
    
    
	//初始化UIScrollView及UIPageControl实例，为了给UIPageControl控件流出显示位置，将起点坐标定为(0, 344)
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
	pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (kScreenWidth+10), kScreenWidth, 36)];
	
	//将UIScrollView及UIPageControl实例追加到画面中
	[self.view addSubview:scrollView];
	[self.view addSubview:pageControl];
	//setupPage为本例中定义的实现图片显示的私有方法
	[self setupPage];
    pageControl.hidden = YES;
    _ishidebar = NO;
    self.wantsFullScreenLayout = YES;
}


#pragma willAnimateRotationToInterfaceOrientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"UIInterfaceOrientationPortraitUpsideDown or UIInterfaceOrientationPortrait");
            scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width*[photos count], [scrollView bounds].size.height)];
//            pageControl.bounds = CGRectMake(0, (kScreenWidth+10), kScreenWidth, 36);
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            scrollView.frame = CGRectMake(0, 0, kScreenHeight,  kScreenWidth);
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width*[photos count], [scrollView bounds].size.height)];
//            pageControl.bounds = CGRectMake(0, (kScreenHeight+10), kScreenHeight, 36);
            NSLog(@"UIInterfaceOrientationLandscapeRight or UIInterfaceOrientationLandscapeLeft");
            
            break;
        default:
            NSLog(@"OrientationNotHandled");
            
            break;
            
            
    }
}

// 手指从画面离开时
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
//    if (_ishidebar == YES) {
//        NSLog(@"A");
//        [self.navigationController setNavigationBarHidden:NO];
//        _ishidebar = YES;
//    }else{
//        NSLog(@"B");
//        [self.navigationController setNavigationBarHidden:YES];
//        _ishidebar = NO;
//    }
    
}

-(void)backTolistAction:(id)sender
{
    ListPhotoTableViewController *albumView = [[ListPhotoTableViewController alloc]init];
    
    [albumView SetPhotos:photos];
    [self.navigationController pushViewController: albumView animated:NO];
    
}

-(void)backToLAction:(id)sender
{
    ListPhotoLViewController *albumView = [[ListPhotoLViewController alloc]init];
    
    [albumView SetPhotos:photos];
    [self.navigationController pushViewController: albumView animated:NO];
    
}

-(void) SetPhotos:(NSMutableArray*)photolist{
    photos = [[NSMutableArray alloc] initWithArray:photolist];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)setupPage
{
	//设置UIScrollView实例各显示特性
	//设置委托类为自身，其中必须实现UIScrollViewDelegate协议中定义的scrollViewDidScroll:及scrollViewDidEndDecelerating:方法
	scrollView.delegate = self;
	[scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	//设置滚动条类型
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	//只有pagingEnabled为YES时才可进行画面切换
	scrollView.pagingEnabled = YES;
	scrollView.directionalLockEnabled =NO;
	//隐藏滚动条设置
	scrollView.alwaysBounceVertical=NO;
	scrollView.alwaysBounceHorizontal =NO;
	scrollView.showsVerticalScrollIndicator=NO;
	scrollView.showsHorizontalScrollIndicator=NO;
    
	NSUInteger nimages = 0;
	CGFloat cx = 0;
	//循环导入数值中的图片
	for (int i = 0; i < [photos count];i++) {
		UIImageView *imageView = [[UIImageView alloc]initWithImage:[(PhotoEntity *)[photos objectAtIndex:(i)] egoImage].image];
		//设置背景
		[imageView setBackgroundColor:[UIColor blackColor]];
        
		//导入图片
		//设置各UIImageView实例位置，及UIImageView实例的frame属性值
		CGRect rect = scrollView.frame;
		rect.size.height = scrollView.frame.size.height;
		rect.size.width = scrollView.frame.size.width;
		rect.origin.x = cx;
		rect.origin.y = 0;
		[(PhotoEntity *)[photos objectAtIndex:(i)] egoImage].frame = rect;
		//将图片内容的显示模式设置为自适应模式
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[scrollView addSubview:imageView];
		//移动左边准备导入下一图片
		cx += scrollView.frame.size.width;
		nimages++;
	}
//	//注册UIPageControl实例的响应方法（事件为UIControlEventValueChanged）
//	[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
//	//设置总页数
//	pageControl.numberOfPages = nimages;
//	//默认当前页为第1页
//	pageControl.currentPage =_currentImageId;
//	pageControl.tag=_currentImageId;
    
	//重置UIScrollView的尺寸
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * (_currentImageId-1);
    [scrollView scrollRectToVisible:frame animated:YES];
}

//实现UIScrollViewDelegate 中定义的方法
//滚动时调用的方法，其中判断画面滚动时机
//- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
//{
//    if (pageControlIsChangingPage) {
//        return;
//    }
//	/*
//	 *	下一画面拖动到超过50%时，进行切换
//	 */
//    CGFloat pageWidth = _scrollView.frame.size.width;
//    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
////    pageControl.currentPage = page;
//}
////滚动完成时调用的方法
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
//{
//    pageControlIsChangingPage = NO;
//}

////UIPageControl实例的响应方法（事件为UIControlEventValueChanged）
//- (void)changePage:(id)sender
//{
//	/*
//	 *	改变页面
//	 */
//    CGRect frame = scrollView.frame;
//    frame.origin.x = frame.size.width * pageControl.currentPage;
//    frame.origin.y = 0;
//	
//    [scrollView scrollRectToVisible:frame animated:YES];
//	
//	/*
//	 *	设置滚动标志，滚动（或称页面改变）完成时，会调用scrollViewDidEndDecelerating 方法，其中会将其置为off的
//	 */
//    pageControlIsChangingPage = YES;
//}

@end
