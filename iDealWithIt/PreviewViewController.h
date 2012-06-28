
#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"
#import "FaceRecognition.h"
#import "ImageOverlay.h"
#import "MBProgressHUD.h"
#import "NSTimer+Blocks.h"

@interface PreviewViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *iView;
@property (retain, nonatomic) IBOutlet UIToolbar *optionBar;
@property (retain, nonatomic) UIImage *raw_image;
@property (retain, nonatomic) NSArray *found_faces;

-(id)initWithImage:(UIImage *)image;
-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSArray *)response;

-(void)addFacesStep;
-(void)chooseGlassesStep;
@end
