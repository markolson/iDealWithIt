//
//  PreviewViewController.m
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "PreviewViewController.h"
#import "MBProgressHUD.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController
@synthesize parent, imageView, tapper, inprogress;

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
    tapper.numberOfTouchesRequired = 1;    [self.view addGestureRecognizer:tapper];

    NSLog(@">appeared");
    if(self.parent)
    {
        float scale = 1.0;
        if(parent.image.size.height > imageView.frame.size.height || parent.image.size.width > imageView.frame.size.width)
        {
            float extra_height = parent.image.size.height - imageView.frame.size.height;
            if(extra_height > 0) { scale = parent.image.size.height/imageView.frame.size.height; }
        }
        
        
        UIImage *preview = [parent.image resizedImage:CGSizeMake(parent.image.size.width/scale, parent.image.size.height/scale) interpolationQuality:kCGInterpolationLow];
        
        NSLog(@"h: %f w: %f", preview.size.height, preview.size.width);
        
        [self.imageView setImage:preview];
        [self setOverlay];

    }else{
        [NSException raise:@"Improper Initialization" format:@"Parent of PreviewController not set in time for viewDidAppear"];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    CGPoint tap = [sender locationInView:self.imageView];
    NSLog(@"tapped: %f,%f", tap.x, tap.y);
    if([inprogress hasEye:LeftEye])
    {
        NSLog(@"right. whut");
        [inprogress setEye:RightEye withDictionary:@{@"x": [NSNumber numberWithDouble:tap.x], @"y": [NSNumber numberWithDouble:tap.y]}];
        [parent.faces addObject:inprogress];
        [self setOverlay];
    }else{
        [inprogress setEye:LeftEye withDictionary:@{@"x": [NSNumber numberWithDouble:tap.x], @"y": [NSNumber numberWithDouble:tap.y]}];
        NSLog(@"left, whut");
    }
    NSLog(@"face!");
}

-(void)setOverlay
{
    for(UIView *v in self.imageView.subviews)
    {
        [v removeFromSuperview];
        [v release];
    }
    tapper.enabled = NO;
    [inprogress release];
    inprogress = [[iFace alloc] init];
    
    UIBarButtonItem *addFace = [[[UIBarButtonItem alloc] initWithTitle:@"Add Face" style:UIButtonTypeInfoLight target:self action:@selector(addFace)] autorelease];
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(chooseGlassesStep)];
    
    [parent.optionBar setItems:@[addFace,spacer,done] animated:NO];
    for(iFace *f in parent.faces)
    {
        NSLog(@"lx: %f ly %f    rx %f ry %f", f.left_eye.x, f.left_eye.y, f.right_eye.x, f.right_eye.y);
    }
    
    ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:parent.faces andDimensions:self.imageView.image.size];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:[io layer]];
    overlay.image = [io layerAtFrame:10 of:10];
    [self.imageView addSubview:overlay];
    [io release];
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
    
	[hud hide:YES afterDelay:1.5];
    
    tapper.enabled = YES;
    
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
