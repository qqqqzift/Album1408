//
//  GlobalAlert.m
//  Album1408
//
//  Created by zhang_ying on 14-9-18.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import "GlobalAlert.h"
#import "MMCommon.h"
#import "PhotoEntity.h"

@implementation GlobalAlert



-(id)init
{
    if(self=[super init])
    {
        
    }
    return self;
}


-(BOOL)timerNotSet{
    if (self.mcountTimer == nil) {
        return YES;
    }else{
        return NO;
    }
}

-(void)initGlobalAlert:(NSMutableArray *)photos waitTime:(float)timeLeft{
    


    self.mphotoPtr = photos;
    if (timeLeft > 5.0f)
        self.mTimeLeft = timeLeft;
    else
        self.mTimeLeft = 5.0f;
    self.mAlert = nil;
}
-(void)pauseTimer{
    NSLog(@"[NSDate distantFuture]:%@",[NSDate distantFuture]);
    [self.mcountTimer  setFireDate:[NSDate distantFuture]];

}
-(void)resumeTimer{
    NSLog(@"[NSDate distantPast]:%@",[NSDate distantPast]);
    [self.mcountTimer setFireDate:[NSDate distantPast]];

}
-(void)updateTimeLeft:(int)pastedTime{
    self.mTimeLeft = self.mTimeLeft - pastedTime;
    if (self.mTimeLeft < 0) {
        self.mTimeLeft  = 1.0;
    }
}
-(void)timerAction{
    NSLog(@"timerOverAction:timerAction");

    self.mcountTimer = [NSTimer scheduledTimerWithTimeInterval:self.mTimeLeft target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
    
}
-(void)timerAction:(NSTimer *)timer{
    NSLog(@"timerOverAction:timerAction(timer)");
  [self ShowTimerOverAlert];
    
}
-(float)getMTimeLeft{
    return self.mTimeLeft;

}

-(bool)checkAllIsLoaded{
    NSLog(@"checkAllIsLoaded");
    for (PhotoEntity *aphoto in self.mphotoPtr) {
        if ([aphoto isLoaded] == NO ) {
            return NO;
        }
    }
    return YES;

}

    
-(void)ShowLoadXMLTimerOverAlert{
    NSLog(@"ShowLoadXMLTimerOverAlert");
    UIAlertView *pageMessage = [[UIAlertView alloc]
                                initWithTitle:@"提示"
                                message:@"图片信息读取超时"
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
    
    [pageMessage show];
    
}


-(void)ShowTimerOverAlert{
    NSLog(@"timerOverAction:ShowTimerOverAlert");
    UIAlertView *pageMessage = [[UIAlertView alloc]
                                initWithTitle:@"提示"
                                message:@"图片读取超时"
                                delegate:self
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
    if (self.checkAllIsLoaded == YES) {
//        [pageMessage setMessage:@"all loaded"];
    }else{
        [pageMessage setMessage:@"图片读取超时"];
        
    }
    [pageMessage show];
    allLoaded = YES;
}
@end
