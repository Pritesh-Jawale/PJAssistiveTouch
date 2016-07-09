//
//  PJAssistiveTouch.m
//  PJAssitiveTouch
//
//  Created by Pritesh Jawale on 10/18/14.
//  Copyright (c) 2014 Pritesh Jawale. All rights reserved.
//

#import "PJAssistiveTouch.h"
static int BUTTONS_COUNT = 4;
static const int kYCONSTANT = 50; // Includes navigation controller height
static const int kYCONSTANTTextView = 90; // Includes navigation controller height
@implementation PJAssistiveTouch{
    CGAffineTransform rotationTransform;
    UIButton *btnShowAssistive;
    UITextView *txtViewData;
    UIView *parentView;
    NSString *strCompleteLogForView;
    UIPanGestureRecognizer *panGesture;
    NSMutableArray *arrButtons;
}
BOOL isViewDisplayed = NO;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initPJAssistiveTouchView];
        [self initSubView];
        [self registerForNotifications];
    }
    return self;
}

#pragma mark - Initialization
+ (PJAssistiveTouch *) initPJAssistiveTouch:(UIView *)view{
    static PJAssistiveTouch *iOSAssistiveTouch = nil;
    @synchronized(self) {
        if(iOSAssistiveTouch == nil){
            iOSAssistiveTouch = [[PJAssistiveTouch alloc] initWithView:view];
        }
        [view addSubview:iOSAssistiveTouch];
    }
	return iOSAssistiveTouch;
}

- (id)initWithView:(UIView *)view {
	NSAssert(view, @"View should not be nil.");
    parentView = view;
	id initialised = [self initWithFrame:view.bounds];
    return initialised;
}
- (void) initPJAssistiveTouchView{
    [self setFrame:CGRectMake(parentView.frame.origin.x, parentView.frame.origin.y+kYCONSTANT, parentView.frame.size.width, parentView.frame.size.height)];
    [self setBackgroundColor:[UIColor clearColor]];
    self.alpha = 1.0f;
    [parentView bringSubviewToFront:self];
}

