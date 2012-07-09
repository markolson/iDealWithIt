//
//  UploadViewController.m
//  iDealWithIt
//
//  Created by Mark on 7/3/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "UploadViewController.h"

#import "AppDelegate.h"

@interface UploadViewController (Background)

- (void)exportThread:(NSString *)fileOutput;
@end

@interface UploadViewController ()

@end

@implementation UploadViewController

@synthesize parent, mask, hud;

-(id)init
{
    self = [super init];
    mask = [[UIImageView alloc] initWithFrame:CGRectMake(-20, 0, 360, 480)];
    [self.view addSubview:mask];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [parent.optionBar setItems:@[] animated:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if(animated == YES) { return; }
    parent = (FaceViewController *)[self parentViewController];
    [self.view addSubview:[parent subContainer]];
    [self.view bringSubviewToFront:mask];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(animated == YES) { return; }
    [self render];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    TFLog(@"Memory warning in UploadView");
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)render
{
    NSString * tempFile = [NSString stringWithFormat:@"%@/%ld", NSTemporaryDirectory(), time(NULL)];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //[self.view addSubview:hud];
    
	hud.removeFromSuperViewOnHide = YES;
	hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Reticulating Splines";
    
    
	[NSThread detachNewThreadSelector:@selector(exportThread:) toTarget:self withObject:tempFile];
    
}


#pragma mark - Background Thread -

- (void)exportThread:(NSString *)path {
	@autoreleasepool {
        path = [path stringByAppendingPathExtension:@"gif"];
        ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:parent.faces andDimensions:mask.bounds.size];
        [io setFrames:9];
        
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path],
                                                                            kUTTypeGIF,
                                                                            [io frame_count],
                                                                            NULL);
        
        NSDictionary *gFrames = @{ (NSString *)kCGImagePropertyGIFDictionary: @{@"DelayTime" : @0.3 }};
        NSDictionary *lFrame = @{ (NSString *)kCGImagePropertyGIFDictionary: @{@"DelayTime" : @3 }};
        
        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        

		CGSize canvasSize = CGSizeMake(360, 480);
        for (int i = 0; i < [io frame_count]; i++) {
            hud.progress = (i+1)/[io frame_count];
            UIGraphicsBeginImageContext( canvasSize );
            [parent.image drawInRect:CGRectMake(0,0, canvasSize.width,canvasSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
            [[io nextFrame] drawInRect:CGRectMake(0,0, canvasSize.width,canvasSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            
            if([io isLastFrame]) {
                CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)lFrame);
            }else{
                CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)gFrames);
            }
            
            UIGraphicsEndImageContext();
            
        }
        
        CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        [hud removeFromSuperview];
        
        [io release];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", path);
            [parent sendMessageWithData:[NSData dataWithContentsOfFile:path]];
        });
        

        //[compose release];
	}
}
/**
-(id)retain
{
    NSLog(@"U++ %d", [self retainCount]+1);
    return [super retain];
}

-(void)release
{
    NSLog(@"U-- %d", [self retainCount]-1);
    return [super release];
}
**/
-(void)dealloc
{
    [mask release];
    [super dealloc];
}

@end
