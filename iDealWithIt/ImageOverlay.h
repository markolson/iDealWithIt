//
//  ImageOverlay.h
//  iDealWithIt
//
//  Created by Mark on 6/27/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageOverlay : NSObject

@property (retain, nonatomic) UIImage *layer;
@property (retain, nonatomic) NSArray *faces;
@property (nonatomic) CGSize dimensions;

- (id)initWithFaces:(NSArray *)faces andDimensions:(CGSize)dimensions;
- (UIImage *)layerAtFrame:(int)frame_number of:(int)total_frames;
@end
