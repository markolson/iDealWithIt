//
//  GIF.h
//  iDealWithIt
//
//  Created by Mark on 7/9/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIF : NSObject {
    int pointer;
    NSData *buffer;
    NSMutableData *screen;
}

@property (nonatomic, retain) NSData *gif;

-(id)initWithData:(NSData *)data;
@end
