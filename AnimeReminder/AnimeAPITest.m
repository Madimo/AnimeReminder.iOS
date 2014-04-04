//
//  AnimeAPITest.m
//  AnimeReminder
//
//  Created by Madimo on 14-3-31.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import "AnimeAPITest.h"
#import "AnimeAPI.h"
#import "SubscriptionItem.h"
#import "UpdateScheduleItem.h"

@implementation AnimeAPITest

- (void)testLoginWithUsername:(NSString *)username password:(NSString *)password
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api loginWithUsername:username
                  password:password
                   success:^{
                       
                   }
                   failure:^(NSException *exception) {
                       MakeTestFailure(exception);
                   }
     ];
}

- (void)testRegisterWithUsername:(NSString *)username password:(NSString *)password
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api registerWithUsername:username
                     password:password
                      success:^{
                          
                      }
                      failure:^(NSException *exception) {
                          MakeTestFailure(exception);
                      }
     ];
}

- (void)testChangePasswordWithOldPassword:(NSString *)oldPsw newPassword:(NSString *)newPsw
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api changePasswordWithOldPassword:oldPsw
                           newPassword:newPsw
                               success:^{
                                   
                               }
                               failure:^(NSException *exception) {
                                   MakeTestFailure(exception);
                               }
     ];
}

- (void)testGetSubscription
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api getSubscriptionListWithBlank:nil
                              success:^(NSArray *subscriptionItems) {
                                  for (SubscriptionItem *item in subscriptionItems) {
                                      debugLog(@"[%@]%@[o%d:r%d:e%d:w%d]", item.aid, item.name, item.isOver,
                                               item.isRead, item.episode, item.watch);
                                  }
                              }
                              failure:^(NSException *exception) {
                                  MakeTestFailure(exception);
                              }
     ];
}

- (void)testGetUpdateSchedule
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api getUpdateScheduleWithBlank:nil
                            success:^(NSArray *updateScheduleItems) {
                                for (UpdateScheduleItem *item in updateScheduleItems) {
                                    debugLog(@"%@[%@](%@)(%@)", item.name, item.url, item.week, item.time);
                                }
                            }
                            failure:^(NSException *exception) {
                                MakeTestFailure(exception);
                            }
     ];
}

- (void)testSetEmailEnable:(BOOL)enable
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api setEmailReminderEnable:enable
                        success:^{
                            
                        }
                        failure:^(NSException *exception) {
                            MakeTestFailure(exception);
                        }
     ];
}

- (void)testGetEmailReminderEnable
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api getEmailReminderEnableWithBlank:nil
                                 success:^(BOOL enable) {
                                     debugLog(@"enable:%d", enable);
                                 }
                                 failure:^(NSException *exception) {
                                     MakeTestFailure(exception);
                                 }
     ];
}

- (void)testAddAnimeByID:(NSString *)aid
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api addAnimeByID:aid
              success:^{
                  
              }
              failure:^(NSException *exception) {
                  MakeTestFailure(exception);
              }
     ];
}

- (void)testDeleteAnimeByID:(NSString *)aid
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api deleteAnimeByID:aid
                 success:^{
                     
                 }
                 failure:^(NSException *exception) {
                     MakeTestFailure(exception);
                 }
     ];
}

- (void)testSetIsRead:(BOOL)isRead forAnimeByID:(NSString *)aid
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api setIsRead:isRead
      forAnimaByID:aid
           success:^{
               
           }
           failure:^(NSException *exception) {
               MakeTestFailure(exception);
           }
     ];
}

- (void)testSetReadEpi:(NSInteger)epi forAnimeByID:(NSString *)aid
{
    AnimeAPI *api = [[AnimeAPI alloc] init];
    [api setReadEpi:epi
       forAnimeByID:aid
            success:^{
                
            }
            failure:^(NSException *exception) {
                MakeTestFailure(exception);
            }
     ];
}

void MakeTestFailure(NSException *exception)
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"Test Failure\n%@", exception.name]
                                    message:exception.reason
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alertView show];
}

@end
