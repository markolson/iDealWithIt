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
        [self setGif:data];
    }
    return self;
}

-(void)setGif:(NSData *)g
{
    [self.gif autorelease];
    gif = [g retain];
    NSLog(@"Got some juicy data: %d", [g length]);
    [self parse];
}

-(bool)parse
{
    pointer = 0;
    if(![[[[NSString alloc] initWithData:[self read:6] encoding:NSUTF8StringEncoding] autorelease] isEqualToString:@"GIF89a"]) {
        return NO;
    }
    
    unsigned char sizebuffer[7];
    [[self read:7] getBytes:sizebuffer length:7];
    
    unsigned char rawbuffer[1];
    while ([self read:1])
    {
        [buffer getBytes:rawbuffer length:1];
        
    }
    NSLog(@"pointer at %d", pointer);
    return YES;
}

-(NSData *)read:(int)length
{
    //if(buffer != nil) { [buffer release]; buffer = nil; }
    if(pointer + length > [gif length]) { return nil; }
    buffer = [gif subdataWithRange:NSMakeRange(pointer, length)];
    pointer += length;
    return buffer;
}
@end
