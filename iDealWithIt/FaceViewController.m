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
    [self setImage:_image];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = @"Locating Faces";
    hud.dimBackground = true;
    [hud setRemoveFromSuperViewOnHide: true];

    float scale = 1.0;
    if(image.size.height > subContainer.frame.size.height || image.size.width > subContainer.frame.size.width)
    {
        float extra_height = image.size.height - subContainer.frame.size.height;
        if(extra_height > 0) { scale = image.size.height/subContainer.frame.size.height; }
    }
    
    UIImage *preview = [image resizedImage:CGSizeMake(image.size.width/scale, image.size.height/scale) interpolationQuality:kCGInterpolationLow];
    
    [self setImage:preview];
    [subContainer setImage:preview];
    
    
	
}

-(void)viewDidAppear:(BOOL)animated
{
    [self chooseFaces];
    FaceRecognition *recognizer = [[FaceRecognition alloc] init];
    [recognizer setDelegate:self];
    [recognizer recognizeWithImage:image andFinalSize:self.subContainer.frame.size];
}

// blow this stack out asap.
-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSMutableArray *)_faces {
    [self setFaces:_faces];
    [faces retain];
    [TestFlight passCheckpoint:@"Found faces"];
    TFLog(@"Found %d face(s)", [faces count]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [currentController performSelector:@selector(setOverlay)];
}

-(void)chooseFaces
{
    if(currentController)
    {
        [[currentController view] removeFromSuperview];
        [currentController release];
    }
    [self setCurrentController:[[AdjustmentViewController alloc] initWithNibName:@"AdjustmentViewController_iPhone" bundle:nil]];
    [currentController setParent:self];
    [subContainer addSubview:currentController.view];
}


-(void)chooseGlasses
{
    [TestFlight passCheckpoint:@"Showed resultant image"];
    [[currentController view] removeFromSuperview];
    [currentController release];
    [self setCurrentController:[[OverlayPickerViewController alloc] initWithNibName:@"OverlayPickerViewController_iPhone" bundle:nil]];
    [currentController setParent:self];
    [subContainer addSubview:currentController.view];
}

-(void)chooseDestination
{
    [TestFlight passCheckpoint:@"Finalized image"];
    [[currentController view] removeFromSuperview];
    [currentController release];
    [self setCurrentController:[[UploadViewController alloc] initWithNibName:@"UploadViewController_iPhone" bundle:nil]];
    [currentController setParent:self];
    [subContainer addSubview:currentController.view];
}


-(void)sendMessageWithData:(NSData *)data
{
    NSLog(@"Main: %d", [NSThread isMainThread]);
    MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
    [compose setSubject:@"Deal"];
    [compose setMessageBody:@"boom." isHTML:NO];
    [compose addAttachmentData:data mimeType:@"image/gif" fileName:@"dealwithit.gif"];
    [compose setWantsFullScreenLayout:YES];
    compose.mailComposeDelegate = self;
    [self presentModalViewController:compose animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
}


-(void)dealloc
{
    [faces release];
    [subContainer release];
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
