//
//  ImageOverlay.h
//  iDealWithIt
//
//  Created by Mark on 6/27/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Face.h"

@interface ImageOverlay : NSObject

@property (retain, nonatomic) UIImage *layer;
@property (retain, nonatomic) NSArray *faces;
@property (nonatomic) CGSize dimensions;
@property (nonatomic) float frame_count;
@property (nonatomic) int current_frame;

- (UIImage *)nextFrame;
- (UIImage *)layerAtFrame:(int)frame_number of:(int)total_frames;
- (ImageOverlay *)setFrames:(int)frames;
- (id)initWithFaces:(NSArray *)faces andDimensions:(CGSize)dimensions;
- (BOOL)isLastFrame;
@end
