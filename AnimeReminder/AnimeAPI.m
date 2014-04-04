//
//  AnimeAPI.m
//  AnimeReminder
//
//  Created by Madimo on 14-3-31.
//  Copyright (c) 2014年 Madimo. All rights reserved.
//

#import "AnimeAPI.h"
#import "SubscriptionItem.h"
#import "UpdateScheduleItem.h"
#import <AFNetworking.h>

#define UD_ANIMEAPI_TOKEN @"AnimeAPIToken"

#define ANIMEAPI_API_LOGIN         @"http://api.sellmoe.com/login"
#define ANIMEAPI_API_REGISTER      @"http://api.sellmoe.com/reg"
#define ANIMEAPI_API_CHANGEPSW     @"http://api.sellmoe.com/changepw"
#define ANIMEAPI_API_GETUSERINFO   @"http://api.sellmoe.com/get_user_info"
#define ANIMEAPI_API_GETUPDATELIST @"http://api.sellmoe.com/get_update_schedule"
#define ANIMEAPI_API_EMAILREMSET   @"http://api.sellmoe.com/email_reminder_set"
#define ANIMEAPI_API_ADDANIME      @"http://api.sellmoe.com/add_anime"
#define ANIMEAPI_API_DELANIME      @"http://api.sellmoe.com/del_anime"
#define ANIMEAPI_API_HIGHLIGHT     @"http://api.sellmoe.com/highlight"
#define ANIMEAPI_API_EPIEDIT       @"http://api.sellmoe.com/epiedit"


@interface AnimeAPI()
@property (nonatomic, strong) NSString *token;
@end

@implementation AnimeAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _token = (NSString *)[ud objectForKey:UD_ANIMEAPI_TOKEN];
    }
    return self;
}

#pragma mark - About account

- (void)setToken:(NSString *)token
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:token forKey:UD_ANIMEAPI_TOKEN];
    [ud synchronize];
    _token = token;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)())success
                  failure:(void (^)(NSException *exception))failure
{
    NSDictionary *parameters = @{ @"u" : username,
                                  @"p" : password };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:ANIMEAPI_API_LOGIN
       parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
              @try {
                  NSDictionary *dict = (NSDictionary *)responseObject;
                  debugLog(@"\n ----- login return ----- \n%@\n----- end of login return -----", dict);
                  [self checkError:dict];
                  self.token = dict[@"data"][@"key"];
              }
              @catch (NSException *exception) {
                  if (failure)
                      failure(exception);
              }
              
              if (success)
                  success();
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure)
                  failure(CreateNetworkErrorException(task, error));
          }
     ];
}

- (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
                     success:(void (^)())success
                     failure:(void (^)(NSException *exception))failure
{
    NSDictionary *parameters = @{ @"u" : username,
                                  @"p" : password };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:ANIMEAPI_API_REGISTER
       parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
              @try {
                  NSDictionary *dict = (NSDictionary *)responseObject;
                  debugLog(@"\n ----- register return ----- \n%@\n----- end of register return -----", dict);
                  [self checkError:dict];
                  self.token = dict[@"data"][@"key"];
              }
              @catch (NSException *exception) {
                  if (failure)
                      failure(exception);
              }
              
              if (success)
                  success();
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure)
                  failure(CreateNetworkErrorException(task, error));
          }
     ];
}

- (void)changePasswordWithOldPassword:(NSString *)oldPsw
                          newPassword:(NSString *)newPsw
                              success:(void (^)())success
                              failure:(void (^)(NSException *exception))failure
{
    NSDictionary *parameters = @{ @"key"   : self.token,
                                  @"oldpw" : oldPsw,
                                  @"newpw" : newPsw };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:ANIMEAPI_API_CHANGEPSW
       parameters:parameters
          success:^(NSURLSessionDataTask *task, id responseObject) {
              @try {
                  NSDictionary *dict = (NSDictionary *)responseObject;
                  debugLog(@"\n ----- changPassword return ----- \n%@\n----- end of changPassword return -----", dict);
                  [self checkError:dict];
                  
              }
              
              @catch (NSException *exception) {
                  if (failure)
                      failure(exception);
              }
              
              if (success)
                  success();
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure)
                  failure(CreateNetworkErrorException(task, error));
          }
     ];
}

- (void)logout
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:UD_ANIMEAPI_TOKEN];
    [ud synchronize];
}

