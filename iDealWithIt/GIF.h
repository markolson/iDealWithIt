//
//  GIF.h
//  iDealWithIt
//
//  Created by Mark on 7/9/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIFFrame : NSObject
{
	NSMutableData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;

@end

@interface GIF : NSObject {
    int pointer;
    NSData *buffer;
    NSMutableData *screen;
	NSMutableData *GIF_global;
    
    int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
}

@property (nonatomic, retain) NSData *gif;


@property (nonatomic, copy) NSMutableArray *frames;

-(id)initWithData:(NSData *)data;

@end
