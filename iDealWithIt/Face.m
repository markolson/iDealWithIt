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


-(void)setEye:(FaceElement)part withDictionary:(NSDictionary *)xy andDimensions:(CGSize)canvas{
    CGPoint current = CGPointMake(0.0, 0.0);
    current.x = canvas.width * ([(NSString *)[xy valueForKey:@"x"] floatValue]/100.0);
    current.y = canvas.height * ([(NSString *)[xy valueForKey:@"y"] floatValue]/100.0);
    
    if(part == RightEye) {
        right_eye = current;
    }else{
        left_eye = current;
    }
}

@end
