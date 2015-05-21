#import <UIKit/UIKit.h>
#import "UIImage+PAL.h"


@implementation UIImage(PAL)

+ (UIImage *) pal_imageWithRect:(CGRect) rect color:(UIColor *) color {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *) pal_stretchableImageWithColor:(UIColor *) color {
    return [[UIImage pal_imageWithRect:CGRectMake(0, 0, 10, 10) color:color]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 4, 4)];
}
@end