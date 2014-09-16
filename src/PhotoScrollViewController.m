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
#import "UIButton+WebCache.h"
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
//        self.clearsContextBeforeDrawing = YES;
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
        offset = -1;
//        self.lastpage = -1;
        self.ispagechanged = NO;
        saveForZooming = 1.0f;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    self.navigationItem.title = @"アルバム";
	self.view.backgroundColor = [UIColor clearColor];
    //[self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.navigationItem.hidesBackButton = YES;
    if(IsIOS7){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [UIApplication sharedApplication].statusBarHidden = YES;

    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *seteiButton;
    
    if(_islastpageList == YES){
        seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(backTolistAction:)];
    }else{
         seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"縮略図" style:UIBarButtonItemStyleDone target:self action:@selector(backToLAction:)];
    }
    self.navigationItem.rightBarButtonItem = seteiButton;
    
    
//    UIImageView *imageView = [photobtn.imageView sd_setImageWithURL:[NSURL URLWithString:[(PhotoEntity *)[_photos objectAtIndex:i] url]]
//                          placeholderImage:[UIImage imageNamed:@"Block_01_00.png"]];
    
//    oldFrameV = CGRectMake(0, 0, kScreenWidth,   imageView.image.size.height*(kScreenWidth/imageView.image.size.width));
//  
//    
//    oldFrameH = CGRectMake(0, 0, imageView.image.size.width*(kScreenWidth/imageView.image.size.height),kScreenWidth);
    
//    oldFrameV = CGRectMake(0, 0, kScreenWidth,   kScreenWidth);
//    
//    
//    oldFrameH = CGRectMake(0, 0, kScreenWidth,kScreenWidth);
    
    photolist = [[NSMutableArray alloc]initWithCapacity:[[self photos] count] ];
    
	
    
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 344, 320, 36)];
	mainscrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    mainscrollView.contentMode = UIViewContentModeCenter;
    

    [mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(mainscrollView.frame),  CGRectGetHeight(mainscrollView.frame))];

    
    
    mainscrollView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
	//setupPage为本例中定义的实现图片显示的私有方法
	[self setupPage];
    
//    pageControl.hidden = YES;
    //_ishidebar = NO;
    
//    vView = [[UIView alloc]initWithFrame: CGRectMake(0, 0,kScreenWidth , kScreenHeight)];
//    [self.view addSubview:vView];
//    [self.view addSubview:scrollView];
    
    
    
    self.scrollTools = [[TranslucentToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - kToolbarHeight, kScreenWidth,kToolbarHeight)];
    playbtn = [[UIBarButtonItem alloc]
               initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(playbtnClick:)];
    
    
    NSArray *scrollToolBarItems = [[NSArray alloc]initWithObjects:playbtn, nil];
    
    
    
    [self.scrollTools setItems:scrollToolBarItems animated:YES];
    [self.navigationController.view addSubview:self.scrollTools];
    [self setToolbarItems:[NSArray arrayWithObjects:playbtn, nil]];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    
//    CGRect frame1 = mainscrollView.frame;
//    CGRect frame2 = self.view.frame;
    
}

- (void)viewDidAppear:(BOOL)animated{

    [[self navigationController] setNavigationBarHidden:NO animated:YES];

}

-(void)rolltoPotrait{
    NSLog(@"UIInterfaceOrientationPortraitUpsideDown or UIInterfaceOrientationPortrait");
    mainscrollView.frame = CGRectMake( 0, 0,kScreenWidth, kScreenHeight );
    [mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(mainscrollView.frame),  CGRectGetHeight(mainscrollView.frame))];
    mainscrollView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
    sOrientation = kLandScapeTop;
    pageControlIsChangingPage = NO;
    
    [self resetImageFrame];
    [self rollTothePage:[self currentImageId] AnimeOrNot:NO ];
}

