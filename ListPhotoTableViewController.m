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
#import "UIImage+UIImageExt.h"
@interface ListPhotoTableViewController ()

@end

@implementation ListPhotoTableViewController






- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            self.sOrientation = kLandScapeTop;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            self.sOrientation = kLandScapeRight;
            break;
        default:;
            self.sOrientation = kLandScapeTop;
            break;
            
            
    }
    NSLog(@"Reload call");
    [self.tableView reloadData];
}

-(void)selectRightAction:(id)sender
{
//    [loadTimer invalidate];
//    loadTimer = nil;
    ListPhotoLViewController *albumView = [[ListPhotoLViewController alloc]init];
    
//    [albumView SetPhotos:_photos];
    albumView.photos = [self photos];
    albumView.sOrientation = self.sOrientation;
    
    [self.navigationController pushViewController: albumView animated:YES];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if (kLandScapeNone == self.sOrientation) {
            self.sOrientation = kLandScapeTop;
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
    
    
//    loadTimer = [NSTimer scheduledTimerWithTimeInterval:0.5  target:self selector:@selector(loadPicture:) userInfo:nil repeats:YES];
}


//-(void)loadPicture:(NSTimer *)timer{
//    
//    if ([_photos count] >=  kPhotoCnt) {
//        [self.tableView reloadData];
//    }else{
//    
//        [NSTimer scheduledTimerWithTimeInterval:0.5  target:self selector:@selector(stopTimer:) userInfo:nil repeats:NO];
//    }
//    
//}

//-(void)stopTimer:(NSTimer *)timer{
//    [loadTimer invalidate];
//    loadTimer = nil;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning in ListPhotoTableViewController");
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
//    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
//    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
    
    cell.textLabel.frame = CGRectMake(0, 60, 100, 40);
    [[_photos objectAtIndex:indexPath.row] url];
    //images_中保存了各单元中显示用图片
//    UIImageView * timage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,kListImageWidth,kListImageHeight)];
    
    __weak PhotoEntity * thisphoto = (PhotoEntity *)[self.photos objectAtIndex:(indexPath.row)];
    __weak UITableView *thistable;
    thisphoto.image.backgroundColor = [UIColor blackColor];
    if ([thisphoto isLoaded] == YES) {
        thisphoto.image.frame = CGRectMake(0,0,kListImageWidth,kListImageHeight);
        [cell.contentView addSubview:thisphoto.image];
        [thistable reloadData];
    }else{
        [thisphoto.image setImage:[UIImage imageNamed:@"Block_01_00.png"]];
        thisphoto.image.frame = CGRectMake(0,0,kListImageWidth,kListImageHeight);
        [cell.contentView addSubview:thisphoto.image];
        [thistable reloadData];
        [thisphoto.image sd_setImageWithURL:[NSURL URLWithString:[(PhotoEntity *)[_photos objectAtIndex:indexPath.row] url]]
                  placeholderImage:[UIImage imageNamed:@"Block_01_00.png"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             thisphoto.isLoaded = YES;
                             [thisphoto.image setImage:image];
                             thisphoto.image.frame = CGRectMake(0,0,kListImageWidth,kListImageHeight);
                             [cell.contentView addSubview:thisphoto.image];
                             [thistable reloadData];
                         }];
        
    }
    
    
    
//    [timage setFrame:CGRectMake(0, 0, kListImageWidth, kListImageHeight)];
    
    
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


-(void)viewDidDisappear:(BOOL)animated
{
    
    
    
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
//    [loadTimer invalidate];
//    loadTimer = nil;
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


-(void)dealloc{
    NSLog(@"ListPhotoTableViewController dealloc");
    
}
@end
