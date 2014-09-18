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
#import "UIImageView+WebCache.h"
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
//        offset = -1;
//        self.lastpage = -1;
        self.ispagechanged = NO;
        self.saveForZooming = 1.0f;
        self.isZooming = NO;
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
    
    

    
    self.photolist = [[NSMutableArray alloc]initWithCapacity:[[self photos] count] ];
    
	
    

	self.mainscrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];

    [self.mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(self.mainscrollView.frame),  CGRectGetHeight(self.mainscrollView.frame))];

    
    
    self.mainscrollView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
	//setupPage为本例中定义的实现图片显示的私有方法
	[self setupPage];
    

    
    
    
    self.scrollTools = [[TranslucentToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - kToolbarHeight, kScreenWidth,kToolbarHeight)];
    self.playbtn = [[UIBarButtonItem alloc]
               initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(playbtnClick:)];
    
    
    
    
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                     
                                                                                  target: nil
                                     
                                                                                  action: nil];
    NSArray *scrollToolBarItems = [[NSArray alloc]initWithObjects:fixedButton,self.playbtn, fixedButton,nil];
    [self.scrollTools setItems:scrollToolBarItems animated:YES];
    [self.navigationController.view addSubview:self.scrollTools];
    [self setToolbarItems:scrollToolBarItems];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    self.taprecognizer = [[UITapGestureRecognizer alloc]init];
    
    
}

- (void)viewDidAppear:(BOOL)animated{

    [[self navigationController] setNavigationBarHidden:NO animated:YES];

}

-(void)rolltoPotrait{
    NSLog(@"UIInterfaceOrientationPortraitUpsideDown or UIInterfaceOrientationPortrait");
    self.mainscrollView.frame = CGRectMake( 0, 0,kScreenWidth, kScreenHeight );
    [self.mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(self.mainscrollView.frame),  CGRectGetHeight(self.mainscrollView.frame))];
    self.mainscrollView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
    sOrientation = kLandScapeTop;
    self.pageControlIsChangingPage = NO;
    
    [self resetImageFrame];
    [self rollTothePage:[self currentImageId] AnimeOrNot:NO ];
}

-(void)rolltoLandscape{
    NSLog(@"UIInterfaceOrientationLandscapeRight or UIInterfaceOrientationLandscapeLeft");
    self.mainscrollView.frame = CGRectMake( 0, 0, kScreenHeight,kScreenWidth );
    [self.mainscrollView setContentSize:CGSizeMake([[self photos] count]*CGRectGetWidth(self.mainscrollView.frame),  CGRectGetHeight(self.mainscrollView.frame))];
    self.mainscrollView.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
    
    sOrientation = kLandScapeRight;
    self.pageControlIsChangingPage = NO;
    [self resetImageFrame];
    [self rollTothePage:[self currentImageId] AnimeOrNot:NO ];


}
#pragma willAnimateRotationToInterfaceOrientation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    self.pageControlIsChangingPage = YES;
    NSLog(@"willAnimateRotationToInterfaceOrientation");
//    if(self.isPlaying == YES){
//        [self pausePlaying];
//    }
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
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
//    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
//    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


-(void)dealloc{
    NSLog(@"PhotoScrollViewController dealloc");

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
         UIScrollView *photoscroll = [self.photolist objectAtIndex:i];
        
       
        self.saveForZooming =  photoscroll.zoomScale;
       
        pContentWidth = self.mainscrollView.frame.size.width;
        pContentHeight = self.mainscrollView.frame.size.height;
        //根据当前屏幕方向重置scrollview里面的button的中心点和大小
        for (UIButton *photobtn in photoscroll.subviews){
            
            if ([photobtn isKindOfClass:[UIButton class]]){
                //没有缩放时
                if (self.saveForZooming - 1.0f < kEPS){
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
                        self.saveForZooming = self.saveForZooming*kScreenHeight/kScreenWidth;
                    }else if(sOrientation == kLandScapeRight){
                        photobtn.frame = CGRectMake(0, 0, photobtn.imageView.image.size.width*(kScreenWidth/photobtn.imageView.image.size.height),kScreenWidth);;;
                        photobtn.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
                        self.saveForZooming = self.saveForZooming*kScreenWidth/kScreenHeight;
                    }
                    [photoscroll setZoomScale:self.saveForZooming];
//                    imv.center = CGPointMake(imv.frame.size.width/2, imv.frame.size.height/2);
                    pContentWidth = photobtn.frame.size.width;
                    pContentHeight = photobtn.frame.size.height;
                }
                
               
            }
        }
        
        //重置scrollview的frame
        //设置各UIImageView实例位置，及UIImageView实例的frame属性值
        photoscroll.frame = CGRectMake( (float)self.mainscrollView.frame.size.width * i, 0, self.mainscrollView.frame.size.width, self.mainscrollView.frame.size.height );
        //        NSLog(@"(float)mainscrollView.frame.size.width * i:%f",((float)mainscrollView.frame.size.width * i));
        
        if (self.saveForZooming - 1.0f < kEPS) {
            photoscroll.contentSize = CGSizeMake(self.mainscrollView.frame.size.width, self.mainscrollView.frame.size.height);
        }else{
            photoscroll.contentSize = CGSizeMake(pContentWidth, pContentHeight);
        }
        
        
        
    }
    

