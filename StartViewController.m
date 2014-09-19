//
//  ViewController.m
//  AlbumZY
//
//  Created by zhang_ying on 14-8-25.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import "StartViewController.h"
#import "AFNetworking.h"
#import "AFXMLRequestOperation.h"
#import "ListPhotoTableViewController.h"
#import "MMCommon.h"
#import "UIImageView+WebCache.h"
#import "GlobalAlert.h"

@interface StartViewController ()

@end

@implementation StartViewController



// 是否支持屏幕旋转
- (BOOL)shouldAutorotate {
    return YES;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
// 支持的旋转方向
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
//UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Load StartViewController");
    //init navigationbar
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    [navBar setBarStyle:UIBarStyleBlack];
    [navBar setTranslucent:YES];
    self.navigationItem.hidesBackButton = YES;
    //[[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0,1);
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"三" style:UIBarButtonItemStyleDone target:self action:@selector(selectRightAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(selectRightAction:)];
    //self.navigationItem.rightBarButtonItem = rightButton;
    UIBarButtonItem *seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStyleDone target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = seteiButton;
    //self.navigationItem.backBarButtonItem.enabled = NO;
    
    //get connect status , request infomation(fomart in xml) of image
    
    thisCtrl = self;
    self.isRetry = YES;
    self.isShowingAlert = NO;
    [self reach:thisCtrl];
    self.connectMessage = [[UIAlertView alloc]
                                   initWithTitle:@"没有检测到可用的网络"
                                   message:@"是否重试？"
                                   delegate:self
                                   cancelButtonTitle:@"取消"
                                   otherButtonTitles:@"重试",nil];
    
    self.elementToParse = [[NSArray alloc] initWithObjects:@"id",@"url",@"title",@"author", nil];
    self.loadxmlTimer = [[NSTimer alloc]init];
    self.isShowingXMLAlert = NO;
    allLoaded = NO;
    
}

-(void)startAlbum{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	
	//HUD.labelText = @"Loading";
	self.HUD.minSize = CGSizeMake(135.f, 135.f);
    [self.HUD showWhileExecuting:@selector(loadXMLTask) onTarget:self withObject:nil animated:YES];

}

-(void)viewDidAppear:(BOOL)animated{
    
    
}



- (void)loadXMLTask {
	// Indeterminate mode
	sleep(1);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //todo
            self.loadxmlTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f  target:self selector:@selector(loadXMLTimeOverAction:) userInfo:nil repeats:NO];
            
            
            
        });
    });
    [self RequestXMLandParse:1 inthisCtl:self];
    
	// Switch to determinate mode
	self.HUD.mode = MBProgressHUDModeDeterminate;
	self.HUD.labelText = @"Loading";
    float progress = 0.01f,rprogress;
	while (([self.photos count] < 21)||(progress <1.0f))
	{
        rprogress = [self.photos count]/21.0f;//real progress
        if(rprogress == 0)
            continue;
        if(progress < rprogress){
            progress = progress + 0.01f;
            self.HUD.progress = progress;
        }
        else
            self.HUD.progress = rprogress;
		usleep(5000);
	}
    //HUD.progress = 1.0f;
    sleep(1);
    ListPhotoTableViewController *albumView = [[ListPhotoTableViewController alloc]init];
    
//    [albumView SetPhotos:photos];
    albumView.photos = self.photos;
    self.timeOverAlert = [[GlobalAlert alloc]init];
    [self.timeOverAlert initGlobalAlert:self.photos waitTime:60.0];
    albumView.timeOverAlert = self.timeOverAlert;
    [self.navigationController pushViewController: albumView animated:NO];
    
//    [MMCommon setPhotosPtr:self->photos];
//    mmTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timerOverAction:) userInfo:nil repeats:NO];
    //HUD.mode = MBProgressHUDModeCustomView;
	//HUD.labelText = @"Completed";
}


//+(void)setPhotosPtr:(NSMutableArray *)photos{
//    photosPtr = photos;
//}




-(void)selectLeftAction:(id)sender
{
    
}

-(void)selectRightAction:(id)sender
{
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    if (buttonIndex == 0) {
        
        NSLog(@"internet not reachable");
//        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0,50,kScreenWidth, 50)];
        label1.font =  [UIFont boldSystemFontOfSize:20];
        label1.text = @"网络无效";
        label1.textColor = [UIColor blackColor];
        [self.view addSubview:label1];
        
    }else if (buttonIndex == 1){
         NSLog(@"retry reach");
        
        [self reach:thisCtrl];
    }
    
}


