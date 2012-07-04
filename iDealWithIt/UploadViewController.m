//
//  UploadViewController.m
//  iDealWithIt
//
//  Created by Mark on 7/3/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController (Background)

- (void)exportThread:(NSString *)fileOutput;
@end

@interface UploadViewController ()

@end

@implementation UploadViewController

@synthesize parent, overlay, hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //FBUser *f = [[FBUser alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [parent.optionBar setItems:@[] animated:NO];
    [self render];
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

-(void)render
{
    NSString * tempFile = [NSString stringWithFormat:@"%@/%ld", NSTemporaryDirectory(), time(NULL)];
    NSLog(@"Saving to.. %@", tempFile);
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //[self.view addSubview:hud];
    
	hud.removeFromSuperViewOnHide = YES;
	hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Drawing";
    
    
	[NSThread detachNewThreadSelector:@selector(exportThread:) toTarget:self withObject:tempFile];
    
}


#pragma mark - Background Thread -

- (void)exportThread:(NSString *)path {
	@autoreleasepool {
        path = [path stringByAppendingPathExtension:@"gif"];
        ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:parent.faces andDimensions:overlay.bounds.size];
        [io setFrames:11];
        
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path],
                                                                            kUTTypeGIF,
                                                                            [io frame_count],
                                                                            NULL);
        
        NSLog(@"%@", (NSString *)kCGImagePropertyGIFDictionary);
        NSDictionary *gFrames = @{ (NSString *)kCGImagePropertyGIFDictionary: @{@"DelayTime" : @0.2 }};
        NSDictionary *lFrame = @{ (NSString *)kCGImagePropertyGIFDictionary: @{@"DelayTime" : @2 }};
        
        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        

		CGSize canvasSize = parent.image.size;
        for (int i = 0; i < [io frame_count]; i++) {
            UIGraphicsBeginImageContext( canvasSize );
            [parent.image drawAtPoint:CGPointMake(0, 0)];
            [[io nextFrame] drawInRect:CGRectMake(0,0, canvasSize.width,canvasSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            
            if([io isLastFrame]) {
                NSLog(@"ALMOST");
                CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)lFrame);
            }else{
                CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)gFrames);
            }
            
            UIGraphicsEndImageContext();
            
        }
        
        CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        NSLog(@"animated GIF file created at %@", path);
        [hud hide:YES];
	}
}


@end
