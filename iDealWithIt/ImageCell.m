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
    [AnimatedGif getAnimationForGifAtUrl: input];
    canvas.image = [UIImage imageWithData:d];
    gif = [[GIF alloc] initWithData:d];
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
