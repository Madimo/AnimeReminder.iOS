//
//  AnimeAPI.h
//  AnimeReminder
//
//  Created by Madimo on 14-3-31.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ERROR_INVALID_KEY   @"ERROR_INVALID_KEY"
#define ERROR_INVALID_PSW   @"ERROR_INVALID_PSW"
#define ERROR_EXIST_EMAIL   @"ERROR_EXIST_EMAIL"
#define ERROR_INVALID_ANIME @"ERROR_INVALID_ANIME"
#define ERROR_INVALID_EPI   @"ERROR_INVALID_EPI"
#define ERROR_EXIST_ANIME   @"ERROR_EXIST_ANIME"
#define ERROR_NETWORK_ERROR @"ERROR_NETWORK_ERROR"
#define ERROR_UNKNOWN       @"ERROR_UNKNOWN"

@interface AnimeAPI : NSObject

/**
 *  Note: all the blank is placeholder
 */

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)())success
                  failure:(void (^)(NSException *exception))failure;

- (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
                     success:(void (^)())success
                     failure:(void (^)(NSException *exception))failure;

- (void)changePasswordWithOldPassword:(NSString *)oldPsw
                          newPassword:(NSString *)newPsw
                              success:(void (^)())success
                              failure:(void (^)(NSException *exception))failure;

- (void)getSubscriptionListWithBlank:(void *)blank
                             success:(void (^)(NSArray *subscriptionItems))success
                             failure:(void (^)(NSException *exception))failure;

- (void)getUpdateScheduleWithBlank:(void *)black
                           success:(void(^)(NSArray *updateScheduleItems))success
                           failure:(void(^)(NSException *exception))failure;

- (void)setEmailReminderEnable:(BOOL)enable
                       success:(void (^)())success
                       failure:(void (^)(NSException *exception))failure;

- (void)getEmailReminderEnableWithBlank:(void *)blank
                                success:(void (^)(BOOL enable))success
                                failure:(void (^)(NSException *exception))failure;

- (void)addAnimeByID:(NSString *)aid
             success:(void (^)())success
             failure:(void (^)(NSException *exception))failure;

- (void)deleteAnimeByID:(NSString *)aid
                success:(void (^)())success
                failure:(void (^)(NSException *exception))failure;

- (void)setIsRead:(BOOL)isRead
     forAnimaByID:(NSString *)aid
          success:(void (^)())success
          failure:(void (^)(NSException *exception))failure;

- (void)setReadEpi:(NSInteger)epi
      forAnimeByID:(NSString *)aid
           success:(void (^)())success
           failure:(void (^)(NSException *exception))failure;

- (void)logout;
- (BOOL)isLogined;

@end
