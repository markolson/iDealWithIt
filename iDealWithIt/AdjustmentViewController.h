
#import <UIKit/UIKit.h>
#import "FaceViewController.h"
#import "ImageOverlay.h"
#import "Face.h"

@interface AdjustmentViewController : UIViewController
@property (nonatomic, retain) FaceViewController *parent;

@property (retain, nonatomic) UITapGestureRecognizer *tapper;
@property (retain, nonatomic) iFace *inprogress;
@end
