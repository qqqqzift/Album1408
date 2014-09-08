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

@synthesize sOrientation;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{;
    [super viewDidLoad];
//    self.wantsFullScreenLayout = YES;
    self.navigationItem.title = @"アルバム";
	self.view.backgroundColor = [UIColor blackColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.hidesBackButton = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    UIBarButtonItem *seteiButton;
    
    if(_islastpageList == YES){
        seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(backTolistAction:)];
    }else{
         seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"縮略図" style:UIBarButtonItemStyleDone target:self action:@selector(backToLAction:)];
    }
    self.navigationItem.rightBarButtonItem = seteiButton;
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[(PhotoEntity *)[_photos objectAtIndex:0] egoImage].image];
    
    oldFrameV = CGRectMake(0, 0, kScreenWidth,   imageView.image.size.height*(kScreenWidth/imageView.image.size.width));
    largeFrameV = CGRectMake(kScreenWidth/2, kScreenHeight/2, 3 * oldFrameV.size.width, 3 * oldFrameV.size.height);
    
    oldFrameH = CGRectMake(0, 0, imageView.image.size.width*(kScreenWidth/imageView.image.size.height),kScreenWidth);
    largeFrameH = CGRectMake( kScreenHeight/2, kScreenWidth/2, 3 * oldFrameV.size.height, 3 * oldFrameV.size.width);

    
	
    
    
	scrollView = [[UIScrollView alloc] initWithFrame:oldFrameV];
    scrollView.contentMode = UIViewContentModeCenter;
    

    [scrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(scrollView.frame),  CGRectGetHeight(scrollView.frame))];

    
    
    scrollView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
	//setupPage为本例中定义的实现图片显示的私有方法
	[self setupPage];
    //pageControl.hidden = YES;
    //_ishidebar = NO;
    
//    vView = [[UIView alloc]initWithFrame: CGRectMake(0, 0,kScreenWidth , kScreenHeight)];
//    [self.view addSubview:vView];
    [self.view addSubview:scrollView];
    
    
}

- (void)viewDidAppear:(BOOL)animated{

//[[self navigationController] setNavigationBarHidden:NO animated:YES];

}
#pragma willAnimateRotationToInterfaceOrientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"UIInterfaceOrientationPortraitUpsideDown or UIInterfaceOrientationPortrait");
            scrollView.frame = oldFrameV;
            [scrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(scrollView.frame),  CGRectGetHeight(scrollView.frame))];
             scrollView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
            sOrientation = kLandScapeTop;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"UIInterfaceOrientationLandscapeRight or UIInterfaceOrientationLandscapeLeft");
            scrollView.frame = oldFrameH;
            [scrollView setContentSize:CGSizeMake([[self photos] count]*kScreenWidth,  CGRectGetHeight(scrollView.frame))];
            scrollView.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
            
            sOrientation = kLandScapeRight;
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
    
//    [albumView SetPhotos:photos];
    albumView.photos = _photos;
    [self.navigationController pushViewController: albumView animated:NO];
    
}

-(void)backToLAction:(id)sender
{
    ListPhotoLViewController *albumView = [[ListPhotoLViewController alloc]init];
    
//    [albumView SetPhotos:photos];
    albumView.photos = _photos;
    albumView.sOrientation = sOrientation;
    [self.navigationController pushViewController: albumView animated:NO];
    
    
}

//-(void) SetPhotos:(NSMutableArray*)photolist{
//    _photos = [[NSMutableArray alloc] initWithArray:photolist];
//}


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
	[scrollView setBackgroundColor:[UIColor whiteColor]];
	[scrollView setCanCancelContentTouches:NO];
	//设置滚动条类型
//	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//	scrollView.clipsToBounds = YES;
//	scrollView.scrollEnabled = YES;
	//只有pagingEnabled为YES时才可进行画面切换
	scrollView.pagingEnabled = YES;
//	scrollView.directionalLockEnabled =NO;
	//隐藏滚动条设置
//	scrollView.alwaysBounceVertical=NO;
//	scrollView.alwaysBounceHorizontal =NO;
//	scrollView.showsVerticalScrollIndicator= NO;
//	scrollView.showsHorizontalScrollIndicator= NO;

	//循环导入数值中的图片
	for (int i = 0; i < [_photos count];i++) {
		//初始化图片的UIImageView实例
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[imageView setImage:[(PhotoEntity *)[_photos objectAtIndex:(i)] egoImage].image];
        //设置背景
		[imageView setBackgroundColor:[UIColor blackColor]];
		
        
		//设置各UIImageView实例位置，及UIImageView实例的frame属性值
        imageView.frame = CGRectMake( scrollView.frame.size.width * i, 0, scrollView.frame.size.width, scrollView.frame.size.height -scrollView.contentOffset.y);
		//将图片内容的显示模式设置为自适应模式
		imageView.contentMode = UIViewContentModeRedraw;
        
		//[imageView setCenter:CGPointMake(scrollView.frame.size.width / 2, scrollView.frame.size.height / 2)];
		[scrollView addSubview:imageView];
		
	}
	//注册UIPageControl实例的响应方法（事件为UIControlEventValueChanged）
	//[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	//设置总页数
	//pageControl.numberOfPages = nimages;
	//默认当前页为第_currentImageId页
	//pageControl.currentPage =_currentImageId;
	//pageControl.tag=0;
	//重置UIScrollView的尺寸
	
    
	CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width *( _currentImageId-1);
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
//    pageControl.currentPage = page;
//}
//滚动完成时调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
//    pageControlIsChangingPage = NO;
}

//UIPageControl实例的响应方法（事件为UIControlEventValueChanged）
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
