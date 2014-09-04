//
//  UITableGridViewCell.m
//  igridviewdemo
//
//  Created by vincent_guo on 13-12-12.
//  Copyright (c) 2013年 vincent_guo. All rights reserved.
//

#import "UITableGridViewCell.h"
#import "UIImageButton.h"
#import "MMCommon.h"
#import "PhotoEntity.h"
#import "ListPhotoLViewController.h"
#import "PhotoViewController.h"


@implementation UITableGridViewCell
//-(void) setCellByRow:(int)row  allele:(NSArray *)photos lineCnt:(int)lcnt oFlag:(int)oflag{
//    NSMutableArray *array = [NSMutableArray array];
//    float indent;
//    if ((oflag == kLandScapeTop)||
//        (oflag == kLandScapeBottom)){
//        indent = (kScreenWidth - kImageWidth * lcnt)/(lcnt +1.0);
//    }else if((oflag == kLandScapeRight)||
//             (oflag == kLandScapeLeft)){
//        indent = (kScreenHeight - kImageWidth * lcnt)/(lcnt +1.0);
//    
//    }else{
//        indent =5;
//    }
//    for (int i=0; i<lcnt; i++) {
//        if ((row*lcnt +i) >= [photos count]) {
//            break;
//        }
//        //自定义继续UIButton的UIImageButton 里面只是加了2个row和column属性
//        UIImageButton *button = [UIImageButton buttonWithType:UIButtonTypeCustom];
//        button.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
//        button.center = CGPointMake((1 + i) * indent+ kImageWidth *( 0.5 + i) , 5 + kImageHeight * 0.5);
//        //button.column = i;
//        [button setValue:[NSNumber numberWithInt:[(PhotoEntity *)[photos objectAtIndex:(row*lcnt +i)] ID]]forKey:@"ID"];
//        [button setValue:[NSNumber numberWithInt:i] forKey:@"column"];
//        
//        
//        UIImageView * timage = [(PhotoEntity *)[photos objectAtIndex:(row*lcnt +i)] egoImage];
//        
//        [button setBackgroundImage:timage.image forState:UIControlStateNormal];
//        
//        [button addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.contentView addSubview:button];
//        [array addObject:button];
//    }
//
//    [self setValue:array forKey:@"buttons"];
//    
//
//}
//
//-(void) setTopCellByRow:(int)row  allele:(NSArray *)photos{
//    [self setCellByRow:row allele:photos lineCnt:kVLineCnt oFlag:kLandScapeTop];
//}
//-(void) setRightCellByRow:(int)row  allele:(NSArray *)photos{
//    [self setCellByRow:row allele:photos lineCnt:[MMCommon kHLineCnt] oFlag:kLandScapeRight];
//
//}


//-(void)imageItemClick:(UIImageButton *)button{
//
//    NSLog(@"SSSSSSSSSSSSSSSSS");
////    PhotoViewController *photoView = [[PhotoViewController alloc]init];
////    photoView.currentImageId = button.ID;
////    [photoView SetPhoto:photos];
////    [sharedNavi pushViewController: photoView animated:NO];
//}

@end
