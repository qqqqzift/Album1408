//
//  ViewController.h
//  igridviewdemo
//
//  Created by vincent_guo on 13-12-12.
//  Copyright (c) 2013年 vincent_guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageButton.h"
static NSString *identifierT = @"CellTop";
static NSString *identifierR = @"CellRight";

@interface ListPhotoLViewController : UITableViewController{
    
    
//    NSTimer *resizeTimer;   //用于读取图片
//    __block int loadcnt;    //读取完成的计数器
//    __block int changedSubCellIndex;    //被读取完成的图片的行
}
//@property bool isneededtoresize;
//@property bool isResized;
@property  int sOrientation;
@property int mImageHeight;
@property int elemInLine;            //每行元素个数
@property NSMutableArray *photos;  //用于存储一组photo
//-(void) SetPhotos:(NSMutableArray*)photolist;

@end
