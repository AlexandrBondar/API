//
//  ABServerManager.m
//  API_DZ
//
//  Created by Alexandr Bondar on 25.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABAuthorizeController.h"
#import "ABServerManager.h"

#import "ABAccessToken.h"
#import "ABComment.h"
#import "ABPost.h"
#import "ABUser.h"
#import "ABMessage.h"

@interface ABServerManager()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;
@property (strong, nonatomic) ABAccessToken* accessToken;
@property (strong, nonatomic) dispatch_queue_t srvManagerQueue;


@end

@implementation ABServerManager

static NSString* groupID = @"58860049";

+ (ABServerManager*) sharedManager {
    
    static ABServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ABServerManager alloc] init];
        
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL* baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (void) authorizeUser:(void(^)(ABUser* user))completion {
    
    ABAuthorizeController* vc = [[ABAuthorizeController alloc] initWithCompletionBlock:^(ABAccessToken *token) {

        self.accessToken = token;
        
        if (token) {
            
            [self getUser:self.accessToken.userID
             
                onSuccess:^(ABUser *user) {
                    if (completion) {
                        
                        self.currentUser = user;
                        completion(user);
                    }
                }
             
                onFailure:^(NSError *error) {
                    NSLog(@"ERROR - %@", [error localizedDescription]);
                }];
            
        } else if (completion) {
            
            completion(nil);
        }
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:nav animated:YES completion:nil];
    
}

- (void) getPostsFromGroup:(NSString*)groupID
                WithOffset:(NSInteger)offset
                     count:(NSInteger)count
                 onSuccess:(void(^)(NSArray* posts))success
                 onFailure:(void(^)(NSError* error))failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:groupID,                      @"owner_id",
                                                                      @(count),                     @"count",
                                                                      @(offset),                    @"offset",
                                                                      @"all",                       @"filter",
                                                                      @"YES",                       @"extended",
                                                                      self.accessToken.token,       @"access_token",  nil];
    
    [self.sessionManager GET:@"wall.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"JSON -wall.get- %@", responseObject);

                         NSDictionary*  mainDict = [responseObject objectForKey:@"response"];
                         
                         NSArray*       arrayWithProfilesDict = [mainDict objectForKey:@"profiles"];
                         
                         NSArray*       arrayWithPostDicts = [mainDict objectForKey:@"wall"];
                         
                         if ([arrayWithPostDicts count] > 1) {
                             
                             arrayWithPostDicts = [arrayWithPostDicts subarrayWithRange:NSMakeRange(1, (int)[arrayWithPostDicts count] - 1)];
                         } else {
                             
                             arrayWithPostDicts = nil;
                         }
                         
                         NSMutableArray* postsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in arrayWithPostDicts) {
                             ABPost* post = [[ABPost alloc] initWithPostItems:dict andUserProfile:arrayWithProfilesDict];
                             if (post.firstName) {
                                 [postsArray addObject:post];
                             }
                             
                         }
                         
                         success(postsArray);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"ERROR - %@", [error localizedDescription]);
                     }];
    
}

- (void) getUser:(NSString*)userID onSuccess:(void(^)(ABUser* user))success onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userID,         @"user_ids",
                                                                      @"photo_100",   @"fields",
                                                                      @"nom",         @"name_case",
                                                                      @"5.59",        @"version", nil];
    
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                         
                         NSLog(@"JSON - %@", responseObject);
                         
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         
                         if ([dictsArray count] > 0) {
                             
                             ABUser* user = [[ABUser alloc] initWithServerResponse:[dictsArray firstObject]];
                             
                             if (success) {
                                 
                                 success(user);
                                 
                             }
                             
                         } else if (failure) {
                             NSLog(@"FAILURE");
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"ERROR - %@", [error localizedDescription]);
                         
                     }];
}

- (void) getCommentsForPost:(NSString*)postID
                withGroupID:(NSString*)groupID
                  onSuccess:(void(^)(NSMutableArray* comments))success
                  onFailure:(void(^)(NSError* error))failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:groupID,                      @"owner_id",
                                                                      postID,                       @"post_id",
                                                                      @"1",                         @"need_likes",
                                                                      @"1",                         @"extended",
                                                                      self.accessToken.token,       @"access_token",
                                                                      @"5.59",                      @"v",               nil];
    
    
    [self.sessionManager GET:@"wall.getComments"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"JSON - wall.getComments - %@", responseObject);

                         

                         NSDictionary* mainDict = [responseObject objectForKey:@"response"];
                         
                         NSArray*       arrayWithProfilesDict = [mainDict objectForKey:@"profiles"];
                         
                         NSArray*       arrayWithCommentsDicts = [mainDict objectForKey:@"items"];
                         
