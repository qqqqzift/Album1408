//
//  MMCommon.m
//  AlbumZY
//
//  Created by zhang_ying on 14-8-25.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import "MMCommon.h"

@implementation MMCommon

+(int)sideMargin{
    if(IS_IPHONE5){
        sideMargin = 44;
    }else{
        sideMargin = 0;
    }
    return sideMargin;
}


+(int) kHLineCnt{
    if(IS_IPHONE5){
        kHLineCnt = 8;
    }else{
        kHLineCnt = 6;
    }
    return kHLineCnt;
}
+(void)MMclearCacheSuccess
{
    NSLog(@"Cache cleaned");
}
+(void)MMcleanCache{
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(MMclearCacheSuccess) withObject:nil waitUntilDone:YES];});
}

@end