-(void)rolltoLandscape{
    NSLog(@"UIInterfaceOrientationLandscapeRight or UIInterfaceOrientationLandscapeLeft");
    mainscrollView.frame = CGRectMake( 0, 0, kScreenHeight,kScreenWidth );
    [mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(mainscrollView.frame),  CGRectGetHeight(mainscrollView.frame))];
    mainscrollView.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
    
    sOrientation = kLandScapeRight;
    pageControlIsChangingPage = NO;
    [self resetImageFrame];
    [self rollTothePage:[self currentImageId] AnimeOrNot:NO ];


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
    if (sOrientation == kLandScapeTop) {
        albumView.elemInLine = kVLineCnt;
    }else if(sOrientation == kLandScapeRight){
        albumView.elemInLine = [MMCommon kHLineCnt];
    }
    
    [self.navigationController pushViewController: albumView animated:NO];
    
}

//-(void) SetPhotos:(NSMutableArray*)photolist{
//    _photos = [[NSMutableArray alloc] initWithArray:photolist];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning in PhotoScrollViewController");
//    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
//    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
    CGFloat pContentWidth,pContentHeight;
    for (int i = 0; i < [self.photos count];i++) {
         UIScrollView *photoscroll = [photolist objectAtIndex:i];
        
       
        saveForZooming =  photoscroll.zoomScale;
       
        pContentWidth = mainscrollView.frame.size.width;
        pContentHeight = mainscrollView.frame.size.height;
        //根据当前屏幕方向重置scrollview里面的button的中心点和大小
        for (UIButton *photobtn in photoscroll.subviews){
            
            if ([photobtn isKindOfClass:[UIButton class]]){
                //没有缩放时
                if (saveForZooming - 1.0f < kEPS){
                    if (sOrientation == kLandScapeTop) {
                        photobtn.frame = CGRectMake(0, 0, kScreenWidth,   photobtn.imageView.image.size.height*(kScreenWidth/photobtn.imageView.image.size.width));
                        photobtn.center = CGPointMake( kScreenWidth/2,kScreenHeight/2);
                    }else if(sOrientation == kLandScapeRight){
                        photobtn.frame = CGRectMake(0, 0, photobtn.imageView.image.size.width*(kScreenWidth/photobtn.imageView.image.size.height),kScreenWidth);;
                        photobtn.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
                    }
                }
                else{
                    //有缩放时
                    [photoscroll setZoomScale:1.0 ];
                    if (sOrientation == kLandScapeTop) {
                        photobtn.frame = CGRectMake(0, 0, kScreenWidth,   photobtn.imageView.image.size.height*(kScreenWidth/photobtn.imageView.image.size.width));
                        photobtn.center = CGPointMake( kScreenWidth/2,kScreenHeight/2);
                        saveForZooming = saveForZooming*kScreenHeight/kScreenWidth;
                    }else if(sOrientation == kLandScapeRight){
                        photobtn.frame = CGRectMake(0, 0, photobtn.imageView.image.size.width*(kScreenWidth/photobtn.imageView.image.size.height),kScreenWidth);;;
                        photobtn.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
                        saveForZooming = saveForZooming*kScreenWidth/kScreenHeight;
                    }
                    [photoscroll setZoomScale:saveForZooming];
//                    imv.center = CGPointMake(imv.frame.size.width/2, imv.frame.size.height/2);
                    pContentWidth = photobtn.frame.size.width;
                    pContentHeight = photobtn.frame.size.height;
                }
                
               
            }
        }
        
        //重置scrollview的frame
        //设置各UIImageView实例位置，及UIImageView实例的frame属性值
        photoscroll.frame = CGRectMake( (float)mainscrollView.frame.size.width * i, 0, mainscrollView.frame.size.width, mainscrollView.frame.size.height );
        //        NSLog(@"(float)mainscrollView.frame.size.width * i:%f",((float)mainscrollView.frame.size.width * i));
        
        if (saveForZooming - 1.0f < kEPS) {
            photoscroll.contentSize = CGSizeMake(mainscrollView.frame.size.width, mainscrollView.frame.size.height);
        }else{
            photoscroll.contentSize = CGSizeMake(pContentWidth, pContentHeight);
        }
        
        
        
    }
    

//    [self rollTothePage:[self currentImageId] ];
}


