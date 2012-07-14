//
//  ImageCell.m
//  iDealWithIt
//
//  Created by Mark on 7/8/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

@synthesize name, canvas, image, gif, animator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageFromURL:(NSURL *)input
{
    if([animator isValid])
    {
        [animator invalidate];
        [gif release];
    }
    
    [image autorelease];
    NSData *d = [NSData dataWithContentsOfURL:input];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        gif = [[GIF alloc] initWithData:d];
        dispatch_async(dispatch_get_main_queue(), ^{
            canvas.image = [gif imageFromFrame:0];
            [self drawNextFrame:nil];
        });
        [d release];
    });
}


-(void)drawNextFrame:(NSTimer *)timer
{
    if(current_frame >= [gif.frames count]) { current_frame = 0; }
    GIFFrame *t = (GIFFrame *)[gif.frames objectAtIndex:current_frame];
    dispatch_async(dispatch_get_main_queue(), ^{
        canvas.image = [gif drawFrame:current_frame withPreviousImage:canvas.image];
        animator = [NSTimer scheduledTimerWithTimeInterval:t.delay/100.0 target:self selector:@selector(drawNextFrame:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:animator forMode:NSRunLoopCommonModes];
        current_frame++;
    });
}

-(void)dealloc
{
    [animator invalidate];
    [animator release];
    [gif release];
    [image release];
    [super dealloc];
}

@end
