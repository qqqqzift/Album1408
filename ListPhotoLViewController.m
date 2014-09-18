//
//  ViewController.m
//  igridviewdemo
//
//  Created by vincent_guo on 13-12-12.
//  Copyright (c) 2013年 vincent_guo. All rights reserved.
//
#import "ListPhotoTableViewController.h"
#import "PhotoScrollViewController.h"
#import "ListPhotoLViewController.h"
#import "PhotoViewController.h"
#import "UITableGridViewCell.h"
#import "PhotoEntity.h"
#import "MMCommon.h"

#import "UIImageView+WebCache.h"
#import "UIImage+UIImageExt.h"


@interface ListPhotoLViewController ()



@end

@implementation ListPhotoLViewController
@synthesize sOrientation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mImageHeight = 0;
//        loadcnt = 0;
//        self.isneededtoresize = NO;
    }
    return self;
}
-(void)imageItemClick:(UIImageButton *)button{

    PhotoScrollViewController *photoView = [[PhotoScrollViewController alloc]init];
    photoView.currentImageId = button.ID;
    photoView.photos = [self photos];
    photoView.islastpageList = NO;
    photoView.sOrientation = [self sOrientation];
//    [self stopResize];
    [self.navigationController pushViewController: photoView animated:NO];
}





-(void) SetPhotos:(NSMutableArray*)photolist{
    _photos = [[NSMutableArray alloc] initWithArray:photolist];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"UIInterfaceOrientationPortrait");
            self.elemInLine = kVLineCnt;
            sOrientation = kLandScapeTop;
            //home健在下
            break;
        

        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"UIInterfaceOrientationLandscapeLeft");
            self.elemInLine = [MMCommon kHLineCnt];
            //home健在右
            sOrientation = kLandScapeRight;
            break;
        default:
            NSLog(@"OrientationNotHandled");
            if (self.elemInLine == 0) {
                self.elemInLine = kVLineCnt;
            }
            break;
    }
    NSLog(@"Reload call");
    [self.tableView reloadData];
}

//- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
//
//}

-(void) setCellByRow:(long)row lineCnt:(int)lcnt oFlag:(int)oflag icell:(UITableGridViewCell *)ocell{
    
    float indent;
    __block bool ispotrait;
    if ((oflag == kLandScapeTop)||
        (oflag == kLandScapeBottom)){
        indent = (kScreenWidth - kImageWidth * lcnt)/(lcnt +1.0);
        ispotrait = YES;
    }else if((oflag == kLandScapeRight)||
             (oflag == kLandScapeLeft)){
        indent = (kScreenHeight - kImageWidth * lcnt)/(lcnt +1.0);
        ispotrait = NO;
    }else{
        ispotrait = YES;
        indent =5;
    }
    NSMutableArray *btnArray = [[NSMutableArray alloc]initWithCapacity:[self.photos count]];
    for (int i=0; i<lcnt; i++) {
        if ((row*lcnt +i) >= [self.photos count]) {
            break;
        }
        //自定义继续UIButton的UIImageButton 里面只是加了2个row和column属性
        UIImageButton *button = [UIImageButton buttonWithType:UIButtonTypeCustom];
        //[button.tag ]
        button.bounds = CGRectMake(0, 0, kImageWidth, kImageWidth);
        button.center = CGPointMake((1 + i) * indent+ kImageWidth *( 0.5 + i) , 5 + kImageWidth * 0.5);
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"Block_01_00.png"] forState:UIControlStateNormal];
        
        //button.column = i;
        [button setValue:[NSNumber numberWithInt:[(PhotoEntity *)[self.photos objectAtIndex:(row*lcnt +i)] ID]]forKey:@"ID"];
        [button setValue:[NSNumber numberWithInt:i] forKey:@"column"];
        [button addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [ocell addSubview:button];
        
        UIImageView *tmpImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kImageWidth, kImageWidth)];
        __weak PhotoEntity * thisphoto = (PhotoEntity *)[self.photos objectAtIndex:(row*lcnt +i)];
        thisphoto.image.backgroundColor = [UIColor blackColor];
        if ([(PhotoEntity *)[_photos objectAtIndex:(row*lcnt +i)] isLoaded] == YES) {
            
            tmpImage.frame = CGRectMake(0,0, kImageWidth,  kImageWidth*thisphoto.image.image.size.height/thisphoto.image.image.size.width);
            tmpImage.center = ccp(CGRectGetWidth(button.frame)/2,
                                         CGRectGetHeight(button.frame)/2);
            [tmpImage setImage:thisphoto.image.image];
            [button addSubview:tmpImage];
//            [thisTbl reloadData];
        }else{
            
            [thisphoto.image sd_setImageWithURL:[NSURL URLWithString:[(PhotoEntity *)[_photos objectAtIndex:(row*lcnt +i)] url]]
             //                            forState:UIControlStateNormal;
                        placeholderImage:[UIImage imageNamed:@"Block_01_00.png"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   //                             if (((PhotoEntity *)[self.photos objectAtIndex:i]).isLoaded == NO) {
                                   
                                   
                                   thisphoto.isLoaded = YES;
                                   tmpImage.frame = CGRectMake(0,0, kImageWidth,  kImageWidth*thisphoto.image.image.size.height/thisphoto.image.image.size.width);
                                   tmpImage.center = ccp(CGRectGetWidth(button.frame)/2,
                                                 CGRectGetHeight(button.frame)/2);
                                   [tmpImage setImage:thisphoto.image.image];
                                   [button addSubview:tmpImage];
//                                   [thisTbl reloadData];
                                   //
                                   if (ispotrait == YES) {
                                       landscapeNeedsToupdate = YES;
                                   }else{
                                       potraitNeedsToupdate = YES;
                                   }
                                   
                                   
                               }];
        }
        
        [btnArray addObject:button];
    }
    
    [ocell setValue:btnArray forKey:@"buttons"];
    //获取到里面的cell里面的4个图片按钮引用
    NSArray *imageButtons =ocell.buttons;
    [imageButtons setValue:[NSNumber numberWithLong:row] forKey:@"row"];
    
    
}

