//
//  SecondViewController.h
//  iDealWithIt
//
//  Created by mark olson on 6/16/12.
//  Copyright (c) 2012 mark olson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptureViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) IBOutlet UIImageView *iView;
@end
