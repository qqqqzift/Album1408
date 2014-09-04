//
//  PhotoViewController.m
//  Album1408
//
//  Created by zhang_ying on 14-8-26.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import "PhotoViewController.h"

#import "ListPhotoTableViewController.h"
#import "PhotoEntity.h"
#import "MMCommon.h"
@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize currentImageId = _currentImageId;
-(void) SetPhotos:(NSMutableArray*)photolist{
    photos = [[NSMutableArray alloc] initWithArray:photolist];

    
}


-(BOOL)checkZoomed:(CGRect )flame{
    NSLog(@"flame.size.width:%lf",flame.size.width);
    NSLog(@"flame.size.height:%lf",flame.size.height);
    NSLog(@"photoview.frame.size.width:%lf",photoview.frame.size.width);
    NSLog(@"photoview.frame.size.height:%lf",photoview.frame.size.height);
    NSLog(@"(AAAAAA:%lf",fabs( flame.size.width - photoview.frame.size.width));
    NSLog(@"BBBBBBBBBB:%lf",fabs( flame.size.height - photoview.frame.size.height));
    if (
        (fabs(flame.size.width - photoview.frame.size.width) <kEPS)&&
        (fabs(flame.size.height - photoview.frame.size.height) <kEPS)) {
        
        isZoomed = NO;
    }else{
        isZoomed = YES;
    
    }
    return isZoomed;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            isVertical = YES;
            NSLog(@"UIInterfaceOrientationPortraitUpsideDown or UIInterfaceOrientationPortrait");
            if ([self checkZoomed:oldFrameH] == NO) {
                NSLog(@"No Zoomed V");
//                photoview.bounds = CGRectMake(0, 0, kScreenWidth,photoview.image.size.height*(kScreenWidth/photoview.image.size.width));
                photoview.frame = oldFrameV;
                photoview.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
            }else{
                NSLog(@"Zoomed V");
                //photoview.bounds = CGRectMake(0, 0, photoview.image.size.width,photoview.image.size.height);
                 photoview.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
            }
    
            
            
            [self reset0verflow];
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            isVertical = NO;
            NSLog(@"UIInterfaceOrientationLandscapeRight or UIInterfaceOrientationLandscapeLeft");
            //home健在右
            if ([self checkZoomed:oldFrameV] == NO) {
                NSLog(@"No Zoomed H");
              
//                photoview.bounds = CGRectMake(0, 0, photoview.image.size.width*(kScreenWidth/photoview.image.size.height),kScreenWidth);
                 photoview.frame = oldFrameH;
//                 photoview.bounds = oldFrameH;
//                float w = photoview.frame.size.width;
                 photoview.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
            }
            else{
               NSLog(@"Zoomed H");
                //photoview.bounds = CGRectMake(0, 0,photoview.image.size.height,photoview.image.size.width);
                photoview.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
            }
            
            
            [self reset0verflow];
            break;
        default:
            NSLog(@"OrientationNotHandled");
            
            break;
            
            
    }
}





// 添加所有的手势
- (void) addGestureRecognizerToView:(UIView *)view
{
//    // 旋转手势
//    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
//    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//    [view addGestureRecognizer:panGestureRecognizer];
    
    //滑动手势
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{

    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"swipe right");
        //执行程序
        if (_currentImageId <[photos count]) {
            _currentImageId++;
            UIImage *tmpImage = [self getPhotoByID:_currentImageId] ;
            [photoview setImage: tmpImage];
            if (isVertical) {
                photoview.frame = oldFrameV;
                photoview.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
            }else{
                photoview.frame = oldFrameH;
                photoview.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
                
            }
            isZoomed = NO;
            
        }
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        
        NSLog(@"swipe left");
        //执行程序
        if ((_currentImageId-1) >0) {
            _currentImageId--;
            UIImage *tmpImage = [self getPhotoByID:_currentImageId] ;
            [photoview setImage: tmpImage];
            if (isVertical) {
                photoview.frame = oldFrameV;
                photoview.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
            }else{
                photoview.frame = oldFrameH;
                photoview.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
                
            }
            isZoomed = NO;
        }
    }
    
}