//    [self rollTothePage:[self currentImageId] ];
}


-(void)rollTothePage:(int)thePage AnimeOrNot:(BOOL)withAnime{
    CGRect frame = self.mainscrollView.frame;
//    NSLog(@"thePage:%d",thePage);
    frame.origin.x = frame.size.width *thePage;
//    NSLog(@"frame.origin.x:%f",frame.origin.x);
    [self.mainscrollView scrollRectToVisible:frame animated:withAnime];
    
}

// 添加手势
- (void) addGestureRecognizerToView:(UIView *)view
{

}

- (void)setupPage
{
	//设置UIScrollView实例各显示特性
	//设置委托类为自身，其中必须实现UIScrollViewDelegate协议中定义的scrollViewDidScroll:及scrollViewDidEndDecelerating:方法
	self.mainscrollView.delegate = self;
	[self.mainscrollView setBackgroundColor:[UIColor clearColor]];
	[self.mainscrollView setCanCancelContentTouches:NO];
    self.mainscrollView.decelerationRate = 0.1;
	//设置滚动条类型
//	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	self.mainscrollView.clipsToBounds = YES;
	self.mainscrollView.scrollEnabled = YES;
	//只有pagingEnabled为YES时才可进行画面切换
	self.mainscrollView.pagingEnabled = YES;
//	scrollView.directionalLockEnabled =NO;
	//隐藏滚动条设置
//	mainscrollView.alwaysBounceVertical=YES;
//	mainscrollView.alwaysBounceHorizontal =NO;
	self.mainscrollView.showsVerticalScrollIndicator= NO;
	self.mainscrollView.showsHorizontalScrollIndicator= NO;

	//循环导入数值中的图片
	for (int i = 0; i < [_photos count];i++) {
		//初始化图片的UIImageView实例
        
        UIScrollView *photoscroll = [[UIScrollView alloc] initWithFrame:CGRectMake((float)self.mainscrollView.frame.size.width*i, 0, self.mainscrollView.frame.size.width, self.mainscrollView.frame.size.height)];
    
        photoscroll.backgroundColor = [UIColor whiteColor];
        photoscroll.contentSize = CGSizeMake(self.mainscrollView.frame.size.width, self.mainscrollView.frame.size.height);
        photoscroll.decelerationRate = 0.1f;
        photoscroll.delegate = self;
        
        
        
        photoscroll.showsVerticalScrollIndicator= NO;
        
        photoscroll.showsHorizontalScrollIndicator= NO;
        
        //        photoscroll.clipsToBounds = YES;
        
        //        photoscroll.tag = i+1;
        
        
        photoscroll.minimumZoomScale = 1.0;
        photoscroll.maximumZoomScale = 3.0;
        [photoscroll setZoomScale:1.0];
        
        
        UIButton *photobtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [photoscroll addSubview:photobtn];
        [self.photolist addObject:photoscroll];
        __weak PhotoEntity * thisphoto = (PhotoEntity *)[self.photos objectAtIndex:i];
        if (thisphoto.isLoaded ==  YES) {
            if (sOrientation == kLandScapeTop) {
                photobtn.frame = CGRectMake(0, 0, kScreenWidth,   thisphoto.image.image.size.height*(kScreenWidth/thisphoto.image.image.size.width));
                photobtn.center = CGPointMake( kScreenWidth/2,kScreenHeight/2);
            }else if(sOrientation == kLandScapeRight){
                photobtn.frame = CGRectMake(0, 0, thisphoto.image.image.size.width*(kScreenWidth/thisphoto.image.image.size.height),kScreenWidth);;
                photobtn.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
            }
            [photobtn setImage:thisphoto.image.image forState:UIControlStateNormal];
        }else{
            [photobtn.imageView setImage:[UIImage imageNamed:@"Block_01_00.png"]];
            photobtn.frame = CGRectMake(0, 0, kScreenWidth,   kScreenWidth);
            if (sOrientation == kLandScapeTop) {
                photobtn.center = CGPointMake( kScreenWidth/2,kScreenHeight/2);
            }else if(sOrientation == kLandScapeRight){
                photobtn.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
            }
            
            [thisphoto.image  sd_setImageWithURL:[NSURL URLWithString:[(PhotoEntity *)[_photos objectAtIndex:i] url]]
                        placeholderImage:[UIImage imageNamed:@"Block_01_00.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   //... completion code here ...
                                   
                                   thisphoto.isLoaded =  YES;
                                   if (sOrientation == kLandScapeTop) {
                                       photobtn.frame = CGRectMake(0, 0, kScreenWidth,   thisphoto.image.image.size.height*(kScreenWidth/thisphoto.image.image.size.width));
                                       photobtn.center = CGPointMake( kScreenWidth/2,kScreenHeight/2);
                                   }else if(sOrientation == kLandScapeRight){
                                       photobtn.frame = CGRectMake(0, 0, thisphoto.image.image.size.width*(kScreenWidth/thisphoto.image.image.size.height),kScreenWidth);;
                                       photobtn.center = CGPointMake( kScreenHeight/2,kScreenWidth/2);
                                   }
                                   
                                   [photobtn setImage:thisphoto.image.image forState:UIControlStateNormal];
                               }];
        
        
        }
        
        
        [photobtn setAdjustsImageWhenHighlighted:NO];
        [self.taprecognizer addTarget:photobtn action:@selector(imageItemClick:)];
//        [photobtn addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置背景
		[photobtn setBackgroundColor:[UIColor blackColor]];
		
        
		//设置各UIImageView实例位置，及UIImageView实例的frame属性值
        photobtn.frame = CGRectMake(0, 0, kScreenWidth,   photobtn.imageView.image.size.height*(kScreenWidth/photobtn.imageView.image.size.width));;
        photobtn.center = CGPointMake(CGRectGetWidth(photoscroll.frame)/2,CGRectGetHeight(photoscroll.frame)/2);
		//将图片内容的显示模式设置为自适应模式
//		photobtn.contentMode = UIViewContentModeRedraw;
        
		//[imageView setCenter:CGPointMake(scrollView.frame.size.width / 2, scrollView.frame.size.height / 2)];
        
        
        [self.mainscrollView addSubview:photoscroll];
		
	}
	//注册UIPageControl实例的响应方法（事件为UIControlEventValueChanged）
//	[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	//设置总页数
	//pageControl.numberOfPages = nimages;
	//默认当前页为第_currentImageId页
//	pageControl.currentPage =_currentImageId;
	//pageControl.tag=0;
	//重置UIScrollView的尺寸
	
    [self.view addSubview:self.mainscrollView];
    self.currentImageId = self.currentImageId - 1;
    if((sOrientation == kLandScapeRight)||
       (sOrientation == kLandScapeLeft)){
        [self rolltoLandscape];
    }else{
        [self rollTothePage:[self currentImageId] AnimeOrNot:NO ];
    }
    

}




