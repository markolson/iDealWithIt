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

    [self recognizeUsingIOS];

    
}
// Reachability *netReach = [Reachability reachabilityWithHostName:@"host.name"];

#pragma mark Internal Stuff

-(void) recognizeUsingIOS {
    
    UIImage *i = original;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CIImage *image = [[CIImage alloc] initWithImage:i];
    
        NSString *accuracy = CIDetectorAccuracyHigh;
        //NSString *accuracy = CIDetectorAccuracyLow;
        NSDictionary *options = [NSDictionary dictionaryWithObject:accuracy forKey:CIDetectorAccuracy];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:options];
        
        NSArray *features = [detector featuresInImage:image];
        [image release];
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
        
    });
}

@end
