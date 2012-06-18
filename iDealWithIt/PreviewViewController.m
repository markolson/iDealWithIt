//
//  PreviewViewController.m
//  iDealWithIt
//
//  Created by mark olson on 6/17/12.
//  Copyright (c) 2012 syntaxi. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController
@synthesize iView;
@synthesize raw_image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    float scale = 1.0;
    if(raw_image.size.height > iView.frame.size.height || raw_image.size.width > iView.frame.size.width)
    {
        float extra_height = raw_image.size.height - iView.frame.size.height;
        float extra_width = raw_image.size.width - iView.frame.size.width;

        /**
        if(extra_height < extra_width)
        {
            scale = raw_image.size.height/iView.frame.size.height;
        }else{
            scale = raw_image.size.width/iView.frame.size.width;
        }**/
        if(extra_height > 0) { scale = raw_image.size.height/iView.frame.size.height; }
    }

    UIImage *preview = [raw_image resizedImage:CGSizeMake(raw_image.size.width/scale, raw_image.size.height/scale) interpolationQuality:kCGInterpolationLow];
    
    NSLog(@"oh boy Frame %fx%f Image %fx%f,  %f -> endImage %fx%f",
        iView.frame.size.height, iView.frame.size.width,
        raw_image.size.height, raw_image.size.width,
        scale,
        raw_image.size.height/scale, raw_image.size.width/scale
    );


    [self.iView setImage:preview];
    

}

-(id)initWithImage:(UIImage *)image
{
    self = [super initWithNibName:@"PreviewViewController_iPhone" bundle:nil];
    self.raw_image = image;
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
