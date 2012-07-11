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
	NSData *data;
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
    
    int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
}

@property (nonatomic, retain) NSData *gif;

-(id)initWithData:(NSData *)data;
@end
