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
@implementation TranslucentToolbar

- (void)drawRect:(CGRect)rect {
    // do nothing
}

- (id)initWithFrame:(CGRect)aRect {
    if ((self = [super initWithFrame:aRect])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}
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
    self.wantsFullScreenLayout = YES;
    self.navigationItem.title = @"アルバム";
	self.view.backgroundColor = [UIColor blackColor];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.hidesBackButton = YES;
    
    [UIApplication sharedApplication].statusBarHidden = YES;
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
    photolist = [[NSMutableArray alloc]initWithCapacity:[[self photos] count] ];
    
	
    
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 344, 320, 36)];
	mainscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0,kScreenWidth, kScreenHeight )];
    mainscrollView.contentMode = UIViewContentModeCenter;
    

    [mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(mainscrollView.frame),  CGRectGetHeight(mainscrollView.frame))];

    
    
    mainscrollView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
	//setupPage为本例中定义的实现图片显示的私有方法
	[self setupPage];
//    pageControl.hidden = YES;
    //_ishidebar = NO;
    
//    vView = [[UIView alloc]initWithFrame: CGRectMake(0, 0,kScreenWidth , kScreenHeight)];
//    [self.view addSubview:vView];
//    [self.view addSubview:scrollView];
    
    
    
    scrollTools = [[TranslucentToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - kToolbarHeight, kScreenWidth,kToolbarHeight)];
    playbtn = [[UIBarButtonItem alloc]
               initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(playbtnClick:)];
    
    
    NSArray *scrollToolBarItems = [[NSArray alloc]initWithObjects:playbtn, nil];
    
    
    
    [scrollTools setItems:scrollToolBarItems animated:YES];
    [self.navigationController.view addSubview:scrollTools];
    [self setToolbarItems:[NSArray arrayWithObjects:playbtn, nil]];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    if((sOrientation == kLandScapeRight)||
       (sOrientation == kLandScapeLeft)){
        [self rolltoLandscape];
    }
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{

//[[self navigationController] setNavigationBarHidden:NO animated:YES];

}

-(void)rolltoPotrait{
    NSLog(@"UIInterfaceOrientationPortraitUpsideDown or UIInterfaceOrientationPortrait");
    mainscrollView.frame = CGRectMake( 0, 0,kScreenWidth, kScreenHeight );
    [mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(mainscrollView.frame),  CGRectGetHeight(mainscrollView.frame))];
    mainscrollView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
    sOrientation = kLandScapeTop;
    pageControlIsChangingPage = NO;
    
    [self resetImageFrame];
}

-(void)rolltoLandscape{
    NSLog(@"UIInterfaceOrientationLandscapeRight or UIInterfaceOrientationLandscapeLeft");
    mainscrollView.frame = CGRectMake( 0, 0, kScreenHeight,kScreenWidth );
    [mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(mainscrollView.frame),  CGRectGetHeight(mainscrollView.frame))];
    mainscrollView.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
    
    sOrientation = kLandScapeRight;
    pageControlIsChangingPage = NO;
    [self resetImageFrame];


}
#pragma willAnimateRotationToInterfaceOrientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    pageControlIsChangingPage = YES;
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [self rolltoPotrait];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [self rolltoLandscape];
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
    albumView.sOrientation = sOrientation;
   
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
-(void)resetImageFrame{
    for (int i = 0; i < [self.photos count];i++) {
        
        UIScrollView *photobtn = [photolist objectAtIndex:i];
        
        //设置各UIImageView实例位置，及UIImageView实例的frame属性值
        photobtn.frame = CGRectMake( (float)mainscrollView.frame.size.width * i, 0, mainscrollView.frame.size.width, mainscrollView.frame.size.height );
        NSLog(@"(float)mainscrollView.frame.size.width * i:%f",((float)mainscrollView.frame.size.width * i));
        for (UIButton *imv in photobtn.subviews){
            if ([imv isKindOfClass:[UIButton class]]){
                
                if (sOrientation == kLandScapeTop) {
                    if (self.isZooming == NO) {
                        imv.frame = oldFrameV;
                    }
                    
                    imv.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
                }else if(sOrientation == kLandScapeRight){
                    if (self.isZooming == NO) {
                        imv.frame = oldFrameH;
                    }
                    
                    imv.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
                }
            }
        }
    }
    

    [self rollTothePage:[self currentImageId] ];
}


-(void)rollTothePage:(int)thePage{
    CGRect frame = mainscrollView.frame;
    NSLog(@"thePage:%d",thePage);
    frame.origin.x = frame.size.width *thePage;
    NSLog(@"frame.origin.x:%f",frame.origin.x);
    [mainscrollView scrollRectToVisible:frame animated:NO];
}

