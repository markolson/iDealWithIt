//
//  PreviewViewController.m
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController
@synthesize iView;
@synthesize raw_image;
@synthesize optionBar;
@synthesize found_faces;

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
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    float scale = 1.0;
    if(raw_image.size.height > iView.frame.size.height || raw_image.size.width > iView.frame.size.width)
    {
        float extra_height = raw_image.size.height - iView.frame.size.height;
        if(extra_height > 0) { scale = raw_image.size.height/iView.frame.size.height; }
    }
    
    
    UIImage *preview = [raw_image resizedImage:CGSizeMake(raw_image.size.width/scale, raw_image.size.height/scale) interpolationQuality:kCGInterpolationLow];
    

    [self.iView setImage:preview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = @"Locating Faces";
    hud.dimBackground = true;
}

-(void)viewDidAppear:(BOOL)animated
{
    FaceRecognition *recognizer = [[FaceRecognition alloc] init];
    [recognizer setDelegate:self];
    [recognizer recognizeWithImage:raw_image andFinalSize:self.iView.image.size];
}

-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSArray *)faces {
    self.found_faces = faces;
    [TestFlight passCheckpoint:@"Started Camera"];
    TFLog(@"Found %d face(s)", [faces count]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self addFacesStep];
    
}


-(void)addFacesStep
{
    
    [TestFlight passCheckpoint:@"Moved to 'add faces'"];
    UIBarButtonItem *addFace = [[[UIBarButtonItem alloc] initWithTitle:@"Add Face" style:UIButtonTypeInfoLight target:self action:@selector(addFace)] autorelease];
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(chooseGlassesStep)];
    
    [self.optionBar setItems:@[addFace,spacer,done] animated:NO];
    
    
    ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:self.found_faces andDimensions:self.iView.image.size];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:[io layer]];
    overlay.image = [io layerAtFrame:10 of:10];
    [self.iView addSubview:overlay];
}

-(void)addFace
{
    UIBarButtonItem *cancel = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:@selector(addFacesStep)] autorelease];
    [cancel setTintColor:[UIColor redColor]];
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(chooseGlassesStep)];
    
    [self.optionBar setItems:@[cancel,spacer,done] animated:NO];
}


-(void)chooseGlassesStep
{
     [TestFlight passCheckpoint:@"Moved to 'choose chrome'"];
    
    UIImage *baseImage = self.iView.image; //[UIImage imageNamed:@"abraham_lincoln1.jpg"];
    
   
    //UIImageView *abe = [[UIImageView alloc] initWithImage:finalpic];

    ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:self.found_faces andDimensions:baseImage.size];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:[io layer]];
    [io setFrames:10];
    
    for (UIView *view in self.iView.subviews) {
        [view removeFromSuperview];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 block:^
    {
        overlay.image = [io nextFrame];
         
    } repeats:YES];
    [self.iView addSubview:overlay];
    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    //UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(animationPreviewStep)] autorelease];
    [self.optionBar setItems:@[spacer] animated:YES];
}


-(id)initWithImage:(UIImage *)image
{
    self = [super initWithNibName:@"PreviewViewController_iPhone" bundle:nil];
    self.raw_image = image;
    return self;
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
