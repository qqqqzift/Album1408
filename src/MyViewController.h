//
//  MyViewController.h
//  Album1408
//
//  Created by zhang_ying on 14-9-5.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController<UIScrollViewDelegate> 



@property NSMutableArray *photos;  //用于存储一组photo
@property int currentImageId;
@property bool islastpageList;
@property  int sOrientation;
@end


