//
//  UIColor+Energia.h
//  Energia
//
//  Created by João Paulo Ros on 14/07/14.
//  Copyright (c) 2014 PremierSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CemUmDia)
+ (UIColor *)colorFromHexString:(NSString *)hexStr;
+ (UIColor *)colorFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end
