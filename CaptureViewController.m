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
@synthesize rawimage;
@synthesize iView;

#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Capture", @"Capture");
        self.tabBarItem.tag = 1;
        self.tabBarItem.image = [UIImage imageNamed:@"camera"];
    }
    //[FWKeysHelper setFaceAPI:@"2f67db92fdb19ae9c269a4bdae34a46f"];
    //[FWKeysHelper setFaceSecretAPI:@"7414ec16d863f65caa5c3169a8112045"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [self dismissViewControllerAnimated:NO completion:NULL];
    [self.tabBarController setSelectedIndex:0];
    [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    self.rawimage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    //[self recognize];
    //iView.image = self.rawimage;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [picker release];
}
/**
- (void) recognize {
    FWObject *face = [FWObject new];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    FWImage *fwImage = [[FWImage alloc] initWithData:UIImageJPEGRepresentation(self.rawimage, 1.0)
                                           imageName:@"recognize"
                                           extension:@"jpg"
                                         andFullPath:@""];
    fwImage.tag = 999;
    [images addImagePOSTToArray:fwImage];
    
    [face setPostImages:images];
    face.isRESTObject = NO;
    face.wantRecognition = NO;
    
    [face setDetector:DETECTOR_TYPE_DEFAULT];
    [face setFormat:FORMAT_TYPE_JSON];
    
    [[FaceWrapper instance] detectFaceWithFWObject:face
                                   runInBackground:NO
                                    completionData:^(NSDictionary *response, int tagImagePost) {
        NSLog(@"Reponse: %@", response);
    }];
}

- (void)controllerDidFindFaceItemWithObject:(NSDictionary *)faces postImageTag:(int)tag
{
    //tag = -1 means NO TAG, this tag is only in available to check POST images
    NSLog(@"DETECTED photo tag: %d, %@", tag, faces);
    
    if ([faces count] == 0)
    {
        NSLog(@"NO FACES DETECTED - %@", faces);
    }
    else
    {
        ParseObject *parsed = [[ParseObject alloc] initWithRawDictionary:faces];
        
        [parsed loopOverFaces:^(NSDictionary *face) {
            
            NSLog(@"FACE DETECTED: %@", face);
        }]; 
    }
}
**/
@end
