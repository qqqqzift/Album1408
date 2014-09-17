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



@property (nonatomic,strong)NSMutableArray *photos;  //用于存储一组photo


@end
