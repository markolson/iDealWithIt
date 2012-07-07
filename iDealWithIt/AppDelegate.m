//
//  AppDelegate.m
//  iDealWithIt
//
//  Created by mark olson on 6/16/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import "CaptureViewController.h"


#import "AdjustmentViewController.h"
#import "OverlayPickerViewController.h"
#import "UploadViewController.h"

@interface Feedback : UIViewController
@end
@implementation Feedback
-(id)init
{
    self = [super init];
    self.title = NSLocalizedString(@"Feedback", @"Feedback");
    self.tabBarItem.image = [UIImage imageNamed:@"help_30.png"];
    return self;
}
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize workflowController;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef RELEASE
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"f904d8336e0e5e80ab1eec89ea382cae_MTAwODE4MjAxMi0wNi0xNiAxMzozMjo0NC43Mzg0ODU"];
#endif
    [TestFlight passCheckpoint:@"Started App"];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    UIViewController *viewController1, *viewController2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController_iPhone" bundle:nil] autorelease];

        viewController2 = [[[CaptureViewController alloc] init] autorelease];
    } else {
        viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController_iPad" bundle:nil] autorelease];
        viewController2 = [[[CaptureViewController alloc] initWithNibName:@"CaptureViewController_iPad" bundle:nil] autorelease];
    }
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, [[[Feedback alloc] init] autorelease], nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass:[Feedback class]])
    {
        [TestFlight openFeedbackView];
        return NO;
    }
    return YES;
}

- (void) showPreviewWithImage:(UIImage *)raw
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    workflowController = [[FaceViewController alloc] initWithImage:raw];
    [self.window setRootViewController:workflowController];
}

- (void) showMainPage
{
    [self.tabBarController setSelectedIndex:0];
    [self.window setRootViewController:self.tabBarController];
    if([workflowController isKindOfClass:[FaceViewController class]])
    {
        //[workflowController clean];
        [workflowController release];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
