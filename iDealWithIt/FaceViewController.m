//
//  FaceViewController.m
//  iDealWithIt
//
//  Created by Mark on 7/1/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "FaceViewController.h"
#import "AdjustmentViewController.h"
#import "OverlayPickerViewController.h"
#import "UploadViewController.h"
#import "FaceRecognition.h"
#import "MBProgressHUD.h"


@interface FaceViewController ()

@end

@implementation FaceViewController

@synthesize subContainer, image, faces, optionBar, currentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithImage:(UIImage *)_image
{
    self = [super initWithNibName:@"FaceViewController_iPhone" bundle:nil];
    self.image = _image;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = @"Locating Faces";
    hud.dimBackground = true;
    currentController = [[AdjustmentViewController alloc] initWithNibName:@"AdjustmentViewController_iPhone" bundle:nil];

    [currentController setParent:self];
    float scale = 1.0;
    if(image.size.height > subContainer.frame.size.height || image.size.width > subContainer.frame.size.width)
    {
        float extra_height = image.size.height - subContainer.frame.size.height;
        if(extra_height > 0) { scale = image.size.height/subContainer.frame.size.height; }
    }
    
    UIImage *preview = [image resizedImage:CGSizeMake(image.size.width/scale, image.size.height/scale) interpolationQuality:kCGInterpolationLow];
    
    subContainer.image = preview;
    
    
    [subContainer addSubview:currentController.view];
	
}

-(void)viewDidAppear:(BOOL)animated
{
    FaceRecognition *recognizer = [[FaceRecognition alloc] init];
    [recognizer setDelegate:self];
    [recognizer recognizeWithImage:image andFinalSize:self.subContainer.frame.size];
}

-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSMutableArray *)_faces {
    self.faces = _faces;
    [faces retain];
    [TestFlight passCheckpoint:@"Found faces"];
    TFLog(@"Found %d face(s)", [faces count]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [currentController performSelector:@selector(setOverlay)];
}

-(void)chooseGlasses
{
    [TestFlight passCheckpoint:@"Showed resultant image"];
    [[currentController view] removeFromSuperview];
    [currentController release];
    [optionBar setItems:@[] animated:YES];
    currentController = [[OverlayPickerViewController alloc] initWithNibName:@"OverlayPickerViewController_iPhone" bundle:nil];
    [currentController setParent:self];
    [subContainer addSubview:currentController.view];
}

-(void)chooseDestination
{
    [TestFlight passCheckpoint:@"Finalized image"];
    [[currentController view] removeFromSuperview];
    [currentController release];
    currentController = [[UploadViewController alloc] initWithNibName:@"UploadViewController_iPhone" bundle:nil];
    [currentController setParent:self];
    [subContainer addSubview:currentController.view];
}

-(void)dealloc
{
    [faces release];
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
