//
//  UIImage+TintColor.h
//
//  Created by Madimo on 14-3-30.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TintColor)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end
