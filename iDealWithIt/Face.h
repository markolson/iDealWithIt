//
//  Face.h
//  iDealWithIt
//
//  Created by Mark on 6/26/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    RightEye,
    LeftEye
} FaceElement;


@interface iFace : NSObject

@property (nonatomic) CGPoint left_eye;
@property (nonatomic) CGPoint right_eye;
@property (nonatomic) float pitch;
@property (nonatomic) float roll;
@property (nonatomic) float yaw;

-(void)setEye:(FaceElement)part withDictionary:(NSDictionary *)xy;
-(void)setEye:(FaceElement)part withDictionary:(NSDictionary *)xy andDimensions:(CGSize)canvas;
-(BOOL)hasEye:(FaceElement)part;
@end