- (BOOL)isLogined
{
    if (self.token)
        return YES;
    else
        return NO;
}

#pragma mark - Anime list

- (void)getSubscriptionListWithBlank:(void *)blank
                             success:(void (^)(NSArray *subscriptionItems))success
                             failure:(void (^)(NSException *exception))failure
{
    NSDictionary *parameters = @{ @"key" : self.token };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:ANIMEAPI_API_GETUSERINFO
      parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             NSMutableArray *subscriptionItems = [[NSMutableArray alloc] init];
             
             @try {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 debugLog(@"\n ----- getSubscriptionList return ----- \n%@\n----- end of getSubscriptionList return -----", dict);
                 [self checkError:dict];
                 
                 
                 for (NSDictionary *itemDict in dict[@"data"][@"subscription"]) {
                     SubscriptionItem *item = [[SubscriptionItem alloc] init];
                     item.aid     = [NSString stringWithFormat:@"%d", [itemDict[@"id"] intValue]];
                     item.name    = itemDict[@"name"];
                     item.isOver  = [itemDict[@"isover"] boolValue];
                     item.isRead  = [itemDict[@"isread"] boolValue];
                     item.episode = [itemDict[@"episode"] intValue];
                     item.watch   = [itemDict[@"watch"] intValue];
                     [subscriptionItems addObject:item];
                 }
                 
             }
             @catch (NSException *exception) {
                  if (failure)
                      failure(exception);
             }
            
             if (success)
                 success(subscriptionItems);
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure)
                 failure(CreateNetworkErrorException(task, error));
         }
     ];
}

- (void)getUpdateScheduleWithBlank:(void *)black
                           success:(void(^)(NSArray *updateScheduleItems))success
                           failure:(void(^)(NSException *exception))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:ANIMEAPI_API_GETUPDATELIST
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSMutableArray *updateScheduleItems = [[NSMutableArray alloc] init];
             @try {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 debugLog(@"\n ----- getUpdateSchedule return ----- \n%@\n----- end of getUpdateSchedule return -----", dict);
                 [self checkError:dict];
                 
                 for (NSDictionary *itemDict in dict[@"data"][@"update_list"]) {
                     UpdateScheduleItem *item = [[UpdateScheduleItem alloc] init];
                     item.name = itemDict[@"name"];
                     item.url  = itemDict[@"url"];
                     item.week = itemDict[@"week"];
                     item.time = itemDict[@"time"];
                     [updateScheduleItems addObject:item];
                 }

             }
             @catch (NSException *exception) {
                 if (failure)
                     failure(exception);
             }
             
             if (success)
                 success(updateScheduleItems);
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure)
                 failure(CreateNetworkErrorException(task, error));
         }
     ];
    
}

#pragma mark - Email reminder

- (void)setEmailReminderEnable:(BOOL)enable
                       success:(void (^)())success
                       failure:(void (^)(NSException *excepiton))failure
{
    NSNumber *enableNumber = [NSNumber numberWithInt:enable ? 1 : 0];
    NSDictionary *parameters = @{ @"key"    : self.token,
                                  @"enable" : enableNumber };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:ANIMEAPI_API_EMAILREMSET
      parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             @try {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 debugLog(@"\n ----- setEmailReminder return ----- \n%@\n----- end of setEmailReminder return -----", dict);
                 [self checkError:dict];

             }
             @catch (NSException *exception) {
                 if (failure)
                     failure(exception);
             }
             
             if (success)
                 success();
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure)
                 failure(CreateNetworkErrorException(task, error));
         }
     ];
}

- (void)getEmailReminderEnableWithBlank:(void *)blank
                                success:(void (^)(BOOL enable))success
                                failure:(void (^)(NSException *excepiton))failure
{
    NSDictionary *parameters = @{ @"key" : self.token };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:ANIMEAPI_API_GETUSERINFO
      parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             BOOL enable = NO;
             @try {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 debugLog(@"\n ----- getEmailReminder return ----- \n%@\n----- end of getEmailReminder return -----", dict);
                 [self checkError:dict];
                 enable = [dict[@"data"][@"email"] boolValue];
             }
             @catch (NSException *exception) {
                 if (failure)
                     failure(exception);
             }
             
             if (success)
                 success(enable);
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure)
                 failure(CreateNetworkErrorException(task, error));
         }
     ];
}

#pragma mark - Add & del anime

