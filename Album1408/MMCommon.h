//
//  MMCommon.h
//  AlbumZY
//
//  Created by zhang_ying on 14-8-25.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ccp(__X__,__Y__)                CGPointMake((__X__),__Y__)
#define ccpZero                            CGPointZero
#define ccpMax                            ccp(1.0f, 1.0f)
#define ccpHalf(size)                    ccp(size.width/2,size.height/2)
#define kScreenWidth                        ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight                       ([UIScreen mainScreen].bounds.size.height)

#define kVLineCnt                            4

#define kListImageWidth                   66
#define kListImageHeight                  66
#define kImageWidth                         70 //UITableViewCell里面图片的宽度
#define kImageHeight                        70 //UITableViewCell里面图片的高度
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define kLandScapeNone                          0
#define kLandScapeLeft                          1
#define kLandScapeRight                         2
#define kLandScapeTop                           3
#define kLandScapeBottom                        4
#define kEPS                                    0.001
#define kPhotoCnt                               21
#define kToolbarHeight                          50
#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
//缩略图画面

static int sideMargin;              //4 inch screen is 88 wider than 3.5 inch screen
static int kHLineCnt;
@interface MMCommon : NSObject
+ (int)sideMargin;
+(int) kHLineCnt;
+(void)MMcleanCache;
+(void)MMclearCacheSuccess;






//sp in this program



//



@end
