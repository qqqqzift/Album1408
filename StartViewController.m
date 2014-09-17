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
    [self reach];
    elementToParse = [[NSArray alloc] initWithObjects:@"id",@"url",@"title",@"author", nil];
    
    
    allLoaded = NO;
    
}


-(void)viewDidAppear:(BOOL)animated{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	//HUD.labelText = @"Loading";
	HUD.minSize = CGSizeMake(135.f, 135.f);
    [HUD showWhileExecuting:@selector(loadXMLTask) onTarget:self withObject:nil animated:YES];
    
}



- (void)loadXMLTask {
	// Indeterminate mode
	sleep(1);
   
    [self RequestXMLandParse:1];
    
	// Switch to determinate mode
	HUD.mode = MBProgressHUDModeDeterminate;
	HUD.labelText = @"Loading";
    float progress = 0.01f,rprogress;
	while (([photos count] < 21)||(progress <1.0f))
	{
        rprogress = [photos count]/21.0f;//real progress
        if(rprogress == 0)
            continue;
        if(progress < rprogress){
            progress = progress + 0.01f;
            HUD.progress = progress;
        }
        else
            HUD.progress = rprogress;
		usleep(5000);
	}
    //HUD.progress = 1.0f;
    sleep(1);
    ListPhotoTableViewController *albumView = [[ListPhotoTableViewController alloc]init];
    
//    [albumView SetPhotos:photos];
    albumView.photos = photos;
    [self.navigationController pushViewController: albumView animated:NO];
    
    //HUD.mode = MBProgressHUDModeCustomView;
	//HUD.labelText = @"Completed";
}
-(void)selectLeftAction:(id)sender
{
    
}

-(void)selectRightAction:(id)sender
{
    
}





#pragma AFnetworking status
- (void)reach
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
                
//                
                break;}
            case AFNetworkReachabilityStatusReachableViaWWAN://same as below
            case AFNetworkReachabilityStatusReachableViaWiFi://
                //connectted succeed
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
        photos = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:@"photo"]) {
        
        //Initialize the book.
        //当碰到Book元素时，初始化用于存储Photo信息的实例对象aPhoto
        
        aPhoto = [[PhotoEntity alloc] init];
        
        //Extract the attribute here.
        //从attributeDict字典中读取photo元素的属性
        
        aPhoto.ID = [[attributeDict objectForKey:@"id"] intValue];
        
        NSLog(@"ID:%i", aPhoto.ID);
    }
    storingFlag = [elementToParse containsObject:elementName];  //判断是否存在要存储的对象
    
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"%@",NSStringFromSelector(_cmd) );
    // 当用于存储当前元素的值是空时，则先用值进行初始化赋值
    // 否则就直接追加信息
    if (storingFlag) {
        if (!currentElementValue) {
            currentElementValue = [[NSMutableString alloc] initWithString:string];
        }
        else {
            [currentElementValue appendString:string];
        }
    }
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"%@",NSStringFromSelector(_cmd) );
    if ([elementName isEqualToString:@"photo"]) {
        aPhoto.isLoaded = NO;
        [photos addObject:aPhoto];
        aPhoto = nil;
    }
    
    if (storingFlag) {
        //去掉字符串的空格
        NSString *trimmedString = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //将字符串置空
        [currentElementValue setString:@""];
        if ([elementName isEqualToString:@"id"]) {
            aPhoto.ID = [trimmedString intValue];
            //NSLog(@"id :%d",aPhoto.ID);
        }
        if ([elementName isEqualToString:@"url"]) {
            aPhoto.url = trimmedString;
            aPhoto.image = [[UIImageView alloc]init];

        }
        if ([elementName isEqualToString:@"author"]) {
            aPhoto.author = trimmedString;
            //NSLog(@"author :%@",aPhoto.author);
        }
        if ([elementName isEqualToString:@"title"]) {
            aPhoto.title = trimmedString;
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
-(void)RequestXMLandParse:(NSUInteger)ntimes
{
    
    //AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:myURL]; manager.responseSerializer = [AFXMLResponseSerializer new];
    //NSURL *url = [NSURL URLWithString:@"http://cd.dev.vc/ios/album/photo.xml"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test:2014@cd.dev.vc/ios/album/photo.xml"]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f ];
    NSLog(@"timeoutInterval: %f",[request timeoutInterval]);
    
    
    
    AFXMLRequestOperation *operation =
    [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
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
        if(ntimes > 1)
            [self RequestXMLandParse:(ntimes - 1)];
        
        NSLog(@"%@",error);
    }];
    [operation start];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    NSLog(@"StartViewController dealloc");
    
}


- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"StartViewController dealloc");
    currentElementValue = nil;
    photos = nil;
    aPhoto = nil;
    elementToParse = nil;
    elementToParse = nil;
    
}
@end
