//
//  ImageOverlay.m
//  iDealWithIt
//
//  Created by Mark on 6/27/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "ImageOverlay.h"

/**
 TODO: Add in a delegate renderer that can render per-frame images (ie, sparkles, googly-eyes)
 **/
@implementation ImageOverlay

@synthesize layer, faces, dimensions;

-(id)initWithFaces:(NSArray *)f andDimensions:(CGSize)d
{
    self = [super init];
    self.faces = f;
    self.dimensions = d;
    return self;
}

-(UIImage *)layer {
    return [self layerAtFrame:0 of:0];
}

-(UIImage *)layerAtFrame:(int)frame_number of:(int)total_frames
{
    float bw = dimensions.width;
    NSLog(@"width? %f", bw);
    float bh = dimensions.height;
    
    UIImage *glasses = [UIImage imageNamed:@"glasses.png"];
    
    UIGraphicsBeginImageContext( dimensions );
    
    for (NSDictionary *face in self.faces) {
        float eye_left_x = bw * ([(NSString *)[(NSDictionary *)[face objectForKey:@"eye_left"] valueForKey:@"x"] floatValue]/100.0);
        float eye_left_y = bh * ([(NSString *)[(NSDictionary *)[face objectForKey:@"eye_left"] valueForKey:@"y"] floatValue]/100.0);
        float eye_right_x = bw * ([(NSString *)[(NSDictionary *)[face objectForKey:@"eye_right"] valueForKey:@"x"] floatValue]/100.0);
        float eye_right_y = bh * ([(NSString *)[(NSDictionary *)[face objectForKey:@"eye_right"] valueForKey:@"y"] floatValue]/100.0);
        
        float width = (eye_right_x - eye_left_x) * 2.5 ;
        float height = (width/glasses.size.width) * glasses.size.height;
        
        float start_left = (eye_left_x) - (width * 0.25);
        
        NSLog(@"Sizes: [%f] %fx%f X:%f Y:%f", width/glasses.size.width, width, height, eye_left_x, eye_right_x);
        
        [glasses drawInRect:CGRectMake(start_left,(eye_left_y - (height*0.2)),width,height) blendMode:kCGBlendModeNormal alpha:1.0];
        
    }
    layer = UIGraphicsGetImageFromCurrentImageContext();
    [glasses release];
    UIGraphicsEndImageContext();
    return layer;
}
@end
