//
//  PJiOSAppConsole.m
//  PJiOSAppConsole
//
//  Created by Pritesh Jawale on 10/6/14.
//  Copyright (c) 2014 Pritesh Jawale. All rights reserved.
//

#import "PJiOSAppConsole.h"
static int BUTTONS_COUNT = 7;
static const int kYCONSTANT = 50; // Includes navigation controller height
static const int kYCONSTANTTextView = 90; // Includes navigation controller height
@implementation PJiOSAppConsole{
    CGAffineTransform rotationTransform;
    UIButton *btnShowControls, *btnClearTextView, *btnShowConsole;
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
        [self initPJiOSAppConsoleView];
        [self initSubView];
        [self registerForNotifications];
    }
    return self;
}

#pragma mark - Init View
+ (PJiOSAppConsole *) initPJiOSAppConsole:(UIView *)view{
    static PJiOSAppConsole *iOSConsole = nil;
    @synchronized(self) {
        if(iOSConsole == nil){
            iOSConsole = [[PJiOSAppConsole alloc] initWithView:view];
        }
        [view addSubview:iOSConsole];
    }
	return iOSConsole;
}

- (id)initWithView:(UIView *)view {
	NSAssert(view, @"View should not be nil.");
    parentView = view;
	id initialised = [self initWithFrame:view.bounds];
    return initialised;
}
- (void) initPJiOSAppConsoleView{
    [self setFrame:CGRectMake(parentView.frame.origin.x, parentView.frame.origin.y+kYCONSTANT, parentView.frame.size.width, parentView.frame.size.height)];
    [self setBackgroundColor:[UIColor clearColor]];
    self.alpha = 1.0f;
    [parentView bringSubviewToFront:self];
}

- (void) initSubView{
    
    // Show console button ...
    btnShowConsole = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnShowConsole.frame = CGRectMake(30,kYCONSTANT,90,90);
    [btnShowConsole setBackgroundColor:[UIColor redColor]];
    [btnShowConsole setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnShowConsole.tag = 100;
    [btnShowConsole setTitle:@"Console" forState:UIControlStateNormal];
    [btnShowConsole addTarget:self action:@selector(showConsole:) forControlEvents:UIControlEventTouchUpInside];
    btnShowConsole.layer.cornerRadius=45;
    btnShowConsole.center = parentView.center;
    [parentView addSubview:btnShowConsole];
    
    // Pan gesture
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [btnShowConsole addGestureRecognizer:panGesture];
    
    // Circular frame buttons
    arrButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i < BUTTONS_COUNT; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [arrButtons addObject:button];
        [parentView addSubview:button];
    }
    
}


#pragma mark - Button events
- (void) showConsole: (id) sender{
    isViewDisplayed = !isViewDisplayed;
    [self setHidden:YES];
    
    float curAngle = 0;
    float incAngle = ( 360.0/(BUTTONS_COUNT) )*M_PI/180.0;
    CGPoint circleCenter = CGPointMake(btnShowConsole.center.x, btnShowConsole.center.y); /* given center */
    float circleRadius = 100; /* given radius */
    
    if(!isViewDisplayed){
        
        for (UIButton *btn in arrButtons) {
            CGPoint buttonCenter;
            buttonCenter.x = circleCenter.x + cos(curAngle)*circleRadius;
            buttonCenter.y = circleCenter.y + sin(curAngle)*circleRadius;
            [btn setFrame:CGRectMake(buttonCenter.x, buttonCenter.y, 50, 50)];
            [[btn layer] setCornerRadius:25];
            //[btn setTransform:CGAffineTransformRotate(btn.transform, curAngle)];
            [btn setCenter:buttonCenter];
            [btn setBackgroundColor:[UIColor redColor]];
            [btn setHidden:NO];
            
            curAngle += incAngle;
        }
    }else{
        for (UIButton *btn in arrButtons) {
            CGPoint buttonCenter;
            buttonCenter.x = circleCenter.x + cos(curAngle)*circleRadius;
            buttonCenter.y = circleCenter.y + sin(curAngle)*circleRadius;
            [btn setFrame:CGRectMake(buttonCenter.x, buttonCenter.y, 50, 50)];
            [[btn layer] setCornerRadius:25];
            //[btn setTransform:CGAffineTransformRotate(btn.transform, curAngle)];
            [btn setCenter:buttonCenter];
            [btn setBackgroundColor:[UIColor redColor]];
            [btn setHidden:YES];
            
            curAngle += incAngle;
        }
    }
}
- (void) moveButton: (id) sender{
    
}

#pragma mark - Log methods

+ (void) NSLog:(NSString *)strLog forView:(UIView *) view{
    PJiOSAppConsole *temp = [PJiOSAppConsole initPJiOSAppConsole:view];
    [temp addShowConsole:view];
}


- (void) addShowConsole:(UIView *)view{
    [view addSubview:btnShowConsole];
}
// Setting boundary for Console button
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
            [self showConsole:nil];
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
    CGRect rec = btnShowConsole.frame;
    CGRect mainView = parentView.frame;
    rec = btnShowConsole.frame;
    if( rec.origin.x < mainView.origin.x )
        rec.origin.x = mainView.origin.x;
    
    if( rec.origin.y < mainView.origin.y )
        rec.origin.y = mainView.origin.y;
    
    if( rec.origin.x + rec.size.width > mainView.origin.x + mainView.size.width )
        rec.origin.x = mainView.origin.x + mainView.size.width - rec.size.width;
    
    if( rec.origin.y + rec.size.height > mainView.origin.y + mainView.size.height )
        rec.origin.y = mainView.origin.y + mainView.size.height - rec.size.height;
    
    btnShowConsole.frame = rec;

    // Adjusting textview on screen as per orientation change
    CGRect frame = txtViewData.frame;
    frame.size.height = mainView.size.height-(kYCONSTANTTextView);
    frame.size.width = parentView.frame.size.width;
    txtViewData.frame = frame;
}

@end
