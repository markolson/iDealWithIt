//
//  OverlayPickerViewController.m
//  iDealWithIt
//
//  Created by Mark on 7/1/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "OverlayPickerViewController.h"
#import "NSTimer+Blocks.h"
#import "ImageOverlay.h"

@interface OverlayPickerViewController ()

@end

@implementation OverlayPickerViewController
@synthesize parent, overlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:parent.faces andDimensions:overlay.bounds.size];
    [io setFrames:20];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animate:) userInfo:io repeats:NO];
    [io release];
}

-(void)animate:(NSTimer *)timer
{
    ImageOverlay *io = (ImageOverlay *)[timer userInfo];
    overlay.image = [io nextFrame];
    if([io isLastFrame])
    {
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animate:) userInfo:io repeats:NO];
    }else{
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animate:) userInfo:io repeats:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
