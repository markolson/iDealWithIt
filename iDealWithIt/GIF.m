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
@synthesize gif, frames;

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
    [self parse];
}

-(bool)parse
{
    frames = [[NSMutableArray alloc] init];
    GIF_global = [[NSMutableData alloc] init];
    
    pointer = 0;
    if(![[[[NSString alloc] initWithData:[self read:6] encoding:NSUTF8StringEncoding] autorelease] isEqualToString:@"GIF89a"]) {
        return NO;
    }
    
    unsigned char sizebuffer[7];
    [[self read:7] getBytes:sizebuffer length:7];
    screen = [buffer mutableCopy];
    
    if (sizebuffer[4] & 0x80) GIF_colorF = 1; else GIF_colorF = 0;
	if (sizebuffer[4] & 0x08) GIF_sorted = 1; else GIF_sorted = 0;
	GIF_colorC = (sizebuffer[4] & 0x07);
	GIF_colorS = 2 << GIF_colorC;
	
	if (GIF_colorF == 1)
    {
		[self read:(3 * GIF_colorS)];
        [GIF_global setData:buffer];
	}
    
    
    unsigned char rawbuffer[1];
    while ([self read:1])
    {
        [buffer getBytes:rawbuffer length:1];
        if(rawbuffer[0] == 0x38) {  }
        if(rawbuffer[0] == 0x21) { [self readMeta];  }
        if(rawbuffer[0] == 0x2C) { [self readImage]; }
            
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
        
        [[self read:1] getBytes:readbuffer length:1];
        if(readbuffer[0] != 0x00) {
            NSLog(@"womp womp");
            pointer -= 6; return nil;
        }
        
        GIFFrame *frame = [[GIFFrame alloc] init];
        frame.disposalMethod = (header[0] & 0x1c) >> 2;
        frame.delay = (header[1] | header[2] << 8);
        
        pointer -= 8;
        frame.header = [self read:8];
        
        [frames addObject:frame];
        //[frame release];

    }else{
        pointer--;
    }
    return nil;
}

-(NSData *)readImage
{
    unsigned char readbuffer[9];
    [[self read:9] getBytes:readbuffer length:9];
	NSMutableData *GIF_screenTmp = [NSMutableData dataWithData:buffer];
	
	CGRect rect;
	rect.origin.x = ((int)readbuffer[1] << 8) | readbuffer[0];
	rect.origin.y = ((int)readbuffer[3] << 8) | readbuffer[2];
	rect.size.width = ((int)readbuffer[5] << 8) | readbuffer[4];
	rect.size.height = ((int)readbuffer[7] << 8) | readbuffer[6];
    
    
	GIFFrame *frame = [frames lastObject];
	frame.area = rect;

    
    if (readbuffer[8] & 0x80) GIF_colorF = 1; else GIF_colorF = 0;
	
	unsigned char GIF_code = GIF_colorC, GIF_sort = GIF_sorted;
	
	if (GIF_colorF == 1)
    {
		GIF_code = (readbuffer[8] & 0x07);
        
		if (readbuffer[8] & 0x20)
        {
            GIF_sort = 1;
        }
        else
        {
        	GIF_sort = 0;
        }
	}
	
	int GIF_size = (2 << GIF_code);
    
    size_t blength = [screen length];
	unsigned char bBuffer[blength];
	[screen getBytes:bBuffer length:blength];
	
	bBuffer[4] = (bBuffer[4] & 0x70);
	bBuffer[4] = (bBuffer[4] | 0x80);
	bBuffer[4] = (bBuffer[4] | GIF_code);
	
	if (GIF_sort)
    {
		bBuffer[4] |= 0x08;
	}

    //gooood
    
    NSMutableData *GIF_string = [NSMutableData dataWithData:[@"GIF89a" dataUsingEncoding: NSUTF8StringEncoding]];
	[screen setData:[NSData dataWithBytes:bBuffer length:blength]];
    [GIF_string appendData: screen];
    
	if (GIF_colorF == 1)
    {
		[GIF_string appendData:[self read:(3 * GIF_size)]];
	}
    else
    {
		[GIF_string appendData:GIF_global];
	}
	
    
	// Add Graphic Control Extension Frame (for transparancy)
	[GIF_string appendData:frame.header];
	
	char endC = 0x2c;
	[GIF_string appendBytes:&endC length:sizeof(endC)];
	
	size_t clength = [GIF_screenTmp length];
	unsigned char cBuffer[clength];
	[GIF_screenTmp getBytes:cBuffer length:clength];
	
	cBuffer[8] &= 0x40;
	
	[GIF_screenTmp setData:[NSData dataWithBytes:cBuffer length:clength]];
	
	[GIF_string appendData: GIF_screenTmp];
	
	[GIF_string appendData: [self read:1]];
	
	while (true)
    {
		[self read:1];
		[GIF_string appendData: buffer];
		
		unsigned char dBuffer[1];
		[buffer getBytes:dBuffer length:1];
		
		long u = (long) dBuffer[0];
        
		if (u != 0x00)
        {
			
			[GIF_string appendData: [self read:u]];
        }
        else
        {
            break;
        }
        
	}
	
	endC = 0x3b;
	[GIF_string appendBytes:&endC length:sizeof(endC)];
	
	// save the frame into the array of frames
	frame.data = [GIF_string retain];
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