-(void) setTopCellByRow:(long)row  allele:(NSArray *)photos cell:(UITableGridViewCell *)cell{
    [self setCellByRow:row  lineCnt:kVLineCnt oFlag:kLandScapeTop icell:cell];
}

-(void) setRightCellByRow:(long)row  allele:(NSArray *)photos cell:(UITableGridViewCell *)cell{
    [self setCellByRow:row  lineCnt:[MMCommon kHLineCnt] oFlag:kLandScapeRight icell:cell];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"アルバム";
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.hidesBackButton = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.wantsFullScreenLayout = YES;
    
    UIBarButtonItem *seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = seteiButton;
    //todo 横屏判断
    if (self.sOrientation == kLandScapeTop) {
        self.elemInLine = 4;
    }else if(self.sOrientation == kLandScapeRight){
        self.elemInLine = [MMCommon kHLineCnt];
    }else{
        self.elemInLine = 4;
    }
    landscapeNeedsToupdate = NO;
    potraitNeedsToupdate = NO;

}


-(void)selectRightAction:(id)sender
{
    ListPhotoTableViewController *albumView = [[ListPhotoTableViewController alloc]init];
    
    albumView.photos = _photos;
    albumView.sOrientation = sOrientation;
    [self.navigationController pushViewController: albumView animated:NO];
    
}

#pragma mark UITable datasource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (([self.photos count]%self.elemInLine) == 0) {
        return ([self.photos count]/self.elemInLine);
    }else{
        return (([self.photos count]/self.elemInLine) + 1);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"didEnddisplayingCell");


}

- (void)viewDidAppear:(BOOL)animated{
    
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
//    resizeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5  target:self selector:@selector(loadPicturesize:) userInfo:nil repeats:YES];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"cellforRowAtIndexPath call,sOrientation:%d",sOrientation);
    
    if((sOrientation == kLandScapeBottom)||(sOrientation == kLandScapeTop)){
//        NSLog(@"top:top cell");
        UITableGridViewCell *cellTop = [tableView dequeueReusableCellWithIdentifier:identifierT];
        
        
        if ((cellTop == nil)||(potraitNeedsToupdate == YES)) {
            
            cellTop = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierT];
            cellTop.selectedBackgroundView = [[UIView alloc] init];
            [self setTopCellByRow:indexPath.row allele:_photos cell:cellTop];
            
            
        }
        return cellTop;
    }else {
        
//        NSLog(@"right:right cell");
        
        //自定义UITableGridViewCell，里面加了个NSArray用于放置里面的4个图片按钮
        
        
        UITableGridViewCell *cellRight = [tableView dequeueReusableCellWithIdentifier:identifierR];
        
        
        if ((cellRight == nil)||(landscapeNeedsToupdate == YES)) {
            
            cellRight = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierR];
            cellRight.selectedBackgroundView = [[UIView alloc] init];
            [self setRightCellByRow:indexPath.row allele:_photos cell:cellRight];
            
            
            
        }
        return cellRight;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning in ListPhotoViewController");
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    
    
}


- (void)viewWillDisappear:(BOOL)animated{

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不让tableviewcell有选中效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}



-(void)viewWillAppear:(BOOL)animated
{
    
    [[self navigationController] setToolbarHidden:YES animated:NO];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return kImageWidth+5;
}

-(void)dealloc{
    NSLog(@"ListPhotoLViewController dealloc");
    
}
@end
