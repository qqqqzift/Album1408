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


@interface ListPhotoLViewController ()



@end

@implementation ListPhotoLViewController
@synthesize sOrientation;

-(void)imageItemClick:(UIImageButton *)button{

    PhotoScrollViewController *photoView = [[PhotoScrollViewController alloc]init];
    photoView.currentImageId = button.ID;
    [photoView SetPhotos:photos];
    photoView.islastpageList = NO;
    [self.navigationController pushViewController: photoView animated:NO];
}





-(void) SetPhotos:(NSMutableArray*)photolist{
    photos = [[NSMutableArray alloc] initWithArray:photolist];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            NSLog(@"UIInterfaceOrientationPortrait");
            elemInLine = kVLineCnt;
            sOrientation = kLandScapeTop;
            //home健在下
            //loadingview.frame=CGRectMake(284, 402, 200, 200);
            //[self.viewaddSubview:loadingview];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            NSLog(@"UIInterfaceOrientationPortraitUpsideDown");
            sOrientation = kLandScapeBottom;
            elemInLine = kVLineCnt;
            //home健在上
            //loadingview.frame=CGRectMake(284, 402, 200, 200);
            //[self.viewaddSubview:loadingview];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            NSLog(@"UIInterfaceOrientationLandscapeLeft");
            elemInLine = [MMCommon kHLineCnt];
            //home健在左
            sOrientation = kLandScapeLeft;
            
            
//            loadingview.frame=CGRectMake(412, 264, 200, 200);
//            [self.viewaddSubview:loadingview];
            break;
        case UIInterfaceOrientationLandscapeRight:
            NSLog(@"UIInterfaceOrientationLandscapeRight");
            //home健在右
            elemInLine = [MMCommon kHLineCnt];
            sOrientation = kLandScapeRight;
            
//            loadingview.frame=CGRectMake(412, 264, 200, 200);
//            [self.viewaddSubview:loadingview];
            break;
        default:
            NSLog(@"OrientationNotHandled");
            elemInLine = kVLineCnt;
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
    if ((oflag == kLandScapeTop)||
        (oflag == kLandScapeBottom)){
        indent = (kScreenWidth - kImageWidth * lcnt)/(lcnt +1.0);
    }else if((oflag == kLandScapeRight)||
             (oflag == kLandScapeLeft)){
        indent = (kScreenHeight - kImageWidth * lcnt)/(lcnt +1.0);
        
    }else{
        indent =5;
    }
//    NSLog(@"indent:%lf",indent);
    NSMutableArray *btnArray = [[NSMutableArray alloc]initWithCapacity:[photos count]];
    for (int i=0; i<lcnt; i++) {
        if ((row*lcnt +i) >= [photos count]) {
            break;
        }
        //自定义继续UIButton的UIImageButton 里面只是加了2个row和column属性
        UIImageButton *button = [UIImageButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
        button.center = CGPointMake((1 + i) * indent+ kImageWidth *( 0.5 + i) , 5 + kImageHeight * 0.5);
        //button.column = i;
        [button setValue:[NSNumber numberWithInt:[(PhotoEntity *)[photos objectAtIndex:(row*lcnt +i)] ID]]forKey:@"ID"];
        [button setValue:[NSNumber numberWithInt:i] forKey:@"column"];
        
        
        UIImageView * timage = [(PhotoEntity *)[photos objectAtIndex:(row*lcnt +i)] egoImage];
        
        [button setBackgroundImage:timage.image forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [ocell addSubview:button];
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
    //self.image = [self cutCenterImage:[UIImage imageNamed:@"macbook_pro.jpg"]  size:CGSizeMake(100, 100)];
    
    
    
    
    UIBarButtonItem *seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = seteiButton;
    //todo 横屏判断
    elemInLine = 4;
    
    //
    UIDevice *device = [UIDevice currentDevice];
    
    [device beginGeneratingDeviceOrientationNotifications];
    
    //利用 NSNotificationCenter 获得旋转信号 UIDeviceOrientationDidChangeNotification
    
    NSNotificationCenter *ncenter = [NSNotificationCenter defaultCenter];
    
    [ncenter addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:device];
    
    
    
}

-(void)orientationChanged{
    NSLog(@"orientationChanged");
}
-(void)selectRightAction:(id)sender
{
    ListPhotoTableViewController *albumView = [[ListPhotoTableViewController alloc]init];
    
    [albumView SetPhotos:photos];
    [self.navigationController pushViewController: albumView animated:NO];
    
}

#pragma mark UITable datasource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (([photos count]%elemInLine) == 0) {
        return ([photos count]/elemInLine);
    }else{
        return (([photos count]/elemInLine) + 1);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"didEnddisplayingCell");


}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellforRowAtIndexPath call,sOrientation:%d",sOrientation);
    if((sOrientation == kLandScapeBottom)||(sOrientation == kLandScapeTop)){
        NSLog(@"top:top cell");
        static NSString *identifierT = @"CellTop";
         UITableGridViewCell *cellTop = [tableView dequeueReusableCellWithIdentifier:identifierT];
        if (cellTop == nil) {
            NSLog(@"top:init top cell");
//            [[cellTop viewWithTag:100] removeFromSuperview];
            
            cellTop = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierT];
            cellTop.selectedBackgroundView = [[UIView alloc] init];
            [self setTopCellByRow:indexPath.row allele:photos cell:cellTop];
            
            
        }
        return cellTop;
    }else {
        
        NSLog(@"right:right cell");
        static NSString *identifierR = @"CellRight";
        //自定义UITableGridViewCell，里面加了个NSArray用于放置里面的4个图片按钮
        
        
        UITableGridViewCell *cellRight = [tableView dequeueReusableCellWithIdentifier:identifierR];
        cellRight.selectedBackgroundView = [[UIView alloc] init];
        if (cellRight == nil) {
            NSLog(@"right:init right cell");
            
//            [[cellRight viewWithTag:100] removeFromSuperview];
            cellRight = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierR];
            
            [self setRightCellByRow:indexPath.row allele:photos cell:cellRight];
            
            
            
        }
        return cellRight;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kImageHeight + 5;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不让tableviewcell有选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
