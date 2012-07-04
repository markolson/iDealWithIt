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
@synthesize parent, overlay, timer;

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
    
    if(overlay == NULL ) { return; } // we unloaded. stop!
    [overlay setImage:[io nextFrame]];
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

-(void)dealloc
{
    [overlay release];
    [parent release];
    [timer release];
    [super dealloc];
    
}


@end
