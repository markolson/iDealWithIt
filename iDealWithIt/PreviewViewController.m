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

-(void)viewDidAppear:(BOOL)animated
{
    FaceRecognition *recognizer = [[FaceRecognition alloc] initWithImage:raw_image andDelegate:self];
    [recognizer recognizeWithFace];
}

-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSDictionary *)faces {
    for (NSDictionary *face in faces) {
        NSLog(@"face; %@", face);
        float bw = self.iView.bounds.size.width;
        float bh = self.iView.bounds.size.height;
        
        float center_x = bw * ([(NSString *)[(NSDictionary *)[face objectForKey:@"center"] valueForKey:@"x"] floatValue]/100.0);
        float center_y = bh * ([(NSString *)[(NSDictionary *)[face objectForKey:@"center"] valueForKey:@"y"] floatValue]/100.0);

        
        float width = [(NSString *)[face valueForKey:@"width"] floatValue];
        float height = [(NSString *)[face valueForKey:@"height"] floatValue];
        
        float faceWidth = bw * (width/100.0);
        float faceHeight = bh * (height/100.0);
        
        float x = center_x - (faceWidth/2.0);
        float y = center_y - (faceHeight/2.0);
        
        NSLog(@"hmm. x: %f, y: %f, w: %f, h: %f", x,y,faceWidth,faceHeight );
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:CGRectMake(x,y,faceWidth,faceHeight)];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        // add the new view to create a box around the face
        NSLog(@":%@", [self.iView description]);
        [self.iView addSubview:faceView];
    }
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
