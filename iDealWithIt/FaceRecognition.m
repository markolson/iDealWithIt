//
//  FaceRecognition.m
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "FaceRecognition.h"

@implementation FaceRecognition
@synthesize original;
@synthesize delegate;

- (id) init
{
    self = [super init];
    return self;
}

- (id) initWithImage:(UIImage *)img andDelegate:(id)d
{
    [self init];
    if(self)
    {
        [self setOriginal:img];
        [self setDelegate:d];
    }
    return self;
}

#pragma mark Internal Stuff.

-(void) IOS {
    
}

-(void) Face {
    
    [FWKeysHelper setFaceAPI:@"2f67db92fdb19ae9c269a4bdae34a46f"];
    [FWKeysHelper setFaceSecretAPI:@"7414ec16d863f65caa5c3169a8112045"];
    
    FWObject *object = [FWObject new];
    
    
    //POST
    UIImage *image = nil;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSLog(@"raw_image is %fx%f", self.original.size.height, self.original.size.width);
    if(self.original.size.height > 900 || self.original.size.width > 900)
    {
        float scale = MAX(self.original.size.height, self.original.size.width)/900.0;
        
        image = [self.original resizedImage:CGSizeMake(self.original.size.width/scale, self.original.size.height/scale) interpolationQuality:kCGInterpolationLow];
    }else{
        image = self.original;
    }
    NSLog(@"raw_image is %fx%f", image.size.height, image.size.width);
    FWImage *fwImage = [[FWImage alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)
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
         NSLog(@"response: %@", response);
     }];
}

@end
