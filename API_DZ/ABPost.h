//
//  ABPost.h
//  API_DZ
//
//  Created by Alexandr Bondar on 25.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABPost : NSObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSURL* imageURL;
@property (assign, nonatomic) NSString* fromID;
@property (strong, nonatomic) NSString * firstName;
@property (strong, nonatomic) NSString * lastName;
@property (assign, nonatomic) NSString* postID;
@property (assign, nonatomic) NSNumber* numberOfLikes;
@property (assign, nonatomic) NSNumber* numberOfComments;
@property (strong, nonatomic) NSString* postDate;
@property (assign, nonatomic) BOOL isLikedByMyself;


- (ABPost*)initWithPostItems:(NSDictionary*)postDict andUserProfile:(NSArray*)profile;


@end
