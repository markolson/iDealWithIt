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
@synthesize parent, imageView;

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

-(void)setOverlay
{
    for(UIView *v in self.imageView.subviews)
    {
        [v removeFromSuperview];
    }
    UIBarButtonItem *addFace = [[[UIBarButtonItem alloc] initWithTitle:@"Add Face" style:UIButtonTypeInfoLight target:self action:@selector(addFace)] autorelease];
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(chooseGlassesStep)];
    
    [parent.optionBar setItems:@[addFace,spacer,done] animated:NO];
    
    
    ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:parent.faces andDimensions:self.imageView.image.size];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:[io layer]];
    overlay.image = [io layerAtFrame:10 of:10];
    [self.imageView addSubview:overlay];
}

-(void)addFace
{
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setOverlay)] autorelease];
    [cancel setTintColor:[UIColor redColor]];
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(chooseGlassesStep)];
    
    [parent.optionBar setItems:@[cancel,spacer,done] animated:NO];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];

    hud.mode = MBProgressHUDModeText;
	hud.labelText = @"Tap on the left, and then right eye.";
    hud.dimBackground = YES;
	hud.margin = 10.f;
	hud.removeFromSuperViewOnHide = YES;
    
	[hud hide:YES afterDelay:1.5];
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
