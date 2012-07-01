//
//  FaceViewController.h
//  iDealWithIt
//
//  Created by Mark on 7/1/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceViewController : UIViewController


@property (retain, nonatomic) IBOutlet UIView *subContainer;
@property (retain, nonatomic) IBOutlet UIToolbar *optionBar;
@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSMutableArray *faces;
@property (retain, nonatomic) UIViewController *currentController;

-(id)initWithImage:(UIImage *)image;
-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSArray *)response;
@end
