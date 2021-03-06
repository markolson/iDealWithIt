//
//  AppDelegate.h
//  iDealWithIt
//
//  Created by mark olson on 6/16/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (retain, nonatomic) FaceViewController *workflowController;

-(void)showPreviewWithImage:(UIImage *)raw;
-(void)showMainPage;
@end
