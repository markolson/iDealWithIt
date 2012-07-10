//
//  ImageCell.h
//  iDealWithIt
//
//  Created by Mark on 7/8/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIF.h"

@interface ImageCell : UITableViewCell {

}

@property (nonatomic, retain) IBOutlet UIImageView *canvas;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) GIF *gif;

-(void)setImageFromURL:(NSURL *)path;
@end
