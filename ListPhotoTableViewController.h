//
//  ListPhotoTableViewController.h
//  Album1408
//
//  Created by zhang_ying on 14-8-27.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListPhotoTableViewController : UITableViewController{
    

}
  
@property (nonatomic,assign)int sOrientation;
@property (nonatomic,assign)float leftTime;                               //超时警告剩余时间

//@property (nonatomic,strong)NSTimer *loadTimer;
@property (nonatomic,strong)NSMutableArray *photos;  //用于存储一组photo

//-(void)loadTimerAction:(NSTimer *)timer;
@end
