//
//  FaceViewController.h
//  iDealWithIt
//
//  Created by Mark on 7/1/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FaceRecognition.h"



@interface FaceViewController : UINavigationController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate> {
    UINavigationController *nav;
}

@property (retain, nonatomic) IBOutlet UIImageView *subContainer;
@property (retain, nonatomic) IBOutlet UIToolbar *optionBar;

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSMutableArray *faces;
@property (retain, nonatomic) FaceRecognition *recognizer;

@property (retain, nonatomic) UIViewController *chooseFacesController;
@property (retain, nonatomic) UIViewController *chooseGlassesController;
@property (retain, nonatomic) UIViewController *chooseDestinationController;

-(id)initWithImage:(UIImage *)image;
-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSArray *)response;

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
