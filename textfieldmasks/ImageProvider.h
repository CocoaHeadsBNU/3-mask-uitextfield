//
//  ImageProvider.h
//  Energia
//
//  Created by João Paulo Ros on 23/07/14.
//  Copyright (c) 2014 PremierSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageProvider : NSObject
@property (nonatomic, strong) NSString *providerName;
@property (nonatomic, strong) NSString *customUserAgent;
+ (ImageProvider *)defaultProvider;
- (void)imageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
@end
