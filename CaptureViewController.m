//
//  SecondViewController.m
//  iDealWithIt
//
//  Created by mark olson on 6/16/12.
//  Copyright (c) 2012 mark olson. All rights reserved.
//

#import "CaptureViewController.h"
#import "PreviewViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>



@interface CaptureViewController ()

@end

@implementation CaptureViewController

#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Capture", @"Capture");
        self.tabBarItem.tag = 1;
        self.tabBarItem.image = [UIImage imageNamed:@"camera"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self startCameraControllerFromViewController: self usingDelegate: self];
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Functionality

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:NULL];
    return YES;
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [self.tabBarController setSelectedIndex:0];
    [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *raw = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        
    [self dismissViewControllerAnimated:NO completion:NULL];
    [picker release];
    
    PreviewViewController *worker = [[[PreviewViewController alloc] initWithImage:raw] autorelease];
    [self.view.window setRootViewController:worker];
}
@end
