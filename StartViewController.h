//
//  ViewController.h
//  AlbumZY
//
//  Created by zhang_ying on 14-8-25.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoEntity.h"
#import "MBProgressHUD.h"
#import <unistd.h>


static int runCnt;
@interface StartViewController : UIViewController<NSXMLParserDelegate>{
    
    NSMutableString *currentElementValue;  //用于存储元素标签的值
    
    NSMutableArray *photos;  //用于存储一组photo
    
    PhotoEntity *aPhoto;  //photo实例，代表一本书
    
    BOOL storingFlag; //查询标签所对应的元素是否存在
    
    NSArray *elementToParse;  //要存储的元素
    
    MBProgressHUD *HUD;
    
    
}

@end
