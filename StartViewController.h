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
@class  GlobalAlert;

static int runCnt;
@interface StartViewController : UIViewController<NSXMLParserDelegate,UIAlertViewDelegate>{
    
    __weak StartViewController *thisCtrl;
    
}
@property (atomic,assign)__block bool isShowingAlert;
@property (nonatomic,assign) bool isShowingXMLAlert;
@property (atomic,assign)__block bool isRetry;
@property (nonatomic,strong)UIAlertView *connectMessage;
@property (nonatomic,strong)NSMutableArray *photos;  //用于存储一组photo
@property (nonatomic,strong)NSMutableString *currentElementValue;  //用于存储元素标签的值

//@property (nonatomic,strong)NSTimer *mmTimer;              //load picture timer overtimer

@property (nonatomic,strong)PhotoEntity *aPhoto;  //photo实例，代表一本书

@property (nonatomic,assign)BOOL storingFlag; //查询标签所对应的元素是否存在

@property (nonatomic,strong)NSArray *elementToParse;  //要存储的元素

@property (nonatomic,strong)MBProgressHUD *HUD;

@property (atomic,strong)GlobalAlert *timeOverAlert;
@property (nonatomic,strong)NSTimer *loadxmlTimer;

@end