- (void) initSubView{
    self.arrBtnTitle = [[NSMutableArray alloc] initWithObjects:@"AboutUs",@"Contact",@"Email", @"Call", nil];
    
    // Show console button ...
    [self initAssistiveButton];
    
    // Pan gesture
    [self initPanGesture];
    
    // Circular frame buttons
    arrButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i < BUTTONS_COUNT; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button setTitle:[NSString stringWithFormat:@"%@", [self.arrBtnTitle objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
        [arrButtons addObject:button];
        [parentView addSubview:button];
    }
    
}

#pragma mark - Assistive button init
- (void) initAssistiveButton {
    btnShowAssistive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnShowAssistive.frame = CGRectMake(30,kYCONSTANT,90,90);
    [btnShowAssistive setBackgroundColor:[UIColor redColor]];
    [btnShowAssistive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShowAssistive.tag = 100;
    [btnShowAssistive setTitle:@"Touch Me" forState:UIControlStateNormal];
    [btnShowAssistive addTarget:self action:@selector(showAssistive:) forControlEvents:UIControlEventTouchUpInside];
    btnShowAssistive.layer.cornerRadius=45;
    btnShowAssistive.center = parentView.center;
    [btnShowAssistive.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
    [parentView addSubview:btnShowAssistive];
}

#pragma mark - Add pan gesture
- (void) initPanGesture{
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [btnShowAssistive addGestureRecognizer:panGesture];
}

#pragma mark - Button events
- (void) showAssistive: (id) sender{
    [btnShowAssistive setBackgroundColor:[UIColor grayColor]];
    
    isViewDisplayed = !isViewDisplayed;
    [self setHidden:YES];
    
    float curAngle = 0;
    float incAngle = ( 360.0/(BUTTONS_COUNT) )*M_PI/180.0;
    CGPoint circleCenter = CGPointMake(btnShowAssistive.center.x, btnShowAssistive.center.y); /* given center */
    float circleRadius = 100; /* given radius */
    
    for (UIButton *btn in arrButtons) {
        CGPoint buttonCenter;
        buttonCenter.x = circleCenter.x + cos(curAngle)*circleRadius;
        buttonCenter.y = circleCenter.y + sin(curAngle)*circleRadius;
        [btn setFrame:CGRectMake(buttonCenter.x, buttonCenter.y, 50, 50)];
        [[btn layer] setCornerRadius:25];
        //[btn setTransform:CGAffineTransformRotate(btn.transform, curAngle)];
        [btn setCenter:buttonCenter];
        [btn setBackgroundColor:[UIColor redColor]];
        
        if(!isViewDisplayed){
            [btn setHidden:NO];
        }else{
            [btnShowAssistive setBackgroundColor:[UIColor redColor]];
            [btn setHidden:YES];
        }
        
        curAngle += incAngle;
    }
}
- (void) buttonAction: (id) sender{
    UIButton *btnSelected = (UIButton *) sender;
    NSLog(@"****  Selected Button with tag %ld", (long)btnSelected.tag);
}

#pragma mark - Log methods

+ (void) addAssistiveTouch{
    UIView *baseView = [[[UIApplication sharedApplication] delegate] window];
    PJAssistiveTouch *temp = [PJAssistiveTouch initPJAssistiveTouch:baseView];
    [temp addAssistive:baseView];
}

- (void) addAssistive:(UIView *)view{
    [view addSubview:btnShowAssistive];
}

// Setting boundary for Assitive button
- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    CGPoint movement;
    
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect rec = recognizer.view.frame;
        CGRect mainView = parentView.frame;
        if((rec.origin.x >= mainView.origin.x && (rec.origin.x + rec.size.width <= mainView.origin.x + mainView.size.width)) && (rec.origin.y >= mainView.origin.y && (rec.origin.y + rec.size.height <= mainView.origin.y + mainView.size.height)))
        {
            CGPoint translation = [recognizer translationInView:recognizer.view.superview];
            movement = translation;
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            rec = recognizer.view.frame;
            
            if( rec.origin.x < mainView.origin.x )
                rec.origin.x = mainView.origin.x;
            
            if( rec.origin.y < mainView.origin.y )
                rec.origin.y = mainView.origin.y;
            
            if( rec.origin.x + rec.size.width > mainView.origin.x + mainView.size.width )
                rec.origin.x = mainView.origin.x + mainView.size.width - rec.size.width;
            
            if( rec.origin.y + rec.size.height > mainView.origin.y + mainView.size.height )
                rec.origin.y = mainView.origin.y + mainView.size.height - rec.size.height;
            
            recognizer.view.frame = rec;
            
            [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
            
            // Hiding Button again...
            isViewDisplayed = YES;
            [self showAssistive:nil];
        }
    }
    
}
#pragma mark - Notifications

- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    // Adjusting "Console" button on screen as per orientation change
    CGRect rec = btnShowAssistive.frame;
    CGRect mainView = parentView.frame;
    rec = btnShowAssistive.frame;
    if( rec.origin.x < mainView.origin.x )
        rec.origin.x = mainView.origin.x;
    
    if( rec.origin.y < mainView.origin.y )
        rec.origin.y = mainView.origin.y;
    
    if( rec.origin.x + rec.size.width > mainView.origin.x + mainView.size.width )
        rec.origin.x = mainView.origin.x + mainView.size.width - rec.size.width;
    
    if( rec.origin.y + rec.size.height > mainView.origin.y + mainView.size.height )
        rec.origin.y = mainView.origin.y + mainView.size.height - rec.size.height;
    
    btnShowAssistive.frame = rec;
    
    // Adjusting textview on screen as per orientation change
    CGRect frame = txtViewData.frame;
    frame.size.height = mainView.size.height-(kYCONSTANTTextView);
    frame.size.width = parentView.frame.size.width;
    txtViewData.frame = frame;
}

@end