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
@synthesize parent, mask, timer;

-(id)init
{
    self = [super init];
    mask = [[[UIImageView alloc] initWithFrame:CGRectMake(-20, 0, 360, 480)] autorelease];
    [self.view addSubview:mask];
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(animated == YES) { return; }
    parent = (FaceViewController *)[self parentViewController];
    [self.view addSubview:[parent subContainer]];
    [self.view bringSubviewToFront:mask];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(animated == YES) { return; }
    ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:parent.faces andDimensions:mask.bounds.size];
    [io setFrames:12];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animate:) userInfo:io repeats:NO];
    [io release];
    UIBarButtonItem *back = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIButtonTypeInfoLight target:parent action:@selector(chooseFaces)] autorelease];
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:parent action:@selector(chooseDestination)] autorelease];
    
    [parent.optionBar setItems:@[back, spacer,done] animated:NO];

}

-(void)animate:(NSTimer *)_timer
{
    ImageOverlay *io = (ImageOverlay *)[_timer userInfo];
    
    if(mask == NULL ) { return; } // we unloaded. stop!
    [mask setImage:[io nextFrame]];
    if([io isLastFrame])
    {
        [self setTimer:[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animate:) userInfo:io repeats:NO]];
    }else{
        [self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animate:) userInfo:io repeats:NO]];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    [mask setImage:nil];
    [parent.subContainer removeFromSuperview];
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

/**
-(id)retain
{
    NSLog(@"O++ %d", [self retainCount]+1);
    return [super retain];
}

-(void)release
{
    NSLog(@"O-- %d", [self retainCount]-1);
    return [super release];
}
**/

-(void)dealloc
{
    [mask release];
    [timer release];
    [super dealloc];
    
}


@end
