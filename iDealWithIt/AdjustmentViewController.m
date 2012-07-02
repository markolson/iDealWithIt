//
//  PreviewViewController.m
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "AdjustmentViewController.h"
#import "MBProgressHUD.h"

@interface AdjustmentViewController ()

@end

@implementation AdjustmentViewController
@synthesize parent, tapper, inprogress;

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
    [self.view addGestureRecognizer:tapper];

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
        [self setOverlay];
    }else{
        [inprogress setEye:LeftEye withDictionary:@{@"x": [NSNumber numberWithDouble:tap.x], @"y": [NSNumber numberWithDouble:tap.y]}];
    }
}

-(void)setOverlay
{
    for(UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
        [v release];
    }
    tapper.enabled = NO;
    [inprogress release];
    inprogress = [[iFace alloc] init];
    
    UIBarButtonItem *addFace = [[[UIBarButtonItem alloc] initWithTitle:@"Add Face" style:UIButtonTypeInfoLight target:self action:@selector(addFace)] autorelease];
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:parent action:@selector(chooseGlasses)] autorelease];
    
    [parent.optionBar setItems:@[addFace,spacer,done] animated:NO];

    
    ImageOverlay *io = [[[ImageOverlay alloc] initWithFaces:parent.faces andDimensions:self.view.frame.size] autorelease];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:[io layer]];
    overlay.image = [io layerAtFrame:10 of:10];
    [self.view addSubview:overlay];
    [overlay release];
}

-(void)addFace
{
    
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setOverlay)] autorelease];
    [cancel setTintColor:[UIColor redColor]];
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    [parent.optionBar setItems:@[cancel,spacer] animated:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];

    hud.mode = MBProgressHUDModeText;
	hud.labelText = @"Tap on the left, and then right eye.";
    hud.dimBackground = YES;
	hud.margin = 10.f;
	hud.removeFromSuperViewOnHide = YES;
    
	[hud hide:YES afterDelay:1];
    
    tapper.enabled = YES;
    
}

-(void)dealloc
{
    [super dealloc];
    [tapper release];
    [inprogress release];
    
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
