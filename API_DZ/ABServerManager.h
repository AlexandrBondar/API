//
//  ABServerManager.h
//  API_DZ
//
//  Created by Alexandr Bondar on 25.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@class ABUser;

@interface ABServerManager : NSObject

@property (strong, nonatomic) ABUser* currentUser;


+ (ABServerManager*) sharedManager;

- (void) getPostsFromGroup:(NSString*)groupID
                WithOffset:(NSInteger)offset
                     count:(NSInteger)count
                onSuccess:(void(^)(NSArray* posts))success
                onFailure:(void(^)(NSError* error))failure;

- (void) authorizeUser:(void(^)(ABUser* user))completion;

- (void) getCommentsForPost:(NSString*)postID
                withGroupID:(NSString*)groupID
                  onSuccess:(void(^)(NSMutableArray* comments))success
                  onFailure:(void(^)(NSError* error))failure ;

- (void) postCommentForPost:(NSString*)postID
                    onGroup:(NSString*)groupID
                   withText:(NSString*)text
                  onSuccess:(void(^)(NSDictionary* result))success
                  onFailure:(void(^)(NSError* error))failure;


- (void) addLikeForComment:(NSString*)commentID
               withOwnerID:(NSString*)ownerID
        andTypeLikedObject:(NSString*)typeLikedObject
                 onSuccess:(void(^)(NSDictionary* result))success
                 onFailure:(void(^)(NSError* error))failure;

- (void) dislikeForComment:(NSString*)commentID
               withOwnerID:(NSString*)ownerID
        andTypeLikedObject:(NSString*)typeLikedObject
                 onSuccess:(void(^)(NSDictionary* result))success
                 onFailure:(void(^)(NSError* error))failure;

- (void) getHistoryMessagesWithUser:(NSString*)userID
                          onSuccess:(void(^)(NSArray* allMessages))success
                          onFailure:(void(^)(NSError* error))failure;

- (void) sendMessage:(NSString*)message
              toUser:(NSString*)userID
           onSuccess:(void(^)(NSDictionary* result))success
           onFailure:(void(^)(NSError* error))failure;

@end
