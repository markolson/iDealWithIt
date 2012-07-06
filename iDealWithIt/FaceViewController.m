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
@synthesize chooseFacesController, chooseDestinationController, chooseGlassesController;


-(id)initWithImage:(UIImage *)_image
{
    nav = self = [self initWithRootViewController:[[[AdjustmentViewController alloc] init] autorelease]];
    
    chooseFacesController = [nav topViewController];
    chooseGlassesController = [[OverlayPickerViewController alloc] init];
    chooseDestinationController = [[UploadViewController alloc] init];
    
    subContainer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    [nav.navigationBar setHidden:YES];
    
    optionBar = [nav toolbar];
    [nav setToolbarHidden:NO];
    [[nav toolbar] setTintColor:[UIColor blackColor]];
    
    [self setImage:_image];
    [self scaleDownImage];
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self scaleDownImage];
    [self setFaces:[@[] mutableCopy]];
    [self chooseFaces];
}

-(void)viewDidAppear:(BOOL)animated
{
    [chooseFacesController viewDidAppear:NO];
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

-(void)scaleDownImage
{
    float scale = 1.0;
    if(image.size.height > 420 || image.size.width > 320)
    {
        float extra_height = image.size.height - 420;
        if(extra_height > 0) { scale = image.size.height/420; }
    }
    UIImage *preview = [image resizedImage:CGSizeMake(image.size.width/scale, image.size.height/scale) interpolationQuality:kCGInterpolationLow];
    [self setImage:preview];
    [subContainer setImage:image];
}

// blow this stack out asap.
-(void)FaceRecognizer:(id)r didFindFaces:(NSMutableArray *)_faces {
    [self setFaces:_faces];
    [TestFlight passCheckpoint:@"Found faces"];
    TFLog(@"Found %d face(s)", [faces count]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [chooseFacesController performSelector:@selector(setOverlay)];
    [recognizer release];
}

-(void)chooseFaces
{
    [nav popToRootViewControllerAnimated:NO];
    NSLog(@"Now there are %d", [[nav viewControllers] count]);
}


-(void)chooseGlasses
{
    [TestFlight passCheckpoint:@"Showed resultant image"];
    [nav pushViewController:chooseGlassesController animated:NO];
    
}

-(void)chooseDestination
{
    [TestFlight passCheckpoint:@"Finalized image"];
    [nav pushViewController:chooseDestinationController animated:NO];
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
}

-(void)dealloc
{
    [faces release];
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}


@end