-(void)rollTothePage:(int)thePage AnimeOrNot:(BOOL)withAnime{
    CGRect frame = mainscrollView.frame;
//    NSLog(@"thePage:%d",thePage);
    frame.origin.x = frame.size.width *thePage;
//    NSLog(@"frame.origin.x:%f",frame.origin.x);
    [mainscrollView scrollRectToVisible:frame animated:withAnime];
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
	mainscrollView.clipsToBounds = YES;
	mainscrollView.scrollEnabled = YES;
	//只有pagingEnabled为YES时才可进行画面切换
	mainscrollView.pagingEnabled = YES;
//	scrollView.directionalLockEnabled =NO;
	//隐藏滚动条设置
//	mainscrollView.alwaysBounceVertical=YES;
//	mainscrollView.alwaysBounceHorizontal =NO;
	mainscrollView.showsVerticalScrollIndicator= NO;
	mainscrollView.showsHorizontalScrollIndicator= NO;

	//循环导入数值中的图片
	for (int i = 0; i < [_photos count];i++) {
		//初始化图片的UIImageView实例
        
        UIScrollView *photoscroll = [[UIScrollView alloc] initWithFrame:CGRectMake((float)mainscrollView.frame.size.width*i, 0, mainscrollView.frame.size.width, mainscrollView.frame.size.height)];
    
        photoscroll.backgroundColor = [UIColor whiteColor];
        photoscroll.contentSize = CGSizeMake(mainscrollView.frame.size.width, mainscrollView.frame.size.height);
        
        photoscroll.delegate = self;
        
        photoscroll.minimumZoomScale = 1.0;
        
        photoscroll.maximumZoomScale = 1.0;
        
        photoscroll.showsVerticalScrollIndicator= NO;
        
        photoscroll.showsHorizontalScrollIndicator= NO;
        
        //        photoscroll.clipsToBounds = YES;
        
        //        photoscroll.tag = i+1;
        
        [photoscroll setZoomScale:1.0];
        
        
        
        
        UIButton *photobtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [photoscroll addSubview:photobtn];
        [photolist addObject:photoscroll];
        
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:[(PhotoEntity *)[_photos objectAtIndex:i] url]]
//                              options:0
//                             progress:^(NSInteger receivedSize, NSInteger expectedSize)
//         {
//             // progression tracking code
//         }
//                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
//         {
//             if (image)
//             {
//                 // do something with image
//                 [photobtn.imageView setImage:image];
//                 if (sOrientation == kLandScapeTop) {
//                     photobtn.frame = CGRectMake(0, 0, kScreenWidth,   photobtn.imageView.image.size.height*(kScreenWidth/photobtn.imageView.image.size.width));
//                     photobtn.center = CGPointMake( kScreenWidth/2,kScreenHeight/2);
//                 }else if(sOrientation == kLandScapeRight){
//                     photobtn.frame = CGRectMake(0, 0, photobtn.imageView.image.size.width*(kScreenWidth/photobtn.imageView.image.size.height),kScreenWidth);;
//                     photobtn.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
//                 }
//                 photoscroll.maximumZoomScale = 3.0;
//                 photoscroll.minimumZoomScale = 1.0;
//                 ((PhotoEntity *)[self.photos objectAtIndex:i]).isLoaded =  YES;
//             }
//         }];

        
        
        [photobtn sd_setImageWithURL:[NSURL URLWithString:[(PhotoEntity *)[_photos objectAtIndex:i] url]]
                            forState:UIControlStateNormal
                    placeholderImage:[UIImage imageNamed:@"Block_01_00.png"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               //... completion code here ...
                               
                               
                               if (sOrientation == kLandScapeTop) {
                                   photobtn.frame = CGRectMake(0, 0, kScreenWidth,   photobtn.imageView.image.size.height*(kScreenWidth/photobtn.imageView.image.size.width));
                                   photobtn.center = CGPointMake( kScreenWidth/2,kScreenHeight/2);
                               }else if(sOrientation == kLandScapeRight){
                                   photobtn.frame = CGRectMake(0, 0, photobtn.imageView.image.size.width*(kScreenWidth/photobtn.imageView.image.size.height),kScreenWidth);;
                                   photobtn.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
                               }
                               photoscroll.maximumZoomScale = 3.0;
                               photoscroll.minimumZoomScale = 1.0;
                               ((PhotoEntity *)[self.photos objectAtIndex:i]).isLoaded =  YES;
                               
                               
                           }];

        
        [photobtn setAdjustsImageWhenHighlighted:NO];
        [photobtn addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置背景
		[photobtn setBackgroundColor:[UIColor blackColor]];
		
        
		//设置各UIImageView实例位置，及UIImageView实例的frame属性值
        photobtn.frame = CGRectMake(0, 0, kScreenWidth,   photobtn.imageView.image.size.height*(kScreenWidth/photobtn.imageView.image.size.width));;
        photobtn.center = CGPointMake(CGRectGetWidth(photoscroll.frame)/2,CGRectGetHeight(photoscroll.frame)/2);
		//将图片内容的显示模式设置为自适应模式
//		photobtn.contentMode = UIViewContentModeRedraw;
        
		//[imageView setCenter:CGPointMake(scrollView.frame.size.width / 2, scrollView.frame.size.height / 2)];
        
        
        [mainscrollView addSubview:photoscroll];
		
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
    [self rollTothePage:[self currentImageId] AnimeOrNot:NO ];
    
	
    
}








- (void)imageItemClick:(id)sender
{
	NSLog(@"BUTTON CLICKED");
//    if ( ((PhotoEntity *)[self.photos objectAtIndex:self.currentImageId]).isLoaded == YES) {
//        [self updateZoomStatus];
//    }
//    
    
    if (self.isPlaying == NO) {
        if([self ishidebar] == NO){
            [self setFullScreen];
        }else{
            
            [self setShowNavibar];
        }
    }else{
        self.isPlaying = NO;
        [playbtn setTitle:@"Play"];
        [playTimer invalidate];
        if([self ishidebar] == NO){
            [self setFullScreen];
        }else{
            
            [self setShowNavibar];
        }
    }
    
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    bool a = navBar.isTranslucent;
}

- (void)playbtnClick:(id)sender
{
    [self stopAutoFullScreen];
    if([self isPlaying] == NO){
        self.isPlaying = YES;
        [playbtn setTitle:@"Stop"];
         playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playPhotoAction:) userInfo:nil repeats:YES];
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [[self navigationController] setToolbarHidden:YES animated:YES];
        self.ishidebar = YES;
        
    }else{
        self.isPlaying = NO;
        [playbtn setTitle:@"Play"];
        [playTimer invalidate];
        
    }
}
//-(void) dismissAction:(NSTimer *)timer{
//    [pageMessage dismissWithClickedButtonIndex:0 animated:NO];//important
//    pageMessage = nil;
//    self.isShowingAlter = NO;
//}
-(void)showNopageMessage:(NSString *)message{
    if (self.isShowingAlter == YES) {
        return ;
    }
    self.isShowingAlter = YES;
    pageMessage = [[UIAlertView alloc]
                          initWithTitle:@"メーセージ"
                          message:message
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [pageMessage show];
//    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector: @selector(dismissAction:)  userInfo:nil repeats:NO];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        self.isShowingAlter = NO;
    }
}
-(void)playPhotoAction:(NSTimer *)timer{
    
    if (self.currentImageId < [[self photos] count]) {
        self.currentImageId++;
        [self rollTothePage:[self currentImageId] AnimeOrNot:YES];
    }else{
        [playbtn setTitle:@"Play"];
        self.isPlaying = NO;
        [self stopPlaying];
        [self showNopageMessage:@"最後の画像です" ];
    
    }
    
}

