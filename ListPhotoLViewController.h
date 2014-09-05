//
//  ViewController.h
//  igridviewdemo
//
//  Created by vincent_guo on 13-12-12.
//  Copyright (c) 2013年 vincent_guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageButton.h"


@interface ListPhotoLViewController : UITableViewController{
    
    
    int elemInLine;            //每行元素个数

}

@property  int sOrientation;

@property NSMutableArray *photos;  //用于存储一组photo
//-(void) SetPhotos:(NSMutableArray*)photolist;

@end