#pragma AFnetworking status
- (void)reach:(StartViewController *)thisCtl
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown://same as below
                NSLog(@"AFNetworkReachabilityStatusUnknown");
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"AFNetworkReachabilityStatusUnknown Or AFNetworkReachabilityStatusNotReachable");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (thisCtl.isShowingAlert == NO) {
                            thisCtl.isShowingAlert = YES;
                            [[thisCtl connectMessage] show];
                        }
                        
                    });
                });
                //
                break;}
            case AFNetworkReachabilityStatusReachableViaWWAN://same as below
            case AFNetworkReachabilityStatusReachableViaWiFi://
                //connectted succeed
                if (thisCtl.isShowingAlert == YES) {
                    [[thisCtl connectMessage] dismissWithClickedButtonIndex:0 animated:NO];
                }
                
                [thisCtl startAlbum];
                break;
                
            default:
                break;
        }
       
        
        
    }];
}
-(BOOL)parser:(NSString*)string
{
    //系统自带的
    NSXMLParser *par = [[NSXMLParser alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    [par setDelegate:self];//设置NSXMLParser对象的解析方法代理
    return [par parse];//调用代理解析NSXMLParser对象，看解析是否成功   }
    
}

#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
        //NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    if([elementName isEqualToString:@"photos"]) {
        //Initialize the array.
        //在这里初始化用于存储最终解析结果的数组变量,我们是在当遇到Photos根元素时才开始初始化
        self.photos = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:@"photo"]) {
        
        //Initialize the book.
        //当碰到Book元素时，初始化用于存储Photo信息的实例对象aPhoto
        
        self.aPhoto = [[PhotoEntity alloc] init];
        
        //Extract the attribute here.
        //从attributeDict字典中读取photo元素的属性
        
        self.aPhoto.ID = [[attributeDict objectForKey:@"id"] intValue];
        
        NSLog(@"ID:%i", self.aPhoto.ID);
    }
    self.storingFlag = [self.elementToParse containsObject:elementName];  //判断是否存在要存储的对象
    
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"%@",NSStringFromSelector(_cmd) );
    // 当用于存储当前元素的值是空时，则先用值进行初始化赋值
    // 否则就直接追加信息
    if (self.storingFlag) {
        if (!self.currentElementValue) {
            self.currentElementValue = [[NSMutableString alloc] initWithString:string];
        }
        else {
            [self.currentElementValue appendString:string];
        }
    }
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"%@",NSStringFromSelector(_cmd) );
    if ([elementName isEqualToString:@"photo"]) {
        self.aPhoto.isLoaded = NO;
        [self.photos addObject:self.aPhoto];
        self.aPhoto = nil;
    }
    
    if (self.storingFlag) {
        //去掉字符串的空格
        NSString *trimmedString = [self.currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //将字符串置空
        [self.currentElementValue setString:@""];
        if ([elementName isEqualToString:@"id"]) {
            self.aPhoto.ID = [trimmedString intValue];
            //NSLog(@"id :%d",aPhoto.ID);
        }
        if ([elementName isEqualToString:@"url"]) {
            self.aPhoto.url = trimmedString;
            self.aPhoto.image = [[UIImageView alloc]init];

        }
        if ([elementName isEqualToString:@"author"]) {
            self.aPhoto.author = trimmedString;
            //NSLog(@"author :%@",aPhoto.author);
        }
        if ([elementName isEqualToString:@"title"]) {
            self.aPhoto.title = trimmedString;
            //NSLog(@"title :%@",aPhoto.title);
        }
    }
}

//step 5；解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
}
//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
}
-(void)RequestXMLandParse:(NSUInteger)ntimes inthisCtl:(StartViewController *)thisCtl
{
    
    //AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:myURL]; manager.responseSerializer = [AFXMLResponseSerializer new];
    //NSURL *url = [NSURL URLWithString:@"http://cd.dev.vc/ios/album/photo.xml"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test:2014@cd.dev.vc/ios/album/photo.xml"]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f ];
//    NSLog(@"timeoutInterval: %f",[request timeoutInterval]);
    
    
    
    __block bool isRequestOK = YES;
    AFXMLRequestOperation *operation =
    [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        [thisCtl.loadxmlTimer invalidate];
        //NSLog(@"%@",response);
        
        
        //resp.setDateHeader("expires", 0);
        //resp.setHeader("Cache-Control", "no-cache");
        //resp.setHeader("pragma", "no-cache");
        XMLParser.delegate = self;
        [XMLParser setShouldProcessNamespaces:YES];
        BOOL flag = [XMLParser parse];
        if(flag) {
            NSLog(@"解析指定路径的xml文件成功");
        }
        else {
            NSLog(@"解析指定路径的xml文件失败");
        }
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParser) {
        isRequestOK = NO;
        if(ntimes >= 1){
            sleep(1);
            [thisCtl RequestXMLandParse:1 inthisCtl:thisCtl];
        }
        else{
        
        }
//        NSLog(@"%@",error);
    }];
//    if (isRequestOK == YES) {
        [operation start];
//    }
    

}


-(void)loadXMLTimeOverAction:(NSTimer *)timer{
    NSLog(@"loadXMLTimeOverAction");
    if (self.isShowingXMLAlert == NO) {
        self.isShowingXMLAlert = YES;
        UIAlertView *xmlMessage = [[UIAlertView alloc]
                                   initWithTitle:@"提示"
                                   message:@"XML链接获取超时"
                                   delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil];
        [xmlMessage show];
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    NSLog(@"StartViewController dealloc");
    
}

- (void)viewWillDisappear:(BOOL)animated{
//    [mmTimer setFireDate: [NSDate distantFuture]] ;
}
- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"StartViewController disapear");
    self.currentElementValue = nil;
//    self.photos = nil;
    self.aPhoto = nil;
    self.elementToParse = nil;
//    self.elementToParse = nil;
    
}
@end