-(void)setFullScreenAction:(NSTimer *)timer{
    [self setFullScreen];
    
    
}

-(void)setFullScreen{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[self navigationController] setToolbarHidden:YES animated:YES];
    
    
    
    self.ishidebar = YES;
}

-(void)setShowNavibar{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self navigationController] setToolbarHidden:NO animated:YES];
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    [navBar setTranslucent:YES];
    
//    self.wantsFullScreenLayout = YES;
    self.ishidebar = NO;

}

-(void)stopPlaying{
    [playTimer invalidate];
    playTimer = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    fullScreenTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(setFullScreenAction:) userInfo:nil repeats:NO];
    
//    self.isZooming = NO;
    self.ishidebar = NO;
    self.isPlaying = NO;
    self.isShowingAlter = NO;
    //mainscrollView.contentOffset = CGPointMake(0, 0);
    if((sOrientation == kLandScapeRight)||
       (sOrientation == kLandScapeLeft)){
        [self rolltoLandscape];
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [playTimer invalidate];
    playTimer = nil;
    [self stopAutoFullScreen];
    [[self navigationController] setToolbarItems:nil];

    
    [self.scrollTools removeFromSuperview];
    self.scrollTools = nil;
    
}



-(void)stopAutoFullScreen{
    if(fullScreenTimer != nil){
        [fullScreenTimer invalidate];
        fullScreenTimer = nil;
    }
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    [self setFullScreen];
//}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    
//
//}
//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
    if (self.willshowStartAlter == YES) {
        [self showNopageMessage:@"最初の画像です"];
        self.willshowStartAlter = NO;
    }else if(self.willshowEndAlter == YES){
        [self showNopageMessage:@"最後の画像です"];
        self.willshowEndAlter = NO;
    }
}
-(void)updateZoomStatus{



    UIScrollView *photoscroll = [photolist objectAtIndex:(self.currentImageId)];
    
    photoscroll.maximumZoomScale = 3.0;
    photoscroll.minimumZoomScale = 1.0;
    NSLog(@"update isLoaded to YES");

}


