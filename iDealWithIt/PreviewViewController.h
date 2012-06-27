
#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"
#import "FaceRecognition.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface PreviewViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *iView;
@property (retain, nonatomic) IBOutlet UIToolbar *optionBar;
@property (retain, nonatomic) UIImage *raw_image;
-(id)recognizeWithImage:(UIImage *)image;

-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSDictionary *)response;

-(void)addFacesStep;
-(void)chooseGlassesStep;
@end
