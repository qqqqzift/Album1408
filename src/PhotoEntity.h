//
//  PhotoEntity.h
//  Album1408
//
//  Created by zhang_ying on 14-8-26.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhotoEntity : NSObject

@property int ID;
@property NSString *url;
@property NSString *title;
@property NSString *author;
@property __block bool isLoaded;

@property UIImageView *image;
@end
