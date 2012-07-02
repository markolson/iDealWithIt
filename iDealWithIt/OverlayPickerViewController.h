//
//  OverlayPickerViewController.h
//  iDealWithIt
//
//  Created by Mark on 7/1/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceViewController.h"

@interface OverlayPickerViewController : UIViewController

@property (nonatomic, retain) FaceViewController *parent;
@property (nonatomic, retain) IBOutlet UIImageView *overlay;

@end
