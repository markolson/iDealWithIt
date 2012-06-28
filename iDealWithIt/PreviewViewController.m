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
@synthesize optionBar;
@synthesize found_faces;

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
    

    [self.iView setImage:preview];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = @"Locating Faces";
    hud.dimBackground = true;
}

-(void)viewDidAppear:(BOOL)animated
{
    FaceRecognition *recognizer = [[FaceRecognition alloc] init];
    [recognizer setDelegate:self];
    [recognizer recognizeWithImage:raw_image];
}

-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSArray *)faces {
    self.found_faces = faces;
    [TestFlight passCheckpoint:@"Started Camera"];
    TFLog(@"Found %d face(s)", [faces count]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    for (NSDictionary *face in self.found_faces) {
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
        
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:CGRectMake(x,y,faceWidth,faceHeight)];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];

        [self.iView addSubview:faceView];
    }
    [self addFacesStep];
}

-(void)addFacesStep
{
    [TestFlight passCheckpoint:@"Moved to 'add faces'"];
    UIBarButtonItem *addFace = [[[UIBarButtonItem alloc] initWithTitle:@"Add Faces" style:UIButtonTypeInfoLight target:self action:nil] autorelease];
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(chooseGlassesStep)];
    
    [self.optionBar setItems:@[addFace,spacer,done] animated:YES];
}

-(void)chooseGlassesStep
{
     [TestFlight passCheckpoint:@"Moved to 'choose chrome'"];
    
    UIImage *baseImage = self.iView.image; [UIImage imageNamed:@"abraham_lincoln1.jpg"];
    
   
    //UIImageView *abe = [[UIImageView alloc] initWithImage:finalpic];

    ImageOverlay *io = [[ImageOverlay alloc] initWithFaces:self.found_faces andDimensions:baseImage.size];
    UIImageView *overlay = [[UIImageView alloc] initWithImage:[io layer]];
    
    for (UIView *view in self.iView.subviews) {
        [view removeFromSuperview];
    }
    
    int frame = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.5 block:^
    {
        overlay.image = [io layerAtFrame:frame of:10];
         
    } repeats:YES];
    [self.iView addSubview:overlay];
    

    
    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    UIBarButtonItem *done = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(animationPreviewStep)] autorelease];
    [self.optionBar setItems:@[spacer, done] animated:YES];
}

-(void)animationPreviewStep
{
     [TestFlight passCheckpoint:@"Moved to 'preview'"];
    [[[self.iView subviews] lastObject] removeFromSuperview];
    [self.optionBar setItems:@[] animated:YES];
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
