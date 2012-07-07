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

#define iOStoFace(f,x) [NSNumber numberWithDouble:(f/x)*100]

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
    [delegate release];
    [original release];
    [super dealloc];
}

- (id) initWithImage:(UIImage *)img andDelegate:(id)d
{
    self = [self init];
    if(self)
    {
        [self setOriginal:img];
        [img release];
        [self setDelegate:d];
    }
    return self;
}

- (void) recognizeWithImage:(UIImage *)image andFinalSize:(CGSize)_canvas {
    [self setCanvas:_canvas];
    [self setOriginal:image];
    //Reachability *access = [Reachability reachabilityWithHostname:@"apple.com"];

    if(NO)
    {
        [self recognizeUsingFace];
    }else{
        [self recognizeUsingIOS];
    }
    
}
// Reachability *netReach = [Reachability reachabilityWithHostName:@"host.name"];

#pragma mark Internal Stuff

-(void) recognizeUsingIOS {
    
    UIImage *i = original;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIImage *image = [[CIImage alloc] initWithImage:i];
    
        //NSString *accuracy = CIDetectorAccuracyHigh;
        NSString *accuracy = CIDetectorAccuracyLow;
        NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
        
        NSArray *features = [detector featuresInImage:image];
        UIGraphicsEndImageContext();
        NSMutableArray *faceObjects = [[NSMutableArray alloc] init];
        for(CIFaceFeature* faceFeature in features)
        {
            // convert each coordinate to a percentage?
            NSDictionary * face =
            @{@"eye_right":
                @{@"x": iOStoFace(faceFeature.rightEyePosition.x, i.size.width),
                @"y": iOStoFace((i.size.height-faceFeature.rightEyePosition.y), i.size.height)
            },
            @"eye_left":
            @{@"x": iOStoFace(faceFeature.leftEyePosition.x, i.size.width),
                @"y": iOStoFace((i.size.height-faceFeature.leftEyePosition.y), i.size.height)
            }};
            iFace *obj = [[iFace alloc] init];
            
            [obj setEye:RightEye withDictionary:[face objectForKey:@"eye_right"] andDimensions:canvas];
            [obj setEye:LeftEye withDictionary:[face objectForKey:@"eye_left"] andDimensions:canvas];
            [faceObjects addObject:obj];
            [obj release];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate FaceRecognizer:self didFindFaces:faceObjects];
        });
        [image release];
        
    });
}

-(void) recognizeUsingFace {
    
    [FWKeysHelper setFaceAPI:@"2f67db92fdb19ae9c269a4bdae34a46f"];
    [FWKeysHelper setFaceSecretAPI:@"7414ec16d863f65caa5c3169a8112045"];
    
    FWObject *object = [FWObject new];
    
    
    //POST
    UIImage *image = nil;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSLog(@"images: %d", [images retainCount]);
    if(self.original.size.height > 900 || self.original.size.width > 900)
    {
        float scale = MAX(self.original.size.height, self.original.size.width)/900.0;
        
        image = [self.original resizedImage:CGSizeMake(self.original.size.width/scale, self.original.size.height/scale) interpolationQuality:kCGInterpolationLow];
    }else{
        image = self.original;
    }
    UIImage *rotated = [image scaleAndRotate];

    NSData *blob = UIImageJPEGRepresentation(rotated, 0.6);
    FWImage *fwImage = [[FWImage alloc] initWithData:blob
                                           imageName:@"resized"
                                           extension:@"jpg"
                                         andFullPath:@""];
    
    TFLog(@"Uploading image to face: %dKB", [blob length]/(8*1024));
    [blob release];
    
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
     }];
    [fwImage release];
    [object release];
}


@end
