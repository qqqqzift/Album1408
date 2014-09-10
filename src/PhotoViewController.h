//
//  PhotoViewController.h
//  Album1408
//
//  Created by zhang_ying on 14-8-26.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController{
    UIToolbar *photoToolBar;        //UIToolbar;
    NSMutableArray *photoToolBarItems;//数组
    UIBarButtonItem *playButton;    //toolbar按钮
    NSMutableArray *photos;  //用于存储一组photo
    UIImageView *photoview;
    CGRect oldFrameV;    //保存图片原来的大小
    CGRect largeFrameV;  //确定图片放大最大的程度
    CGRect oldFrameH;    //保存图片原来的大小
    CGRect largeFrameH;  //确定图片放大最大的程度
    BOOL isVertical;    //横屏竖屏判断
    BOOL isZoomed;       //判断是否放大缩小
    float lastScale;

}

@property int currentImageId;
-(void) SetPhotos:(NSMutableArray*)photolist;
@end