-(void)reset0verflow{
    //让图片无法缩得比原图小
    if((isVertical == YES) &&(photoview.frame.size.width < oldFrameV.size.width))
    {
        photoview.frame = oldFrameV;
        photoview.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
        
    }
    
    if ((isVertical == NO)&&(photoview.frame.size.width < oldFrameH.size.width)) {
        photoview.frame = oldFrameH;
        photoview.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
    }
    
    
    if ((isVertical == YES)&&(photoview.frame.size.width > 3 * oldFrameV.size.width)) {
        photoview.frame = largeFrameV;
        photoview.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    }
    
    if ((isVertical == NO)&&(photoview.frame.size.width > 3 * oldFrameH.size.width)) {
        photoview.frame = largeFrameH;
        photoview.center = CGPointMake(kScreenHeight/2,kScreenWidth/2);
    }
}
// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    UIView *view = pinchGestureRecognizer.view;
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        
        
        pinchGestureRecognizer.scale = 1;
    }
    
    
    if ((pinchGestureRecognizer.state ==UIGestureRecognizerStateEnded) || (pinchGestureRecognizer.state ==UIGestureRecognizerStateCancelled)) {
        
        lastScale =lastScale*pinchGestureRecognizer.scale;
        
    }
    [self reset0verflow];
}

//// 处理拖拉手势
//- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
//{
//    UIView *view = panGestureRecognizer.view;
//    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
//        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
//        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
//    }
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIImage *)getPhotoByID:(int)ID{
    int i = 0;
    for(PhotoEntity *pe in photos){
        
        if (pe.ID == ID) {
            return [(PhotoEntity *)[photos objectAtIndex:(i)] egoImage].image;
        }
        i++;
    
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    NSLog(@"%lu",(unsigned long)[photos count]);
    
    [self setTitle:@"画像"];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStyleDone target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = seteiButton;
    
    
    
    
    photoview = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //photoview.bounds  =
    photoview.center = CGPointMake(kScreenWidth/2,kScreenHeight/2);
    UIImage *tmpImage = [self getPhotoByID:_currentImageId] ;
    
    
    //original frame and max frame
    
    oldFrameV = CGRectMake(0, 0, kScreenWidth,   tmpImage.size.height*(kScreenWidth/tmpImage.size.width));
    largeFrameV = CGRectMake(kScreenWidth/2, kScreenHeight/2, 3 * oldFrameV.size.width, 3 * oldFrameV.size.height);
//    NSLog(@"tmpImage.size.width:%lf",tmpImage.size.width);
//    NSLog(@"tmpImage.size.height:%lf",tmpImage.size.width);
//    NSLog(@"kScreenWidth:%lf",kScreenWidth);
//    NSLog(@"kScreenHeight:%lf",kScreenHeight);
//    NSLog(@"kScreenWidth/tmpImage.size.height:%lf",(kScreenWidth/tmpImage.size.height));
    //NSlog(@"tmpImage.size.height:%lf",tmpImage.size.width);
    oldFrameH = CGRectMake(0, 0, tmpImage.size.width*(kScreenWidth/tmpImage.size.height),kScreenWidth);
    largeFrameV = CGRectMake( kScreenHeight/2, kScreenWidth/2, 3 * oldFrameV.size.height, 3 * oldFrameV.size.width);
    
    isZoomed = NO;
    isVertical = YES;
    
    photoview.bounds = oldFrameV;
    if (tmpImage != nil) {
        [photoview setImage: tmpImage];
    }else{
        //to do没有图片的操作
    }
    
    [self addGestureRecognizerToView:photoview];
    //旋转，处理图片
    [photoview setUserInteractionEnabled:YES];
    [photoview setMultipleTouchEnabled:YES];
    
   
    
    [self.view addSubview:photoview];
    
    
    
    lastScale = 1;
    
    //todo 追加
    photoToolBarItems = [NSMutableArray array];//初始化数组
    playButton = [[UIBarButtonItem alloc]//创建播放的按钮
                  initWithTitle:@"Play"//标题叫做Play
                  style:UIBarButtonItemStyleBordered
                  target:self
                  action:@selector(playButtonClicked)];//点击按钮时调用的方法
    
    //把数组的元素放到UIToolbar里
    [photoToolBar setItems:photoToolBarItems animated:YES];
    //把UIToolbar放在View上显示出来
    [self.view addSubview:photoToolBar];
    //UIImage* icon = [UIImage imageNamed:@"ball2.png"];
    //UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    
    
   
    

}

- (void)playButtonClicked
{
        //todo  change photo automaticlly
}


-(void)selectRightAction:(id)sender
{
    ListPhotoTableViewController *albumView = [[ListPhotoTableViewController alloc]init];
    
    [albumView SetPhotos:photos];
    [self.navigationController pushViewController: albumView animated:NO];
    
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

@end
