//
//  MyViewController.m
//  Album1408
//
//  Created by zhang_ying on 14-9-5.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import "MyViewController.h"
#import "MydrawView.h"
@interface MyViewController ()

@end
@interface MyViewController ()
{
    UIScrollView *scroll;
    MydrawView * imageView;
}
@end
@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/











- (void)loadView {
    
    scroll = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.delegate = self;
    imageView = [[MydrawView alloc] initWithFrame:scroll.frame];
    imageView.photos = [self photos];
    [imageView loadPhoto];
    scroll.contentSize = CGSizeMake(320,480*10);
    imageView.frame = CGRectMake(0, 0, 320, 480*10);
    [scroll addSubview:imageView];
    scroll.minimumZoomScale = 1.0;
    scroll.maximumZoomScale = 3.0;
    [scroll setZoomScale:scroll.minimumZoomScale];
    self.view = scroll;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}



@end
