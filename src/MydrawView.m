//
//  MydrawView.m
//  Album1408
//
//  Created by zhang_ying on 14-9-5.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import "MydrawView.h"
#import "PhotoEntity.h"


@interface MydrawView ()
{
    NSMutableArray * imgArray;
}
@end

@implementation MydrawView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/








- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imgArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}


-(void)loadPhoto{

    for (int i = 0; i<[_photos count]; i++) {
        UIImageView * timage = [(PhotoEntity *)[_photos objectAtIndex:i] egoImage];
        UIImage * objimage = timage.image;
        [imgArray addObject:objimage];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextRotateCTM(context, M_PI);
    CGContextTranslateCTM(context, -320, -480*10);
    for(int i = 0; i< 10 ;i++)
    {
        UIImage * img = [imgArray objectAtIndex:i];
        CGImageRef image = img.CGImage;
        CGRect touchRect = CGRectMake(0, 480*i, 320, 480);
        if (image != nil) {
            CGContextDrawImage(context, touchRect, image);
        }
    }
    CGContextRestoreGState(context);
}
@end
