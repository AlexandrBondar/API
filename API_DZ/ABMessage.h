//
//  ABMessage.h
//  API_DZ
//
//  Created by Alexandr Bondar on 02.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABMessage : NSObject

@property (strong, nonatomic) NSString* messageDate;
@property (assign, nonatomic) NSNumber* authorMessageID;
@property (assign, nonatomic) BOOL isMyMessage;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSNumber* interlocutorID;

- (ABMessage*)initWithMessageDict:(NSDictionary*)messageDict;


@end
