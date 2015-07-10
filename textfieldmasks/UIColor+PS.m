//
//  UIColor+Energia.m
//  Energia
//
//  Created by João Paulo Ros on 14/07/14.
//  Copyright (c) 2014 PremierSoft. All rights reserved.
//

#import "UIColor+PS.h"

@implementation UIColor (CemUmDia)

+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}


+ (UIColor *)colorFromHexString:(NSString *)hexStr {
    return [self colorFromHexString:hexStr alpha:1.0f];
}

+ (UIColor *)colorFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [UIColor intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255.0f
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255.0f
                     blue:((CGFloat) (hexint & 0xFF))/255.0f
                    alpha:alpha];
    
    return color;
}

@end
