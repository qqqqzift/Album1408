//
//  PhotoScrollViewController.h
//  Album1408
//
//  Created by zhang_ying on 14-9-4.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TranslucentToolbar : UIToolbar

@end


@interface PhotoScrollViewController : UIViewController
<UIScrollViewDelegate,UIAlertViewDelegate>
{
	//定义UIScrollView与UIPageControl实例变量
	UIScrollView* mainscrollView;
    TranslucentToolbar *scrollTools;
//	UIPageControl* pageControl;
	//定义滚动标志
    BOOL pageControlIsChangingPage;
    CGRect oldFrameV;    //保存图片原来的大小
    CGRect largeFrameV;  //确定图片放大最大的程度
    CGRect oldFrameH;    //保存图片原来的大小
    CGRect largeFrameH;  //确定图片放大最大的程度

    NSMutableArray *photolist;          //list of scrollview
    NSMutableArray *imagelist;          //list of uibutton in scrollview
    UIBarButtonItem *playbtn;
    BOOL isVertical;                    //横屏竖屏判断
    NSTimer *playTimer;                 //播放计时器
    NSTimer *fullScreenTimer;           //隐藏导航栏计时器
    UIAlertView *pageMessage;           //首页末页提示
    int offset;
}

@property int currentImageId;
@property BOOL islastpageList;
@property bool ishidebar;
@property BOOL isPlaying;    //播放状态
@property int sOrientation;
@property NSMutableArray  *photos;  //用于存储一组photo

@property bool isShowingAlter;
//@property bool isZooming;           //
@property int lastpage;
/* UIPageControll的响应方法 */
//- (void)changePage:(id)sender;



/* 内部方法，导入图片并进行UIScrollView的相关设置 */
- (void)setupPage;

//-(void) SetPhotos:(NSMutableArray*)photolist;
@end
