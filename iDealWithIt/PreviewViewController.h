
#import <UIKit/UIKit.h>

#import <WrapperFace/FWImageController.h>
#import <WrapperFace/FWKeysHelper.h>
@interface PreviewViewController : UIViewController <FWImageControllerDelegate, FaceWrapperDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *iView;
@property (retain, nonatomic) UIImage *raw_image;
-(id)initWithImage:(UIImage *)image;
@end
