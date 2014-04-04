//
//  SubscriptionItem.h
//  AnimeReminder
//
//  Created by Madimo on 14-3-31.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionItem : NSObject
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL isOver;
@property (nonatomic) BOOL isRead;
@property (nonatomic) NSInteger episode;
@property (nonatomic) NSInteger watch;
@end
