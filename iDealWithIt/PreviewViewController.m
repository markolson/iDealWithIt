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
    self.iView.image = raw_image;
    // Do any additional setup after loading the view from its nib.
    [self recognize];
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


-(void) recognize {

    [FWKeysHelper setFaceAPI:@"2f67db92fdb19ae9c269a4bdae34a46f"];
    [FWKeysHelper setFaceSecretAPI:@"7414ec16d863f65caa5c3169a8112045"];
    
    FWObject *object = [FWObject new];

    
    //POST
    UIImage *image = self.raw_image;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    FWImage *fwImage = [[FWImage alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)
                                           imageName:@"girls"
                                           extension:@"jpg"
                                         andFullPath:@""];
    fwImage.tag = 999;
    [images addImagePOSTToArray:fwImage];
    
    [object setPostImages:images];
    
    object.isRESTObject = NO;
    //END POST
    
    object.wantRecognition = NO;
    
    [object setDetector:DETECTOR_TYPE_DEFAULT];
    [object setFormat:FORMAT_TYPE_JSON];
    
    NSMutableArray *attr = [NSMutableArray new];
    [attr addAttributeToArray:ATTRIBUTE_GENDER];
    [attr addAttributeToArray:ATTRIBUTE_GLASSES];
    [attr addAttributeToArray:ATTRIBUTE_SMILING];
    
    [object setAttributes:attr];
    [object setCallback:@""];
    [object setCallback_url:nil];
    
    FWImageController *controller = [[FWImageController alloc] initWithNibName:@"FWImageController" bundle:nil];
    controller.objects = [NSArray arrayWithObjects:object, nil];
    controller.delegate = self;
    
    [self presentModalViewController:controller animated:YES];
}

#pragma -
#pragma FWImageControllerDelegate methods

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

- (void)controllerDidRecognizeFaceItemWithObject:(NSDictionary *)faces postImageTag:(int)tag
{
    //tag = -1 means NO TAG, this tag is only in available to check POST images
    NSLog(@"RECOGNIZED photo tag: %d", tag);
    
    if ([faces count] == 0)
    {
        NSLog(@"NO FACES RECOGNIZED - %@", faces);
    }
    else
    {
        NSLog(@"RECOGNIZED : %@", faces);
    }
}

@end
