//
//  PreviewViewController.m
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "AdjustmentViewController.h"
#import "MBProgressHUD.h"
#import "FaceViewController.h"

@interface AdjustmentViewController ()

@end

@implementation AdjustmentViewController
@synthesize parent, tapper, inprogress, hud;

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
}

-(void)viewDidAppear:(BOOL)animated
{
    
    tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapper.numberOfTapsRequired = 1;
    tapper.numberOfTouchesRequired = 1;
    
    if(self.parent)
    {
        if([parent.faces count] > 0)
        {
            [self setOverlay];
        }

    }else{
        [NSException raise:@"Improper Initialization" format:@"Parent of PreviewController not set in time for viewDidAppear"];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    CGPoint tap = [sender locationInView:self.view];
    if([inprogress hasEye:LeftEye])
    {
        [inprogress setEye:RightEye withDictionary:@{@"x": [NSNumber numberWithDouble:tap.x], @"y": [NSNumber numberWithDouble:tap.y]}];
        [parent.faces addObject:inprogress];
        [TestFlight passCheckpoint:@"Added face"];
        [self setOverlay];
    }else{
        [inprogress setEye:LeftEye withDictionary:@{@"x": [NSNumber numberWithDouble:tap.x], @"y": [NSNumber numberWithDouble:tap.y]}];
    }
}

-(void)setOverlay
{
    for(UIView *v in self.view.subviews)
    {
        if([v isKindOfClass:[UIImageView class]])
        {
            [v removeFromSuperview];
            [v release];
        }
    }
    
    [self.view removeGestureRecognizer:tapper];
    [inprogress release];
    inprogress = [[iFace alloc] init];
    
    UIBarButtonItem *addFaceButton = [[[UIBarButtonItem alloc] initWithTitle:@"Add Face" style:UIButtonTypeInfoLight target:self action:@selector(addFace)] autorelease];
    //UIBarButtonSystemItemAdd
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:parent action:@selector(chooseGlasses)] autorelease];
    
    [parent.optionBar setItems:@[addFaceButton,spacer,done] animated:NO];

    
    ImageOverlay *io = [[[ImageOverlay alloc] initWithFaces:parent.faces andDimensions:self.view.frame.size] autorelease];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:[io layer]];
    [overlay setImage:[io layerAtFrame:10 of:10]];
    [self.view addSubview:overlay];
}

-(void)addFace
{
    
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setOverlay)] autorelease];
    [cancel setTintColor:[UIColor redColor]];
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    [parent.optionBar setItems:@[cancel,spacer] animated:NO];
    
    [self.view addGestureRecognizer:tapper];

    if(![MBProgressHUD HUDForView:self.view])
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Tap on the left, and then right eye.";
        hud.dimBackground = YES;
        hud.margin = 10.f;
    }

    [hud hide:YES afterDelay:1.0];
    
}

-(void)dealloc
{
    [tapper release];
    [parent release];
    [inprogress release];
    [super dealloc];
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
