//
//  PhotoScrollViewController.h
//  Album1408
//
//  Created by zhang_ying on 14-9-4.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GlobalAlert;
@interface TranslucentToolbar : UIToolbar

@end


@interface PhotoScrollViewController : UIViewController
<UIScrollViewDelegate,UIAlertViewDelegate>
{
	
//    int offset;
}
//定义UIScrollView与UIPageControl实例变量

//@property (nonatomic,strong)GlobalAlert *timeOverAlert;
@property (nonatomic,strong)UIScrollView* mainscrollView;


@property (nonatomic,assign)BOOL pageControlIsChangingPage;


@property (nonatomic,strong)NSMutableArray *photolist;          //list of scrollview
//    NSMutableArray *imagelist;          //list of uibutton in scrollview
@property (nonatomic,assign)BOOL isZooming;
@property (nonatomic,strong)UIBarButtonItem *playbtn;
@property (nonatomic,assign)BOOL isVertical;                    //横屏竖屏判断
@property (nonatomic,strong)NSTimer *playTimer;                 //播放计时器
@property (nonatomic,strong)NSTimer *fullScreenTimer;           //隐藏导航栏计时器
@property (nonatomic,strong)UIAlertView *pageMessage;           //首页末页提示
@property (nonatomic,assign)CGFloat saveForZooming;
@property (nonatomic,assign)int currentImageId;
@property (nonatomic,assign)BOOL islastpageList;      //上一页是否是列表

@property (nonatomic,assign)bool ishidebar;     //导航栏是否别隐藏
@property (nonatomic,assign)BOOL isPlaying;    //播放状态
@property (nonatomic,assign)int sOrientation;
@property (nonatomic,strong)NSMutableArray  *photos;  //用于存储一组photo
@property (nonatomic,assign)BOOL ispagechanged;
@property (nonatomic,assign)bool willshowStartAlter;
@property (nonatomic,assign)bool willshowEndAlter;
@property (nonatomic,assign)bool isShowingAlter;
@property (nonatomic,strong)TranslucentToolbar *scrollTools;
//@property BOOL isRotation;          //
//@property bool isZooming;           //
//@property int lastpage;
/* UIPageControll的响应方法 */
//- (void)changePage:(id)sender;



/* 内部方法，导入图片并进行UIScrollView的相关设置 */
//- (void)setupPage;

//-(void) SetPhotos:(NSMutableArray*)photolist;
@end
