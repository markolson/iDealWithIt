//
//  ImageCell.m
//  iDealWithIt
//
//  Created by Mark on 7/8/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

@synthesize name, gif;

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

-(void)play:(NSString *)video{
    // Load test.gif VideoSource
    NSLog(@"img: %@", video);
    NSString *str = [[NSBundle mainBundle] pathForResource:video ofType:nil];
    FILE *fp = fopen([str UTF8String], "r");
    VideoSource *src = VideoSource_init(fp, VIDEOSOURCE_FILE);
    src->writeable = false;
    
    // Init video using VideoSource
    Video *vid = [[GifVideo alloc] initWithSource:src inContext:[gif context]];
    VideoSource_release(src);
    
    // Start if loaded
    if (vid) {
        [gif startAnimation:vid];
        [vid release];
    }
    
    // Cleanup if failed
    fclose(fp);
}

@end
