//
//  UIFont+Energia.m
//  Energia
//
//  Created by João Paulo Ros on 14/07/14.
//  Copyright (c) 2014 PremierSoft. All rights reserved.
//

#import "UIFont+PS.h"

@implementation UIFont (CemUmDia)

+ (UIFont*)avenirRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
}
+ (UIFont*)avenirMediumWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Medium" size:size];
}

+ (UIFont*)avenirDemiWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
}
+ (UIFont*)avenirObliqueWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Oblique" size:size];
}

+ (UIFont*)avenirRomanWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Roman" size:size];
}
@end
