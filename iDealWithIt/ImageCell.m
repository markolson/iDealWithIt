//
//  ImageCell.m
//  iDealWithIt
//
//  Created by Mark on 7/8/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

@synthesize name, canvas, image, gif;

static dispatch_queue_t queue;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageFromURL:(NSURL *)input
{
    [image autorelease];
    NSData *d = [NSData dataWithContentsOfURL:input];
    //[AnimatedGif getAnimationForGifAtUrl: input];
    //canvas.image = [UIImage imageWithData:d];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        gif = [[GIF alloc] initWithData:d];
        GIFFrame *img = ((GIFFrame *)[gif.frames objectAtIndex:0]);
        dispatch_async(dispatch_get_main_queue(), ^{ canvas.image = [UIImage imageWithData:img.data]; });
        for(GIFFrame *frame in gif.frames)
        {
            NSLog(@"Frame delay is %f", frame.delay);
        }
    });
    //[d release];
}

-(void)dealloc
{
    [gif release];
    [image release];
    NSLog(@"releasing cell %d", [image retainCount]);
    [super dealloc];
}

@end