#pragma scrollMethod





//滚动完成时调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    pageControlIsChangingPage = NO;
    
    //翻页时重置缩放
    if (scrollView == mainscrollView){
        if (self.ispagechanged == YES) {
            NSLog(@"self.ispagechanged:%d",self.ispagechanged);
            NSLog(@"scrollViewDidEndDecelerating");
            NSLog(@"currentpage is :%d",self.currentImageId);
            [self rollTothePage:[self currentImageId] AnimeOrNot:YES];
            for (UIScrollView *s in scrollView.subviews){
                [s setZoomScale:1.0];
                if ([s isKindOfClass:[UIScrollView class]]){
                    if ( ((PhotoEntity *)[self.photos objectAtIndex:self.currentImageId]).isLoaded == YES) {
                        [self updateZoomStatus];
                    }else{
                        
                        NSLog(@"isLoaded == NO");
                    }
                }
                
            }
            
            self.ispagechanged = NO;
        }
    }
    
}


//实现UIScrollViewDelegate 中定义的方法
//滚动时调用的方法，其中判断画面滚动时机
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = mainscrollView.frame.size.width;
    int page = floor((mainscrollView.contentOffset.x - pageWidth*9 / 16) / pageWidth) + 1;
    if (pageControlIsChangingPage) {
        
        return;
    }
    NSLog(@"scrollViewDidScroll");
	/*
	 *	下一画面拖动到超过50%时，进行切换
	 */
    
    if (scrollView == mainscrollView){
        
               if ((page == self.currentImageId)&&
            (page != (self.photos.count-1))&&
            (page != 0)) {
           
            return ;
        }
        
        
    
        if(self.currentImageId != page){
            NSLog(@"changing page to:%d",page);

            self.currentImageId = page;
            self.ispagechanged = YES;
            
        }else{

            
        }
    }
    
    if ((page+1) == [[self photos] count] ){
        if (((scrollView.contentOffset.x+pageWidth >scrollView.contentSize.width))&&(self.willshowStartAlter == NO)) {
            self.willshowEndAlter = YES;
        }
        
        
        
    }
    
    if(page == 0)
    {
        //                CGFloat a = scrollView.contentOffset.x;
        if ((scrollView.contentOffset.x < 0)&&(self.willshowStartAlter == NO)) {
            self.willshowStartAlter = YES;
        }
    }
    
}

// 扩大/縮小功能
#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        
        
        return v;
    }
    
    return nil;
}


//-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
//   
//
//
//}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidZoom");
    CGSize boundsSize = scrollView.bounds.size;
    for(UIButton *scroolbtn in scrollView.subviews){
        
        CGRect frameToCenter = scroolbtn.frame;
        // center horizontally
        if (frameToCenter.size.width < boundsSize.width)
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
        else
            frameToCenter.origin.x = 0.0f;
        
        // center vertically
        if (frameToCenter.size.height < boundsSize.height)
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
        else
            frameToCenter.origin.y = 0.0f;
        
        scroolbtn.frame = frameToCenter;
        
    }


}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"scrollViewDidEndZooming");
   }

- (BOOL) hidesBottomBarWhenPushed {
    return YES;
}



@end
