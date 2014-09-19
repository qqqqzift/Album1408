//
//  ViewController.h
//  igridviewdemo
//
//  Created by vincent_guo on 13-12-12.
//  Copyright (c) 2013年 vincent_guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageButton.h"
@class GlobalAlert;
static NSString *identifierT = @"CellTop";
static NSString *identifierR = @"CellRight";

@interface ListPhotoLViewController : UITableViewController{
    
    
    __block BOOL potraitNeedsToupdate;
    __block BOOL landscapeNeedsToupdate;
    
}
@property (nonatomic,assign)NSInteger  startdate;
//@property (nonatomic,strong)GlobalAlert *timeOverAlert;
@property  (nonatomic,assign)int sOrientation;
@property (nonatomic,assign)int mImageHeight;
@property (nonatomic,assign)int elemInLine;            //每行元素个数
@property (nonatomic,strong)NSMutableArray *photos;  //用于存储一组photo
//-(void) SetPhotos:(NSMutableArray*)photolist;

@end
