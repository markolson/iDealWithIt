//
//  ImageCell.h
//  iDealWithIt
//
//  Created by Mark on 7/8/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"

#import "GifVideo.h"
#import "VideoSource.h"
#import "PlayerView.h"

@interface ImageCell : UITableViewCell {

}

-(void)play:(NSString *)source;

@property (nonatomic, retain) IBOutlet PlayerView *gif;
@property (nonatomic, retain) IBOutlet UILabel *name;
@end
