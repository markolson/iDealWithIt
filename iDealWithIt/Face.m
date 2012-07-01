//
//  Face.m
//  iDealWithIt
//
//  Created by Mark on 6/26/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "Face.h"

@implementation iFace

@synthesize left_eye, right_eye;
@synthesize pitch, roll, yaw;

-(void)setEye:(FaceElement)part withDictionary:(NSDictionary *)xy {
    [self setEye:part withDictionary:xy andDimensions:CGSizeMake(100.0, 100.0)];
}

-(void)setEye:(FaceElement)part withDictionary:(NSDictionary *)xy andDimensions:(CGSize)canvas{
    
    CGPoint current = CGPointMake(0.0, 0.0);
    if(canvas.height == 0){ canvas = CGSizeMake(100.0, 100.0); }
    current.x = canvas.width * ([(NSString *)[xy valueForKey:@"x"] floatValue]/100.0);
    current.y = canvas.height * ([(NSString *)[xy valueForKey:@"y"] floatValue]/100.0);
    
    NSLog(@"canvas %f, %f -- point ", canvas.height, canvas.width);
    
    if(part == RightEye) {
        right_eye = current;
    }else{
        left_eye = current;
    }
}

-(BOOL)hasEye:(FaceElement)part
{
    if(part == RightEye)
    {
        return (right_eye.x != 0 && right_eye.y != 0);
    }else{
        return (left_eye.x != 0 && left_eye.y != 0);
    }
}

-(float)roll
{
    return (self.left_eye.y - self.right_eye.y) / (self.left_eye.x - self.right_eye.x);
}

@end
