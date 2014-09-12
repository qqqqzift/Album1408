//
//  ListPhotoTableViewController.m
//  Album1408
//
//  Created by zhang_ying on 14-8-27.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import "ListPhotoTableViewController.h"
#import "PhotoScrollViewController.h"
#import "ListPhotoLViewController.h"
#import "AFImageRequestOperation.h"
#import "PhotoViewController.h"
#import "AFNetworking.h"
#import "PhotoEntity.h"
#import "MMCommon.h"
#import "UIImageView+WebCache.h"
@interface ListPhotoTableViewController ()

@end

@implementation ListPhotoTableViewController


@synthesize  sOrientation;

//-(void) SetPhotos:(NSMutableArray*)photolist{
//    photos = [[NSMutableArray alloc] initWithArray:photolist];
//}

/*
-(void) SendLoadImageRequest{
    for (PhotoEntity *photo in photos) {
        if(photo.isLoaded == NO){
 
            Block_01_00.png
            
            photo.EGOImageLoader = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
            _imageView.imageURL = [NSURL URLWithString:@"http://i0.sinaimg.cn/ent/s/m/2011-08-19/U3904P28T3D3391507F329DT20110819143720.jpg"];
            _imageView.frame = CGRectMake(60, 30, 200, 400);
            
 
            
            
            NSLog(@"%@",photo.url);
            if([self GetImage:photo.url  ID:photo.ID]==YES){
                photo.isLoaded = YES;
                [self.tableView reloadData];
            }
        }
    }
}
*/
/*
-(BOOL)GetImage:(NSString *)url ID:(int)vID{
    __block BOOL isDone = NO;
    __block int tId = vID;
    [[photos objectAtIndex:tId]setImageURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        
        isDone = YES;
        NSLog(@"loadimage%d,success",isDone);
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        isDone = NO;
        NSLog(@"loadimage%d,failed",isDone);
        NSLog(@"Error %@",error);
    }];
    
    [operation start];
    NSLog(@"loadimage%d",isDone);
    return isDone;
}
*/

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            sOrientation = kLandScapeTop;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            sOrientation = kLandScapeRight;
            break;
        default:;
            sOrientation = kLandScapeTop;
            break;
            
            
    }
    NSLog(@"Reload call");
    [self.tableView reloadData];
}

-(void)selectRightAction:(id)sender
{
    [loadTimer invalidate];
    loadTimer = nil;
    ListPhotoLViewController *albumView = [[ListPhotoLViewController alloc]init];
    
//    [albumView SetPhotos:_photos];
    albumView.photos = [self photos];
    albumView.sOrientation = sOrientation;
    
    [self.navigationController pushViewController: albumView animated:YES];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if (kLandScapeNone == sOrientation) {
            sOrientation = kLandScapeTop;
        }
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem.titleView setBackgroundColor:[UIColor blackColor]];
    self.navigationItem.hidesBackButton = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTitle:@"アルバム"];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor blackColor], NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *seteiButton = [[UIBarButtonItem alloc] initWithTitle:@"縮略図" style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = seteiButton;
    
    
    
    self.wantsFullScreenLayout = YES;
    
    
    loadTimer = [NSTimer scheduledTimerWithTimeInterval:0.5  target:self selector:@selector(loadPicture:) userInfo:nil repeats:YES];
}


-(void)loadPicture:(NSTimer *)timer{
    
    if ([_photos count] >=  kPhotoCnt) {
        [self.tableView reloadData];
    }else{
    
        [NSTimer scheduledTimerWithTimeInterval:0.5  target:self selector:@selector(stopTimer:) userInfo:nil repeats:NO];
    }
    
}

-(void)stopTimer:(NSTimer *)timer{
    [loadTimer invalidate];
    loadTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_photos count];
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIndentifier = @"style-subtitle";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIndentifier];
    }
    // Configure the cell...
    //dataSource_中保存有各单元显示用字符串
    cell.textLabel.text = [@"    " stringByAppendingString: [[_photos objectAtIndex:indexPath.row] title]];
    
    
    ;
    cell.textLabel.frame = CGRectMake(0, 60, 100, 40);
    [[_photos objectAtIndex:indexPath.row] url];
    //images_中保存了各单元中显示用图片
    //UIImageView * timage =[[UIImageView alloc]initWithImage: [[EGOImageLoader sharedImageLoader]imageForURL:[NSURL URLWithString:[(PhotoEntity *)[photos objectAtIndex:indexPath.row] url]] shouldLoadWithObserver:nil]];
    UIImageView * timage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,kListImageWidth,kListImageHeight)];
    [timage sd_setImageWithURL:[NSURL URLWithString:[(PhotoEntity *)[_photos objectAtIndex:indexPath.row] url]]
        placeholderImage:[UIImage imageNamed:@"Block_01_00.png"]];
    
    
//    [timage setFrame:CGRectMake(0, 0, kListImageWidth, kListImageHeight)];
    [cell.contentView addSubview:timage];
    
    //[cell.contentView ]
    //cel[.imageView = timage;
//    if ([[photos objectAtIndex:indexPath.row] isLoaded]) {
//        cell.imageView.image = [photos objectAtIndex:indexPath.row];
//    }else{
//        cell.imageView.image = labelImage;
//    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark Table Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger indent = 4;
    return indent;
}
//- (void)tableView:(UITableView*)tableView
//accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath
//{
//    //UIKitPrjCellWithDetail是另外创建的详细画面
//    NSLog(@"%ld",(long)indexPath.row);
//    NSLog(@"accessoryButtonTappedForRowWithIndexPath");
//    //UIViewController* viewController = [[UIKitPrjCellWithDetail alloc] init];
//    //[self.navigationController pushViewController:viewController animated:YES];
//
//}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //NSLog(@"didSelectRowAtIndexPath:%ld",(long)indexPath.row);
    [loadTimer invalidate];
    loadTimer = nil;
    PhotoScrollViewController *photoView = [[PhotoScrollViewController alloc]init];
    photoView.currentImageId = [[_photos objectAtIndex:indexPath.row] ID];
    photoView.photos = [self photos];
    photoView.islastpageList = YES;
    photoView.sOrientation = [self sOrientation];
    [self.navigationController pushViewController: photoView animated:YES];
}

//

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kListImageHeight+1;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setToolbarHidden:YES animated:NO];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
@end
