//
//  FaceViewController.m
//  iDealWithIt
//
//  Created by Mark on 7/1/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "FaceViewController.h"
#import "AppDelegate.h"
#import "AdjustmentViewController.h"
#import "OverlayPickerViewController.h"
#import "UploadViewController.h"
#import "FaceRecognition.h"
#import "MBProgressHUD.h"



@interface FaceViewController ()

@end

@implementation FaceViewController

@synthesize subContainer, image, faces, optionBar, recognizer;
@synthesize chooseDestinationController, chooseFacesController, chooseGlassesController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self setChooseFacesController:[[AdjustmentViewController alloc] initWithNibName:@"AdjustmentViewController_iPhone" bundle:nil]];
    [self setChooseDestinationController:[[UploadViewController alloc] initWithNibName:@"UploadViewController_iPhone" bundle:nil]];
    [self setChooseGlassesController:[[OverlayPickerViewController alloc] initWithNibName:@"OverlayPickerViewController_iPhone" bundle:nil]];
    
    [chooseFacesController setParent:self];
    [chooseGlassesController setParent:self];
    [chooseDestinationController setParent:self];
    return self;
}


-(id)initWithImage:(UIImage *)_image
{
    self = [self initWithNibName:@"FaceViewController_iPhone" bundle:nil];
    [self setImage:_image];
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    if(animated == YES) { return; }
    [self scaleDownImage];
    [self setFaces:[@[] mutableCopy]];
    [self chooseFaces];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self scaleDownImage];
}

-(void)scaleDownImage
{
    float scale = 1.0;
    if(image.size.height > subContainer.frame.size.height || image.size.width > subContainer.frame.size.width)
    {
        float extra_height = image.size.height - subContainer.frame.size.height;
        if(extra_height > 0) { scale = image.size.height/subContainer.frame.size.height; }
    }
    UIImage *preview = [image resizedImage:CGSizeMake(image.size.width/scale, image.size.height/scale) interpolationQuality:kCGInterpolationLow];
    [self setImage:preview];
    [subContainer setImage:image];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(animated == YES) { return; }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = @"Locating Faces";
    hud.dimBackground = true;
    [hud setRemoveFromSuperViewOnHide: true];
    dispatch_async(dispatch_get_main_queue(), ^{
        recognizer = [[FaceRecognition alloc] init];
        [recognizer setDelegate:self];
        [recognizer recognizeWithImage:image andFinalSize:self.subContainer.frame.size];
    });
}

// blow this stack out asap.
-(void)FaceRecognizer:(id)r didFindFaces:(NSMutableArray *)_faces {
    [self setFaces:_faces];
    [TestFlight passCheckpoint:@"Found faces"];
    TFLog(@"Found %d face(s)", [faces count]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [chooseFacesController performSelector:@selector(setOverlay)];
    [self.recognizer release];
}

-(void)chooseFaces
{
    [chooseDestinationController.view removeFromSuperview];
    [chooseGlassesController.view removeFromSuperview];
    [subContainer addSubview:chooseFacesController.view];
}


-(void)chooseGlasses
{
    [TestFlight passCheckpoint:@"Showed resultant image"];
    [[chooseFacesController view] removeFromSuperview];
    [[chooseDestinationController view] removeFromSuperview];
    [subContainer addSubview:chooseGlassesController.view];
}

-(void)chooseDestination
{
    [TestFlight passCheckpoint:@"Finalized image"];
    [[chooseGlassesController view] removeFromSuperview];
    [[chooseFacesController view] removeFromSuperview];
    [subContainer addSubview:chooseDestinationController.view];
}


-(void)sendMessageWithData:(NSData *)data
{
    MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
    [compose setSubject:@"Deal"];
    [compose setMessageBody:@"boom." isHTML:NO];
    [compose addAttachmentData:data mimeType:@"image/gif" fileName:@"dealwithit.gif"];
    [compose setWantsFullScreenLayout:YES];
    compose.mailComposeDelegate = self;
    [self presentModalViewController:compose animated:YES];
    [compose release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
    [self setImage:nil];
    [[chooseDestinationController view] removeFromSuperview];
    [[chooseGlassesController view] removeFromSuperview];
    [[chooseFacesController view] removeFromSuperview];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showMainPage];
}

-(void)dealloc
{
    [faces release];
    [subContainer release];
    [chooseDestinationController release];
    [chooseGlassesController release];
    [chooseFacesController release];
    [subContainer release];
    [image release];
    [optionBar release];
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