-(void)pausePlaying{
    self.isPlaying = NO;
    [self.playbtn setTitle:@"Play"];
    [self.playTimer invalidate];
    if([self ishidebar] == NO){
        [self setFullScreen];
    }else{
        
        [self setShowNavibar];
    }

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
        [self pausePlaying];
    }
    
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    bool a = navBar.isTranslucent;
}

- (void)playbtnClick:(id)sender
{
    [self stopAutoFullScreen];
    if([self isPlaying] == NO){
        self.isPlaying = YES;
        [self.playbtn setTitle:@"Stop"];
         self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playPhotoAction:) userInfo:nil repeats:YES];
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [[self navigationController] setToolbarHidden:YES animated:YES];
        self.ishidebar = YES;
        
    }else{
        self.isPlaying = NO;
        [self.playbtn setTitle:@"Play"];
        [self.playTimer invalidate];
        
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
    self.willshowStartAlter = NO;
    self.willshowEndAlter = NO;
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.pageMessage = [[UIAlertView alloc]
                            initWithTitle:@"メーセージ"
                            message:message
                            delegate:self
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pageMessage show];
        });
    });
    
//    [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector: @selector(dismissAction:)  userInfo:nil repeats:NO];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        self.isShowingAlter = NO;
        self.willshowStartAlter = NO;
        self.willshowEndAlter = NO;
    }
}
-(void)playPhotoAction:(NSTimer *)timer{
    
    if (self.currentImageId < [[self photos] count]-1) {
        [[self.photolist objectAtIndex:self.currentImageId] setZoomScale:1.0f];
        self.currentImageId++;
        [self rollTothePage:[self currentImageId] AnimeOrNot:YES];
    }else{
        [self.playbtn setTitle:@"Play"];
        self.isPlaying = NO;
        [self stopPlaying];
        self.willshowEndAlter = NO;
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
    [self.playTimer invalidate];
    self.playTimer = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.fullScreenTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(setFullScreenAction:) userInfo:nil repeats:NO];
    
//    self.isZooming = NO;
    self.ishidebar = NO;
    self.isPlaying = NO;
    self.isShowingAlter = NO;
    //mainscrollView.contentOffset = CGPointMake(0, 0);
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self.playTimer invalidate];
    self.playTimer = nil;
    [self stopAutoFullScreen];
    [[self navigationController] setToolbarItems:nil];

    
    [self.scrollTools removeFromSuperview];
    self.scrollTools = nil;
    
    
