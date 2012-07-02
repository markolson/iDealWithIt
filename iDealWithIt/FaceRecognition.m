//
//  FaceRecognition.m
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "Reachability.h"
#import "FaceRecognition.h"
#import "Face.h"
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>

@implementation FaceRecognition

@synthesize original;
@synthesize delegate;
@synthesize canvas;

- (id) init
{
    self = [super init];
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) initWithImage:(UIImage *)img andDelegate:(id)d
{
    self = [self init];
    if(self)
    {
        [self setOriginal:img];
        [self setDelegate:d];
    }
    return self;
}

- (void) recognizeWithImage:(UIImage *)image andFinalSize:(CGSize)_canvas {
    self.canvas = _canvas;
    [self setOriginal:image];
    Reachability *access = [Reachability reachabilityWithHostname:@"apple.com"];
    if(NO)
    {
        [self recognizeUsingIOS];
        return;
    }
    if([access isReachable])
    {
        [self recognizeUsingFace];
    }else{
        [self recognizeUsingIOS];
    }
    
}
// Reachability *netReach = [Reachability reachabilityWithHostName:@"host.name"];

#pragma mark Internal Stuff.

-(void) recognizeUsingIOS {
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    NSArray* features = [detector featuresInImage:[self.original CIImage]];
    
    NSMutableArray *faceObjects = [[NSMutableArray alloc] init];
    for(CIFaceFeature* faceFeature in features)
    {
        NSDictionary * face = @{@"eye_right": @{@"x": [NSNumber numberWithDouble:faceFeature.rightEyePosition.x],
                                                @"y": [NSNumber numberWithDouble:faceFeature.rightEyePosition.y]},
                                @"eye_left": @{@"x": [NSNumber numberWithDouble:faceFeature.leftEyePosition.x],
                                                @"y": [NSNumber numberWithDouble:faceFeature.leftEyePosition.y]}};
        iFace *obj = [[iFace alloc] init];
        [obj setEye:RightEye withDictionary:[face objectForKey:@"eye_right"]];
        [obj setEye:LeftEye withDictionary:[face objectForKey:@"eye_left"]];
        [faceObjects addObject:obj];
        [obj release];
    }
    [self.delegate FaceRecognizer:self didFindFaces:faceObjects];
    [faceObjects release];
}

-(void) recognizeUsingFace {
    
    [FWKeysHelper setFaceAPI:@"2f67db92fdb19ae9c269a4bdae34a46f"];
    [FWKeysHelper setFaceSecretAPI:@"7414ec16d863f65caa5c3169a8112045"];
    
    FWObject *object = [FWObject new];
    
    
    //POST
    UIImage *image = nil;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    if(self.original.size.height > 900 || self.original.size.width > 900)
    {
        float scale = MAX(self.original.size.height, self.original.size.width)/900.0;
        
        image = [self.original resizedImage:CGSizeMake(self.original.size.width/scale, self.original.size.height/scale) interpolationQuality:kCGInterpolationLow];
    }else{
        image = self.original;
    }
    UIImage *rotated = [image scaleAndRotate];


    FWImage *fwImage = [[FWImage alloc] initWithData:UIImageJPEGRepresentation(rotated, 0.6)
                                           imageName:@"resized"
                                           extension:@"jpg"
                                         andFullPath:@""];

    fwImage.tag = 999;
    [images addImagePOSTToArray:fwImage];
    
    [object setPostImages:images];
    
    object.isRESTObject = NO;
    object.wantRecognition = NO;
    
    [object setDetector:DETECTOR_TYPE_DEFAULT];
    [object setFormat:FORMAT_TYPE_JSON];
    
    
    [[FaceWrapper instance] detectFaceWithFWObject:object 
                                   runInBackground:NO
                                    completionData:^(NSDictionary *response, int tagImagePost) 
     {
         NSArray *faces = (NSArray *)[(NSDictionary *)[(NSArray *)[response objectForKey:@"photos"] objectAtIndex:0] valueForKey:@"tags"];
         
         NSMutableArray *faceObjects = [[NSMutableArray alloc] init];
         
         for(NSDictionary *face in faces)
         {
             iFace *obj = [[iFace alloc] init];
             [obj setEye:RightEye withDictionary:[face objectForKey:@"eye_right"] andDimensions:self.canvas];
             [obj setEye:LeftEye withDictionary:[face objectForKey:@"eye_left"] andDimensions:self.canvas];
             [faceObjects addObject:obj];
             [obj release];
         }
         [self.delegate FaceRecognizer:self didFindFaces:faceObjects];
         [faceObjects release];
         [object release];
         [fwImage release];
         [images release];
     }];
}

@end