//                         if ([arrayWithCommentsDicts count] > 1) {
//                             
//                             arrayWithCommentsDicts = [arrayWithCommentsDicts subarrayWithRange:NSMakeRange(1, (int)[arrayWithCommentsDicts count] - 1)];
//                         } else {
//                             
//                             arrayWithCommentsDicts = nil;
//                         }
                         
                         NSMutableArray* commentsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in arrayWithCommentsDicts) {
                             ABComment* comment = [[ABComment alloc] initWithCommentItems:dict andUserProfile:arrayWithProfilesDict];
                             [commentsArray addObject:comment];
                         }
                         
                         if (success) {
                             
                             success(commentsArray);
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"ERROR -wall.getComments- %@", [error localizedDescription]);

                     }];
    
}

- (void) postCommentForPost:(NSString*)postID
                    onGroup:(NSString*)groupID
                   withText:(NSString*)text
                  onSuccess:(void(^)(NSDictionary* result))success
                  onFailure:(void(^)(NSError* error))failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:groupID,                      @"owner_id",
                                                                      postID,                       @"post_id",
                                                                      text,                         @"message",
                                                                      self.accessToken.token,       @"access_token", nil];
    [self.sessionManager POST:@"wall.createComment"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"JSON - wall.createComment - %@", responseObject);

                          success(responseObject);
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          NSLog(@"ERROR -wall.createComment- %@", [error localizedDescription]);

                      }];
}


- (void) addLikeForComment:(NSString*)commentID
               withOwnerID:(NSString*)ownerID
        andTypeLikedObject:(NSString*)typeLikedObject
                 onSuccess:(void(^)(NSDictionary* result))success
                 onFailure:(void(^)(NSError* error))failure   {
    
    if (![ownerID hasPrefix:@"-"]) {
        ownerID = [@"-" stringByAppendingString:ownerID];
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:typeLikedObject,          @"type",
                                                                      ownerID,                  @"owner_id",
                                                                      commentID,                @"item_id",
                                                                      self.accessToken.token,   @"access_token", nil];
    
    
    [self.sessionManager POST:@"likes.add"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                          NSLog(@"JSON - likes.add - %@", responseObject);
                          success(responseObject);
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"ERROR -likes.add- %@", [error localizedDescription]);
                     }];
    
}

- (void) dislikeForComment:(NSString*)commentID
               withOwnerID:(NSString*)ownerID
        andTypeLikedObject:(NSString*)typeLikedObject
                 onSuccess:(void(^)(NSDictionary* result))success
                 onFailure:(void(^)(NSError* error))failure   {
    
    if (![ownerID hasPrefix:@"-"]) {
        ownerID = [@"-" stringByAppendingString:ownerID];
    }
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:typeLikedObject,          @"type",
                                                                      ownerID,                  @"owner_id",
                                                                      commentID,                @"item_id",
                                                                      self.accessToken.token,   @"access_token", nil];
    
    
    [self.sessionManager POST:@"likes.delete"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          NSLog(@"JSON - likes.add - %@", responseObject);
                          success(responseObject);
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          NSLog(@"ERROR -likes.add- %@", [error localizedDescription]);
                      }];
    
}

- (void) getHistoryMessagesWithUser:(NSString*)userID
                          onSuccess:(void(^)(NSArray* allMessages))success
                          onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userID,                   @"user_id",
                                                                      userID,                   @"peer_id",
                                                                      self.accessToken.token,   @"access_token",
                                                                      @"0",                     @"rev",
                                                                        
                                                                      @"5.60",                  @"v",            nil];

    [self.sessionManager GET:@"messages.getHistory"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
                         NSLog(@"JSON - messages.getHistory - %@", responseObject);
                         
                         NSArray* allItemsWithMessages = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         
                         NSMutableArray* messagesArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in allItemsWithMessages) {
                             
                             ABMessage* message = [[ABMessage alloc] initWithMessageDict:dict];
                             
                             [messagesArray addObject:message];
                         }
                         
                         success(messagesArray);
                    
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"ERROR -messages.getHistory- %@", [error localizedDescription]);

                     }];
    
}

- (void) sendMessage:(NSString*)message
                    toUser:(NSString*)userID
                  onSuccess:(void(^)(NSDictionary* result))success
                  onFailure:(void(^)(NSError* error))failure {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userID,                      @"user_id",
                                                                      message,                     @"message",
                                                                      @"5.60",                     @"v",
                                                                      self.accessToken.token,      @"access_token", nil];
    
    [self.sessionManager POST:@"messages.send"
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"JSON - messages.send - %@", responseObject);
                          
                          success(responseObject);
                          
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          NSLog(@"ERROR -messages.send- %@", [error localizedDescription]);
                          
                      }];
}



@end
