//
//  GlobalAlert.h
//  Album1408
//
//  Created by zhang_ying on 14-9-18.
//  Copyright (c) 2014年 zhang_ying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalAlert : NSObject
{
    
    
    
}

@property (atomic,strong)UIAlertView *mAlert;
@property (atomic,assign)float mTimeLeft;
@property (atomic,strong)NSMutableArray *mphotoPtr;
@property (atomic,strong)NSTimer *mcountTimer;
-(void)updateTimeLeft:(int)pastedTime;
-(void)pauseTimer;
-(void)resumeTimer;
-(BOOL)timerNotSet;
-(void)timerAction;
-(float)getMTimeLeft;
-(void)ShowLoadXMLTimerOverAlert;

-(void)initGlobalAlert:(NSMutableArray *)photos waitTime:(float)timeLeft;
@end
