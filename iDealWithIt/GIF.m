//
//  GIF.m
//  iDealWithIt
//
//  Created by Mark on 7/9/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "GIF.h"

@implementation GIF
@synthesize gif;

-(id)initWithData:(NSData *)data
{
    self = [super init];
    if(self)
    {
        gif = data;
    }
    return self;
}
@end
