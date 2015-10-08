//
//  UIImage+InvertColor.m
//  eventCam
//
//  Created by Tarik Fayad on 10/8/15.
//  Copyright © 2015 Electronic Graffiti. All rights reserved.
//

#import "UIImage+InvertColor.h"

@implementation UIImage (InvertColor)

+ (UIImage *)getInvertedImageFromImage:(UIImage *)image
{
    CIImage *coreImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:coreImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    return [UIImage imageWithCIImage:result scale:image.scale orientation:image.imageOrientation];
}

@end
