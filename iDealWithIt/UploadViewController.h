//
//  UploadViewController.h
//  iDealWithIt
//
//  Created by Mark on 7/3/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>


#import "FBUser.h"
#import "MBProgressHUD.h"
#import "ImageOverlay.h"

@interface UploadViewController : UIViewController

@property (nonatomic, retain) FaceViewController *parent;
@property (nonatomic, retain) IBOutlet UIImageView *overlay;
@property (nonatomic, retain) MBProgressHUD *hud;
@end
