//
//  SlideMenu.m
//
//  Created by Madimo on 14-3-30.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import "SlideMenu.h"
#import "SlideMenuItem.h"
#import "UIImage+TintColor.h"
#import <GPUImage.h>

#define BACKGROUND_MASK_ALPHA              0.3
#define TABLEVIEW_CELL_HEIGHT              60.0
#define GLOBAL_FOREGROUND_COLOR            ([UIColor colorWithWhite:1 alpha:0.2])

@interface SlideMenu() <UITableViewDataSource, UITableViewDelegate>
{
    CGRect screenBounds;
}

@property (strong, nonatomic) UIWindow *mainWindow;
@property (strong, nonatomic) UIWindow *contentWindow;
@property (strong, nonatomic) GPUImageView *backgroundImageView;
@property (strong, nonatomic) UIView *backgroundMaskView;
@property (strong, nonatomic) UITableView *menuTableView;
@property (strong, nonatomic) UIView *contentMaskView;
@property (strong, nonatomic) UITapGestureRecognizer *recognizer;
@property (strong, nonatomic) NSMutableArray *menuItems;
@property (strong, nonatomic) UIViewController *CurrentController;
@property (nonatomic) BOOL isSlideMenuVisible;
@end

@implementation SlideMenu

#pragma mark - Initialize and dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self slideMenuInit];
    }
    return self;
}

- (void)slideMenuInit
{
    screenBounds = [UIScreen mainScreen].bounds;
    CGRect frame = screenBounds;
    
    self.mainWindow = [[UIWindow alloc] initWithFrame:frame];
    self.mainWindow.backgroundColor = [UIColor whiteColor];
    
    self.contentWindow = [[UIWindow alloc] initWithFrame:frame];
    self.contentWindow.backgroundColor = [UIColor whiteColor];
    [self.contentWindow.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.contentWindow.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.contentWindow.layer setShadowOpacity:0.6];
    [self.contentWindow.layer setShadowRadius:12.0];
    
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.backgroundImageView = [[GPUImageView alloc] initWithFrame:frame];
    [self.view addSubview:self.backgroundImageView];
    
    self.backgroundMaskView = [[UIView alloc] initWithFrame:frame];
    self.backgroundMaskView.backgroundColor = [UIColor blackColor];
    self.backgroundMaskView.alpha = BACKGROUND_MASK_ALPHA;
    [self.view addSubview:self.backgroundMaskView];
    
    CGRect menuTableViewFrame = frame;
    menuTableViewFrame.size.width -= (frame.size.width / 4.0 + 20);
    self.menuTableView = [[UITableView alloc] initWithFrame:menuTableViewFrame
                                                      style:UITableViewStyleGrouped];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.separatorColor = GLOBAL_FOREGROUND_COLOR;
    self.menuTableView.sectionIndexTrackingBackgroundColor = GLOBAL_FOREGROUND_COLOR;
    self.menuTableView.scrollEnabled = NO;
    self.menuTableView.separatorInset = UIEdgeInsetsZero;
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    [self.view addSubview:self.menuTableView];
    
    self.contentMaskView = [[UIView alloc] initWithFrame:frame];
    self.contentMaskView.backgroundColor = [UIColor blackColor];
    self.contentMaskView.alpha = 0;
    
    self.menuItems = [[NSMutableArray alloc] init];
    
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleGesture:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSlideMenu)
                                                 name:WantsShowSlideMenuNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:WantsShowSlideMenuNotification
                                                  object:nil];
}

#pragma mark - Gesture

- (void)handleGesture:(UITapGestureRecognizer *)recognizer
{
    [self hideSlideMenu];
}

#pragma mark - Public method

- (void)setBackgroundImage:(UIImage *)backgroundImage withBlurRadius:(CGFloat)radius
{
    GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = radius;
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:backgroundImage];
    [picture addTarget:blurFilter];
    [blurFilter addTarget:self.backgroundImageView];
    [picture processImage];
}

