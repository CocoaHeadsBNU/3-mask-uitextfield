//
//  UIImage+Energia.m
//  Energia
//
//  Created by João Paulo Ros on 14/07/14.
//  Copyright (c) 2014 PremierSoft. All rights reserved.
//

#import "UIImage+PS.h"

@implementation UIImage (CemUmDia)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
