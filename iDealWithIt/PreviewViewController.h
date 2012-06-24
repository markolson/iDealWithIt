
#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"
#import "FaceRecognition.h"

@interface PreviewViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *iView;
@property (retain, nonatomic) UIImage *raw_image;
-(id)initWithImage:(UIImage *)image;

-(void)FaceRecognizer:(id)recognizer didFindFaces:(NSDictionary *)response;

@end