- (void)addAnimeByID:(NSString *)aid
             success:(void (^)())success
             failure:(void (^)(NSException *exception))failure
{
    NSDictionary *parameters = @{ @"key" : self.token,
                                  @"aid" : aid };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:ANIMEAPI_API_ADDANIME
      parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             @try {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 debugAPIOutput(@"addAnimeWithAnimeID", dict);
                 [self checkError:dict];
             }
             @catch (NSException *exception) {
                 if (failure)
                     failure(exception);
             }
             
             if (success)
                 success();
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure)
                 failure(CreateNetworkErrorException(task, error));
         }
     ];
}

- (void)deleteAnimeByID:(NSString *)aid
                success:(void (^)())success
                failure:(void (^)(NSException *exception))failure
{
    NSDictionary *parameters = @{ @"key" : self.token,
                                  @"aid" : aid };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:ANIMEAPI_API_DELANIME
      parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             @try {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 debugAPIOutput(@"deleteAnimeWithAnimeID", dict);
                 [self checkError:dict];
             }
             @catch (NSException *exception) {
                 if (failure)
                     failure(exception);
             }
             
             if (success)
                 success();
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure)
                 failure(CreateNetworkErrorException(task, error));
         }
     ];
}

#pragma mark - Anime edit

- (void)setIsRead:(BOOL)isRead
     forAnimaByID:(NSString *)aid
          success:(void (^)())success
          failure:(void (^)(NSException *exception))failure
{
    NSDictionary *parameters = @{ @"key"    : self.token,
                                  @"aid"    : aid,
                                  @"method" : isRead ? @"del" : @"add" };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:ANIMEAPI_API_HIGHLIGHT
      parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             @try {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 debugAPIOutput(@"setIsRead", dict);
                 [self checkError:dict];
             }
             @catch (NSException *exception) {
                 if (failure)
                     failure(exception);
             }
             
             if (success)
                 success();
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure)
                 failure(CreateNetworkErrorException(task, error));
         }
     ];
}

- (void)setReadEpi:(NSInteger)epi
      forAnimeByID:(NSString *)aid
           success:(void (^)())success
           failure:(void (^)(NSException *exception))failure
{
    NSDictionary *parameters = @{ @"key" : self.token,
                                  @"aid" : aid,
                                  @"epi" : [NSString stringWithFormat:@"%d", epi] };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:ANIMEAPI_API_EPIEDIT
      parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             @try {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 debugAPIOutput(@"setReadEpi", dict);
                 [self checkError:dict];
             }
             @catch (NSException *exception) {
                 if (failure)
                     failure(exception);
             }
             
             if (success)
                 success();
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             if (failure)
                 failure(CreateNetworkErrorException(task, error));
         }
     ];
}


#pragma mark - Private method & function

NSException *CreateNetworkErrorException(NSURLSessionDataTask *task, NSError *error)
{
    NSDictionary *userinfo = @{ @"task"  : task,
                                @"error" : error };
    NSException *exception = [NSException exceptionWithName:ERROR_NETWORK_ERROR
                                                     reason:@"网络错误，请重试"
                                                   userInfo:userinfo];
    return exception;
}

- (void)checkError:(NSDictionary *)dict
{
    
    if (![dict[@"status"] isEqual:@200]) {
        NSString *name;
        NSString *reason;

        switch ([dict[@"status"] intValue]) {
            case 400:
                name   = ERROR_INVALID_KEY;
                reason = @"您的帐号授权已过期，请重新登陆";
                break;
            case 401:
                name   = ERROR_INVALID_PSW;
                reason = @"密码错误";
                break;
            case 407:
                name   = ERROR_EXIST_EMAIL;
                reason = @"您填写的邮箱已经被注册，请直接登陆或换个邮箱重试";
                break;
            case 501:
                name   = ERROR_INVALID_ANIME;
                reason = @"抱歉，您添加的内容不存在于片库中";
                break;
            case 502:
                name   = ERROR_INVALID_EPI;
                reason = @"集数不符合规范";
                break;
            case 503:
                name   = ERROR_EXIST_ANIME;
                reason = @"此订阅已经在您的订阅列表中，请不要重复添加";
                break;
            default:
                name   = ERROR_UNKNOWN;
                reason = @"发生了错误，请重试";
                break;
        }
        
        NSException *exception = [NSException exceptionWithName:name
                                                         reason:reason
                                                       userInfo:nil];
        @throw exception;
    }
}

@end
