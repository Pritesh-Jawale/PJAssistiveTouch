//
//  PJAssistiveTouch.h
//  PJAssitiveTouch
//
//  Created by Pritesh Jawale on 10/18/14.
//  Copyright (c) 2014 Pritesh Jawale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJAssistiveTouch : UIView <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *arrBtnTitle;
+ (PJAssistiveTouch *) initPJAssistiveTouch:(UIView *)view;
+ (void) addAssistiveTouch;

@end
