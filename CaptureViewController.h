//
//  SecondViewController.h
//  iDealWithIt
//
//  Created by mark olson on 6/16/12.
//  Copyright (c) 2012 mark olson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface CaptureViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) UIImage *rawimage;
@property (retain, nonatomic) IBOutlet GLKView *iView;
@end
