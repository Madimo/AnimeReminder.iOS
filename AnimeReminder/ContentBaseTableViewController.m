//
//  ContentBaseTableViewController.m
//  RLooking
//
//  Created by Madimo on 14-3-30.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import "ContentBaseTableViewController.h"
#import "SlideMenu.h"

@interface ContentBaseTableViewController ()

@end

@implementation ContentBaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(showSlideMenu)];
    [self.view addGestureRecognizer:recognizer];
    
    UIBarButtonItem *slideMenuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SlideMenuIcon"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(showSlideMenu)];
    self.navigationItem.leftBarButtonItem = slideMenuButton;
}

- (void)showSlideMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WantsShowSlideMenuNotification object:nil];
}

@end
