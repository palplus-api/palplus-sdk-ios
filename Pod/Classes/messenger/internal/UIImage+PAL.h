#import <Foundation/Foundation.h>

@interface UIImage(PAL)
+ (UIImage*) pal_imageWithRect:(CGRect) rect color:(UIColor*) color;

+ (UIImage*) pal_stretchableImageWithColor:(UIColor*) color;
@end