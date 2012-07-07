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
    
    subContainer = [[UIImageView alloc] initWithFrame:CGRectMake(-20, 0, 360, 480)];
    [nav.navigationBar setHidden:YES];
    
    optionBar = [nav toolbar];
    [nav setToolbarHidden:NO];
    [[nav toolbar] setTranslucent:YES];
    [[nav toolbar] setTintColor:[UIColor blackColor]];
    
    [self setImage:_image];
    [self scaleDownImage];
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if(animated == YES) { return; }
    [self scaleDownImage];
    [self setFaces:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(animated == YES) { return; }
    [self chooseFaces];
    [chooseFacesController viewDidAppear:animated];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = @"Locating Faces";
    hud.dimBackground = true;
    [hud setRemoveFromSuperViewOnHide: true];
    dispatch_async(dispatch_get_main_queue(), ^{
        recognizer = [[FaceRecognition alloc] init];
        [recognizer setDelegate:self];
        [recognizer recognizeWithImage:image andFinalSize:self.subContainer.bounds.size];
    });
}

-(void)scaleDownImage
{
    NSLog(@"current image size is %fx%f", image.size.width, image.size.height);
    float scale = 1.0;
    if(image.size.height > subContainer.bounds.size.height*2 || image.size.width > subContainer.bounds.size.width)
    {
        float extra_height = image.size.height - (subContainer.bounds.size.height*2);
        if(extra_height > 0) { scale = image.size.height/(subContainer.bounds.size.height*2); }
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
    [TestFlight passCheckpoint:@"Choose Faces"];
    [nav popToRootViewControllerAnimated:NO];
    [(AdjustmentViewController *)chooseFacesController setOverlay];
}


-(void)chooseGlasses
{
    [TestFlight passCheckpoint:@"Preview Image"];
    [nav pushViewController:chooseGlassesController animated:NO];
    
}

-(void)chooseDestination
{
    [TestFlight passCheckpoint:@"Finalized image"];
    [nav pushViewController:chooseDestinationController animated:NO];
}


-(void)sendMessageWithData:(NSData *)data
{
    [nav popToRootViewControllerAnimated:NO];
    MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
    [compose setSubject:@"Deal"];
    [compose setMessageBody:@"boom." isHTML:NO];
    [compose addAttachmentData:data mimeType:@"image/gif" fileName:@"dealwithit.gif"];
    [compose setWantsFullScreenLayout:YES];
    compose.mailComposeDelegate = self;
    [self presentModalViewController:compose animated:YES];
    [compose release];
    //[appDelegate showMainPage];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [TestFlight passCheckpoint:@"Sent/Cancelled"];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate showMainPage];
    //[self dismissModalViewControllerAnimated:YES];
}

/**
-(id)retain
{
    NSLog(@"F++ %d", [self retainCount]+1);
    return [super retain];
}

-(void)release
{
    NSLog(@"F-- %d", [self retainCount]-1);
    return [super release];
}
 **/

-(void)dealloc
{
    // Let's Do Horrible Things Today!
    while([nav popViewControllerAnimated:NO]);
    
    [chooseDestinationController release];
    [chooseGlassesController release];
    [faces release];
    [subContainer release];
    [image release];
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
