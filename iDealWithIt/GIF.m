//
//  GIF.m
//  iDealWithIt
//
//  Created by Mark on 7/9/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "GIF.h"

@implementation GIFFrame

@synthesize data, delay, disposalMethod, area, header;

- (void) dealloc
{
	[data release];
	[header release];
	[super dealloc];
}


@end

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
    
    if (sizebuffer[4] & 0x80) GIF_colorF = 1; else GIF_colorF = 0;
	if (sizebuffer[4] & 0x08) GIF_sorted = 1; else GIF_sorted = 0;
	GIF_colorC = (sizebuffer[4] & 0x07);
	GIF_colorS = 2 << GIF_colorC;
	
	if (GIF_colorF == 1)
    {
		[self read:(3 * GIF_colorS)];
	}
    
    NSLog(@"-whoops. Now at %d", pointer);
    unsigned char rawbuffer[1];
    while ([self read:1])
    {
        [buffer getBytes:rawbuffer length:1];
        if(rawbuffer[0] == 0x38) {  }
        if(rawbuffer[0] == 0x21) { [self readMeta];  }
        //if(rawbuffer[0] == 0x2C) { [self readImage]; }
            
    }
    return YES;
}

-(NSData *)readMeta
{
    unsigned char readbuffer[1];
    [[self read:1] getBytes:readbuffer length:1];
    if(readbuffer[0] == 0xF9)
    {
        unsigned char header[5];
        
        [[self read:5] getBytes:header length:5];
        if(header[0] != 0x04) {
            pointer -= 5; return nil;
        }
        
        //NSLog(@"-Extension Block Found %d", (header[2] | header[3] << 8));
        
        [[self read:1] getBytes:readbuffer length:1];
        if(readbuffer[0] != 0x00) {
            NSLog(@"womp womp");
            pointer -= 6; return nil;
        }
        
        NSLog(@"-read extensions. Now at %d", pointer);

    }else{
        pointer--;
    }
    return nil;
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