//    [self.photolist removeAllObjects];
//    self.photolist = nil;
//    [self.mainscrollView removeFromSuperview];
//    self.mainscrollView = nil;
//    [self.fullScreenTimer invalidate];
//    self.fullScreenTimer = nil;
//    [self.pageMessage removeFromSuperview];
//    self.pageMessage = nil;
    
    
}



-(void)stopAutoFullScreen{
    if(self.fullScreenTimer != nil){
        [self.fullScreenTimer invalidate];
        self.fullScreenTimer = nil;
    }
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    [self setFullScreen];
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.isPlaying == YES){
        [self pausePlaying];
    }
    

}
//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
    
    
}


#pragma scrollMethod





//滚动完成时调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    self.pageControlIsChangingPage = NO;
    
    //翻页时重置缩放
    if (scrollView == self.mainscrollView){
        if (self.ispagechanged == YES) {
            NSLog(@"self.ispagechanged:%d",self.ispagechanged);
            NSLog(@"scrollViewDidEndDecelerating");
            NSLog(@"currentpage is :%d",self.currentImageId);
//            [self rollTothePage:[self currentImageId] AnimeOrNot:YES];
            for (UIScrollView *s in scrollView.subviews){
                [s setZoomScale:1.0];
                if ([s isKindOfClass:[UIScrollView class]]){
                    if ( ((PhotoEntity *)[self.photos objectAtIndex:self.currentImageId]).isLoaded == YES) {
//                        [self updateZoomStatus];
                    }else{
                        
                        NSLog(@"isLoaded == NO");
                    }
                }
                
            }
            
            self.ispagechanged = NO;
        }
    }
    
    if (self.willshowStartAlter == YES) {
        [self showNopageMessage:@"最初の画像です"];
        
    }else if(self.willshowEndAlter == YES){
        [self showNopageMessage:@"最後の画像です"];
        
    }
    self.willshowStartAlter = NO;
    self.willshowEndAlter = NO;
    
}


//实现UIScrollViewDelegate 中定义的方法
//滚动时调用的方法，其中判断画面滚动时机
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = self.mainscrollView.frame.size.width;
    int page = floor((self.mainscrollView.contentOffset.x - pageWidth*9 / 16) / pageWidth) + 1;
    if (self.pageControlIsChangingPage) {
        
        return;
    }
    
	/*
	 *	下一画面拖动到超过50%时，进行切换
	 */
    NSLog(@"scrollViewDidScroll");
    if (scrollView == self.mainscrollView){
         NSLog(@"scrollViewDidScroll:mainscrollView");
        if ((page == self.currentImageId)&&
            (page != (self.photos.count-1))&&
            (page != 0)) {
           
            return ;
        }
        
        
    
        if((self.currentImageId != page)&&
           (page > 0)&&
           (page <= [self.photos count]-1)){
            NSLog(@"changing page to:%d",page);
            
            self.currentImageId = page;
            self.ispagechanged = YES;
            
        }else{

            
        }
    }
    
    if ((page+1) >= [[self photos] count] ){
        if (((scrollView.contentOffset.x+pageWidth*7/8 >scrollView.contentSize.width))) {
            if (self.isZooming == NO) {
                NSLog(@"EndcontentOffset.x:%f",scrollView.contentOffset.x);
                NSLog(@"EndscrollView.contentSize.width:%f",scrollView.contentSize.width);
//                NSLog(@"EndcontentOffset.x:%f",scrollView.contentOffset.x);
                self.willshowEndAlter = YES;
            }
            
        }
        
        
        
    }else  if(page <= 0)
    {
        //                CGFloat a = scrollView.contentOffset.x;
        if ((scrollView.contentOffset.x + pageWidth / 8 < 0)) {
            if (self.isZooming == NO) { //缩放时不弹出提示
                NSLog(@"scrollView.contentOffset.x:%f",scrollView.contentOffset.x);
                self.willshowStartAlter = YES;
            }
            
            
        }
    }
    
}

// 扩大/縮小功能
#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        
        if ([(PhotoEntity *)[self.photos objectAtIndex:self.currentImageId] isLoaded] == NO) {
            return nil;
        }
        
        return v;
    }
    
    return nil;
}


-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
   
    self.isZooming = YES;

}

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
    self.isZooming = NO;
   }

- (BOOL) hidesBottomBarWhenPushed {
    return YES;
}



@end
