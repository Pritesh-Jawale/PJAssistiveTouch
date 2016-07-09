//
//  ViewController.m
//  PJAssitiveTouch
//
//  Created by Pritesh Jawale on 10/17/14.
//  Copyright (c) 2014 Pritesh Jawale. All rights reserved.
//

#import "ViewController.h"
#import "PJAssistiveTouch.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // This is how one can add assitive touch button/view on respective screen/viewcontroller
    [PJAssistiveTouch addAssistiveTouch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
