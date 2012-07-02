//
//  ImageOverlay.m
//  iDealWithIt
//
//  Created by Mark on 6/27/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "ImageOverlay.h"
#define degreesToRadians(degrees) (M_PI * degrees / 180.0)
#define radiansToDegrees(radians) (radians * 180 / M_PI)

/**
 TODO: Add in a delegate renderer that can render per-frame images (ie, sparkles, googly-eyes)
 **/
@implementation ImageOverlay

@synthesize layer, faces, dimensions, frame_count, current_frame;

-(id)initWithFaces:(NSArray *)f andDimensions:(CGSize)d
{
    self = [super init];
    self.faces = f;
    self.dimensions = d;
    self.current_frame = 0;
    return self;
}

-(void)setFrames:(int)frames
{
    self.frame_count = frames/1.0;
}

-(UIImage *)nextFrame
{
    self.current_frame++;
    if(self.current_frame > frame_count) { self.current_frame = 0; }
    return [self layerAtFrame:self.current_frame of:frame_count];
}

-(BOOL)isLastFrame
{
    return self.frame_count > 0 && (self.frame_count == current_frame);
}

-(UIImage *)layer {
    return [self layerAtFrame:0 of:self.frame_count];
}

-(UIImage *)shadesForFace:(iFace *)face
{
    UIImage *glasses = [UIImage imageNamed:@"glasses.png"];
    
    CGImageRef imgRef = glasses.CGImage;
    
    
	CGFloat angleInRadians = -atan(face.roll);
    if(angleInRadians < 0.1) { angleInRadians = 0.0; }
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
    
	CGRect imgRect = CGRectMake(0, 0, width, height);
	CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
	CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef bmContext = CGBitmapContextCreate(NULL,
												   rotatedRect.size.width,
												   rotatedRect.size.height,
												   8,
												   0,
												   colorSpace,
												   kCGImageAlphaPremultipliedFirst);
	CGContextSetAllowsAntialiasing(bmContext, YES);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
	CGColorSpaceRelease(colorSpace);
	CGContextTranslateCTM(bmContext,
						  +(rotatedRect.size.width/2),
						  +(rotatedRect.size.height/2));
	CGContextRotateCTM(bmContext, angleInRadians);
	CGContextDrawImage(bmContext, CGRectMake(-width/2, -height/2, width, height),
					   imgRef);
    
	CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
	CFRelease(bmContext);
	[(id)rotatedImage autorelease];
    
	return  [UIImage imageWithCGImage: rotatedImage];
}

-(UIImage *)layerAtFrame:(int)frame_number of:(int)total_frames
{
    UIGraphicsBeginImageContext( dimensions );
    
    for (iFace *face in self.faces) {
        
        UIImage *glasses = [self shadesForFace:face];
        float width = (face.right_eye.x - face.left_eye.x) * 2.5 ;
        float height = (width/glasses.size.width) * glasses.size.height;
        
        float start_left = (face.left_eye.x) - (width * 0.28);
        
        float haha = total_frames/1.0;
        
        float this_y = (((face.right_eye.y + face.left_eye.y)/2.0) - height*0.15) * frame_number/haha;
        
        [glasses drawInRect:CGRectMake(start_left,this_y,width,height) blendMode:kCGBlendModeNormal alpha:1.0];
    }
    if([self isLastFrame])
    {
        UIImage *deal = [UIImage imageNamed:@"dealwithit.png"];
        [deal drawInRect:CGRectMake(20, 320, 280, 70) blendMode:kCGBlendModeNormal alpha:1.0];
    }
    layer = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return layer;
}
@end
