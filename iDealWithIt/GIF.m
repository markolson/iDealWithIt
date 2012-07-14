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

-(void)dealloc
{
    [frames release];
    [GIF_global release];
    //[gif release];
    [super dealloc];
}

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
    [gif release];
    gif = [g retain];
    [self parse];
}

-(UIImage *)imageFromFrame:(int)frame
{
    return [UIImage imageWithData:((GIFFrame *)frames[frame]).data];
}

-(UIImage *)drawFrame:(int)framenumber withPreviousImage:(UIImage *)lastFrame
{
    if(framenumber == 0)
    {
        return [self imageFromFrame:0];
    }
    
    GIFFrame *frame = (GIFFrame *)frames[framenumber];
    
    CGSize size = lastFrame.size;
    CGRect rect = CGRectZero;
    rect.size = size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -size.height);
    
    CGRect clipRect;
    //NSLog(@"Disposal type %d", frame.disposalMethod);
    switch (frame.disposalMethod)
    {
        case 1: // Do not dispose (draw over context)
            // Create Rect (y inverted) to clipping
            CGContextDrawImage(ctx, rect , lastFrame.CGImage);
            clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
            // Clip Context
            CGContextClipToRect(ctx, clipRect);
            break;
        case 2: // Restore to background the rect when the actual frame will go to be drawed
            // Create Rect (y inverted) to clipping
            clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
            // Clip Context
            CGContextClipToRect(ctx, clipRect);
            break;
        case 3: // Restore to Previous
            // Create Rect (y inverted) to clipping
            clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
            // Clip Context
            CGContextClipToRect(ctx, clipRect);
            break;
    }
    
    UIImage *image = [self imageFromFrame:framenumber];
    CGContextDrawImage(ctx, rect, image.CGImage);
    // Restore State
    CGContextRestoreGState(ctx);
    
    switch (frame.disposalMethod)
    {
        case 2: // Restore to background color the zone of the actual frame
            // Save Context
            CGContextSaveGState(ctx);
            // Change CTM
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextTranslateCTM(ctx, 0.0, -size.height);
            // Clear Context
            CGContextClearRect(ctx, clipRect);
            // Restore Context
            CGContextRestoreGState(ctx);
            break;
        case 3: // Restore to Previous Canvas
            // Save Context
            CGContextSaveGState(ctx);
            // Change CTM
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextTranslateCTM(ctx, 0.0, -size.height);
            // Clear Context
            CGContextClearRect(ctx, frame.area);
            // Draw previous frame
            CGContextDrawImage(ctx, rect, lastFrame.CGImage);
            // Restore State
            CGContextRestoreGState(ctx);
            break;
    }
    UIImage *finale = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finale;
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
        frame.disposalMethod = (header[1] & 0x1c) >> 2;
        frame.delay = (header[2] | header[3] << 8);
        if(frame.delay < 0.1) { frame.delay = 10; }
        pointer -= 8;
        frame.header = [self read:8];
        
        [frames addObject:frame];
        [frame release];

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
	screen = [NSMutableData dataWithBytes:bBuffer length:blength];
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
    [GIF_string release];
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
