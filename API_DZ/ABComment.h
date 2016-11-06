//
//  ABComment.h
//  API_DZ
//
//  Created by Alexandr Bondar on 01.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABComment : NSObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSURL* imageURL;
@property (assign, nonatomic) NSNumber* fromID;
@property (strong, nonatomic) NSString * firstName;
@property (strong, nonatomic) NSString * lastName;
@property (assign, nonatomic) NSNumber* publicationID;
@property (assign, nonatomic) NSNumber* commentID;
@property (assign, nonatomic) NSNumber* numberOfLikes;
@property (strong, nonatomic) NSString* commentDate;
@property (assign, nonatomic) BOOL isLikedByMyself;


- (ABComment*)initWithCommentItems:(NSDictionary*)commentDict andUserProfile:(NSArray*)profile;

@end