- (void)setupPage
{
	//设置UIScrollView实例各显示特性
	//设置委托类为自身，其中必须实现UIScrollViewDelegate协议中定义的scrollViewDidScroll:及scrollViewDidEndDecelerating:方法
	mainscrollView.delegate = self;
	[mainscrollView setBackgroundColor:[UIColor clearColor]];
	[mainscrollView setCanCancelContentTouches:NO];
    
	//设置滚动条类型
//	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//	scrollView.clipsToBounds = YES;
	mainscrollView.scrollEnabled = YES;
	//只有pagingEnabled为YES时才可进行画面切换
	mainscrollView.pagingEnabled = YES;
//	scrollView.directionalLockEnabled =NO;
	//隐藏滚动条设置
//	scrollView.alwaysBounceVertical=NO;
//	scrollView.alwaysBounceHorizontal =NO;
//	scrollView.showsVerticalScrollIndicator= NO;
//	scrollView.showsHorizontalScrollIndicator= NO;

	//循环导入数值中的图片
	for (int i = 0; i < [_photos count];i++) {
		//初始化图片的UIImageView实例
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake((float)mainscrollView.frame.size.width*i, 0, mainscrollView.frame.size.width, mainscrollView.frame.size.height)];
    
        s.backgroundColor = [UIColor whiteColor];
        s.contentSize = CGSizeMake(mainscrollView.frame.size.width, mainscrollView.frame.size.height);
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        //        s.tag = i+1;
        [s setZoomScale:1.0];
        
        
        UIButton *photobtn = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [photobtn setImage:[(PhotoEntity *)[_photos objectAtIndex:(i)] egoImage].image forState:UIControlStateNormal ];
        
        
        [photobtn addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置背景
		[photobtn setBackgroundColor:[UIColor blueColor]];
		
        
		//设置各UIImageView实例位置，及UIImageView实例的frame属性值
        photobtn.frame = oldFrameV;
        photobtn.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
		//将图片内容的显示模式设置为自适应模式
//		photobtn.contentMode = UIViewContentModeRedraw;
        
		//[imageView setCenter:CGPointMake(scrollView.frame.size.width / 2, scrollView.frame.size.height / 2)];
        
        [s addSubview:photobtn];
        [photolist addObject:s];
        [mainscrollView addSubview:s];
		
	}
	//注册UIPageControl实例的响应方法（事件为UIControlEventValueChanged）
//	[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	//设置总页数
	//pageControl.numberOfPages = nimages;
	//默认当前页为第_currentImageId页
//	pageControl.currentPage =_currentImageId;
	//pageControl.tag=0;
	//重置UIScrollView的尺寸
	
    [self.view addSubview:mainscrollView];
    self.currentImageId = self.currentImageId - 1;
    [self rollTothePage:[self currentImageId] ];
    
	
    
}



//实现UIScrollViewDelegate 中定义的方法
//滚动时调用的方法，其中判断画面滚动时机
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    if (pageControlIsChangingPage) {
        return;
    }
	/*
	 *	下一画面拖动到超过50%时，进行切换
	 */
    
    if (scrollView == mainscrollView){
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        NSLog(@"changing page to:%d",page);
        //    pageControl.currentPage = page;
        self.lastpage = self.currentImageId;
        self.currentImageId = page;
        self.isZooming = NO;
        NSLog(@"_scrollView.contentOffset.x:%f",scrollView.contentOffset.x);
        NSLog(@"_scrollView.contentSize.width:%f",scrollView.contentSize.width);
        if(self.currentImageId == self.lastpage){
            if (((page+1) == [[self photos] count] )&&(scrollView.contentOffset.x+scrollView.frame.size.width >scrollView.contentSize.width)){
                [self showNopageMessage:@"最後の画像です"];
                
                
            }
            
            if((page == 0)&&(scrollView.contentOffset.x < 0))
            {
                [self showNopageMessage:@"最初の画像です"];
                
            }
            
            
            
        }
    }
    
    
    
    
    
    
    
    
//    NSLog(@"pageControl.currentPage:%d",pageControl.currentPage);
}
//滚动完成时调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
//    翻页时重置缩放
    if (scrollView == mainscrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                }
            }
        }
    }
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

- (void)imageItemClick:(id)sender
{
	NSLog(@"BUTTON CLICKED");
    if([self ishidebar] == NO){
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [[self navigationController] setToolbarHidden:YES animated:YES];
        self.ishidebar = YES;
    }else{
        
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        [[self navigationController] setToolbarHidden:NO animated:YES];
        self.ishidebar = NO;
    }
}

- (void)playbtnClick:(id)sender
{
    if([self isPlaying] == NO){
        self.isPlaying = YES;
        [playbtn setTitle:@"Stop"];
         playTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(playPhotoAction:) userInfo:nil repeats:YES];
        
        
    }else{
        self.isPlaying = NO;
        [playbtn setTitle:@"Play"];
        [playTimer invalidate];
        
    }
}
-(void) dismissAction:(NSTimer *)timer{
    [pageMessage dismissWithClickedButtonIndex:0 animated:NO];//important
    pageMessage = nil;
    self.isShowingAlter = NO;
}
-(void)showNopageMessage:(NSString *)message{
    if (self.isShowingAlter == YES) {
        return ;
    }
    self.isShowingAlter = YES;
    pageMessage = [[UIAlertView alloc]
                          initWithTitle:@"メーセージ"
                          message:message
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:nil];
    [pageMessage show];
    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector: @selector(dismissAction:)  userInfo:nil repeats:NO];
}

-(void)playPhotoAction:(NSTimer *)timer{
    
    if (self.currentImageId < [[self photos] count]) {
        self.currentImageId++;
        [self rollTothePage:[self currentImageId]];
    }else{
        [playbtn setTitle:@"Play"];
        self.isPlaying = NO;
        [self stopPlaying];
        [self showNopageMessage:@"最後の画像です" ];
    
    }
    
}

-(void)setFullScreenAction:(NSTimer *)timer{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[self navigationController] setToolbarHidden:YES animated:YES];
    self.ishidebar = YES;
    
    
}


-(void)stopPlaying{
    [playTimer invalidate];
    playTimer = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    fullScreenTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(setFullScreenAction:) userInfo:nil repeats:NO];
    offset = mainscrollView.contentOffset.x;
    self.isZooming = NO;
    self.ishidebar = NO;
    self.isPlaying = NO;
    self.isShowingAlter = NO;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [playTimer invalidate];
    playTimer = nil;
    [fullScreenTimer invalidate];
    fullScreenTimer = nil;
}


// 扩大/縮小功能
#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        NSLog(@"Zooming");
        self.isZooming = YES;
        return v;
    }
    return nil;
}






@end
