//
//  SlideMenu.h
//
//  Created by Madimo on 14-3-30.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WantsShowSlideMenuNotification @"WantShowSlideMenuNotification"
#define IMAGE_BLUR_RADIUS_DEFAULT      6.0

@interface SlideMenu : UIViewController

/**
 *  - How to use SlideMenu class
 *
 *  1. call 'init'
 *  2. call 'setBackgroundImage:withBlurRadius:' to set the image
 *  3. call 'addMenuItemWithViewController:name:icon:' to add some menu items
 *  4. call 'finishInitAndShowAtIndex:' to show the view
 *
 *  - How to show slide menu
 *
 *  post the WantsShowSlideMenuNotification to default notification center
 *
 */


- (instancetype)init;
- (void)setBackgroundImage:(UIImage *)backgroundImage withBlurRadius:(CGFloat)radius;
- (void)addMenuItemWithViewController:(UIViewController *)viewController
                                 name:(NSString *)name
                                 icon:(UIImage *)icon;
- (void)finishInitAndShowAtIndex:(NSInteger)index;

@end
