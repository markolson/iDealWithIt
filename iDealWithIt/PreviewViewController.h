
#import <UIKit/UIKit.h>
#import "FaceViewController.h"
#import "ImageOverlay.h"
#import "Face.h"

@interface PreviewViewController : UIViewController
@property (nonatomic, retain) FaceViewController *parent;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@end
