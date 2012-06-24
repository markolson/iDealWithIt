//
//  FaceRecognition.h
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WrapperFace/FWImageController.h>
#import <WrapperFace/FWKeysHelper.h>

#import "UIImage+Resize.h"


@interface FaceRecognition : NSObject

@property (nonatomic, strong) UIImage *original;
@property (nonatomic, retain) id delegate;

- (void) recognizeWithFace;
- (id)initWithImage:(UIImage *)image andDelegate:(id)delegate;

@end
