
#import <UIKit/UIKit.h>
#import "FaceViewController.h"
#import "ImageOverlay.h"
#import "Face.h"
#import "MBProgressHUD.h"

@interface AdjustmentViewController : UIViewController
@property (nonatomic, retain) FaceViewController *parent;

@property (retain, nonatomic) UITapGestureRecognizer *tapper;
@property (retain, nonatomic) iFace *inprogress;
@property (retain, nonatomic) MBProgressHUD *hud;
@end