- (void)addMenuItemWithViewController:(UIViewController *)viewController
                                 name:(NSString *)name
                                 icon:(UIImage *)icon
{
    SlideMenuItem *menuItem = [[SlideMenuItem alloc] init];
    menuItem.viewController = viewController;
    menuItem.name = name;
    menuItem.icon = [icon imageWithTintColor:GLOBAL_FOREGROUND_COLOR
                                   blendMode:kCGBlendModeDestinationIn];
    [self.menuItems addObject:menuItem];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.menuItems.count - 1 inSection:0];
    [self.menuTableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    
    CGRect frame = self.menuTableView.frame;
    frame.size.height = (self.menuItems.count + 1.2) * TABLEVIEW_CELL_HEIGHT +
    self.menuTableView.tableHeaderView.frame.size.height +
    self.menuTableView.tableFooterView.frame.size.height;
    frame.origin.y = self.view.center.y - frame.size.height / 2.0;
    self.menuTableView.frame = frame;
}

- (void)finishInitAndShowAtIndex:(NSInteger)index
{
    SlideMenuItem *menuItem = self.menuItems[index];
    
    self.mainWindow.rootViewController = self;
    [self.mainWindow makeKeyAndVisible];
    
    self.contentWindow.rootViewController = menuItem.viewController;
    [self.contentWindow makeKeyAndVisible];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.menuTableView selectRowAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Show and hide

- (void)showSlideMenu
{
    if (self.isSlideMenuVisible)
        return;
    
    [self startShowAnimation];
    [self.contentWindow addGestureRecognizer:self.recognizer];
}

- (void)hideSlideMenu
{
    if (!self.isSlideMenuVisible)
        return;
    
    [self.contentWindow removeGestureRecognizer:self.recognizer];
    [self startHideAnimation];
}

#pragma mark - Animations

- (void)startShowAnimation
{
    [self.contentWindow addSubview:self.contentMaskView];
    
    [UIView beginAnimations:nil context:nil];
    CGAffineTransform transform = CGAffineTransformScale(self.contentWindow.transform, 0.5, 0.5);
    [self.contentWindow setTransform:transform];
    CGPoint center = self.view.center;
    center.x = screenBounds.size.width;
    self.contentWindow.center = center;
    self.contentWindow.alpha = 0.5;
    self.contentMaskView.alpha = 0.3;
    [UIView commitAnimations];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.isSlideMenuVisible = YES;
}

- (void)startHideAnimation
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformConcat(self.contentWindow.transform,
                                                                               CGAffineTransformInvert(self.contentWindow.transform));
                         [self.contentWindow setTransform:transform];
                         self.contentWindow.center = self.view.center;
                         self.contentWindow.alpha = 1;
                         self.contentMaskView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.contentMaskView removeFromSuperview];
                         [self.menuTableView setAllowsSelection:YES];
                     }
     ];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.isSlideMenuVisible = NO;
}

- (void)hideContentWindow:(SlideMenuItem *)menuItem
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGPoint center = self.contentWindow.center;
                         center.x = screenBounds.size.width * 1.5;
                         self.contentWindow.center = center;
                         self.contentWindow.alpha = 0.1;
                     }
                     completion:^(BOOL finished) {
                         [self loadViewController:menuItem.viewController];
                     }
     ];
}

- (void)loadViewController:(UIViewController *)viewController
{
    self.CurrentController = viewController;
    self.contentWindow.rootViewController = viewController;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [UIView setAnimationDelay:0.2];
                         CGPoint center = self.contentWindow.center;
                         center.x = screenBounds.size.width;
                         self.contentWindow.center = center;
                         self.contentWindow.alpha = 0.5;
                     }
                     completion:^(BOOL finished) {
                         [self hideSlideMenu];
                     }
     ];
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SlideMenuItemCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"SlideMenuItemCell"];
    }
    
    SlideMenuItem *item = self.menuItems[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.textLabel.textColor = GLOBAL_FOREGROUND_COLOR;
    cell.imageView.image = item.icon;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = GLOBAL_FOREGROUND_COLOR;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLEVIEW_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setAllowsSelection:NO];
    
    SlideMenuItem *menuItem = self.menuItems[indexPath.row];
    if (menuItem.viewController == self.CurrentController) {
        [self hideSlideMenu];
        return;
    }
    
    [self hideContentWindow:menuItem];
}

@end
