
#import <UIKit/UIKit.h>

#import <WrapperFace/FWImageController.h>
#import <WrapperFace/FWKeysHelper.h>

#import "UIImage+Resize.h"

@interface PreviewViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *iView;
@property (retain, nonatomic) UIImage *raw_image;
-(id)initWithImage:(UIImage *)image;
@end
