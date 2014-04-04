//
//  AnimeAPITest.h
//  AnimeReminder
//
//  Created by Madimo on 14-3-31.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimeAPITest : NSObject

- (void)testLoginWithUsername:(NSString *)username password:(NSString *)password;
- (void)testRegisterWithUsername:(NSString *)username password:(NSString *)password;
- (void)testChangePasswordWithOldPassword:(NSString *)oldPsw newPassword:(NSString *)newPsw;
- (void)testGetSubscription;
- (void)testGetUpdateSchedule;
- (void)testSetEmailEnable:(BOOL)enable;
- (void)testGetEmailReminderEnable;
- (void)testAddAnimeByID:(NSString *)aid;
- (void)testDeleteAnimeByID:(NSString *)aid;
- (void)testSetIsRead:(BOOL)isRead forAnimeByID:(NSString *)aid;
- (void)testSetReadEpi:(NSInteger)epi forAnimeByID:(NSString *)aid;

@end
