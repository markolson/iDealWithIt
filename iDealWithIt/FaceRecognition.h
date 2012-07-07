//
//  FaceRecognition.h
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImage+Resize.h"


@interface FaceRecognition : NSObject

@property (nonatomic, strong) UIImage *original;
@property (nonatomic, retain) id delegate;
@property (nonatomic) CGSize canvas;


- (id)initWithImage:(UIImage *)image andDelegate:(id)delegate;
- (void) recognizeWithImage:(UIImage *)image andFinalSize:(CGSize)canvas;

- (void) recognizeUsingIOS;

@end
