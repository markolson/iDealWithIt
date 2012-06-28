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

-(UIImage *)layer {
    return [self layerAtFrame:0 of:self.frame_count];
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
        
        float haha = total_frames/1.0;
        
        float this_y = (eye_left_y - (height*0.2)) * frame_number/haha;
        
        NSLog(@"Sizes: [%d of %f] Y:%f", frame_number, haha, this_y);
        
        [glasses drawInRect:CGRectMake(start_left,this_y,width,height) blendMode:kCGBlendModeNormal alpha:1.0];
        
    }
    layer = UIGraphicsGetImageFromCurrentImageContext();
    [glasses release];
    UIGraphicsEndImageContext();
    return layer;
}
@end
