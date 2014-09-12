//
//  ListPhotoTableViewController.h
//  Album1408
//
//  Created by zhang_ying on 14-8-27.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <UIKit/UIKit.h>
static bool loadImageDone;
@interface ListPhotoTableViewController : UITableViewController{
    
//    NSMutableArray *photos;  //用于存储一组photo
//    NSTimer *loadTimer;   //用于读取图片
}
  
@property int sOrientation;

//-(void) SetPhotos:(NSMutableArray*)photolist;

@property NSMutableArray *photos;  //用于存储一组photo


@end
