//
//  PhotoScrollViewController.h
//  Album1408
//
//  Created by zhang_ying on 14-9-4.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollViewController : UIViewController
<UIScrollViewDelegate>
{
	//定义UIScrollView与UIPageControl实例变量
	UIScrollView* scrollView;
//	UIPageControl* pageControl;
	//定义滚动标志
    BOOL pageControlIsChangingPage;
    CGRect oldFrameV;    //保存图片原来的大小
    CGRect largeFrameV;  //确定图片放大最大的程度
    CGRect oldFrameH;    //保存图片原来的大小
    CGRect largeFrameH;  //确定图片放大最大的程度

//    UIView *vView;
//    UIView *hView;
    
    
	
    
}

@property long currentImageId;
@property BOOL islastpageList;
@property bool ishidebar;
@property int sOrientation;
@property NSMutableArray  *photos;  //用于存储一组photo

/* UIPageControll的响应方法 */
//- (void)changePage:(id)sender;



/* 内部方法，导入图片并进行UIScrollView的相关设置 */
- (void)setupPage;

//-(void) SetPhotos:(NSMutableArray*)photolist;
@end
