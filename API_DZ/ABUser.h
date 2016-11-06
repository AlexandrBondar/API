//
//  ABUser.h
//  API_DZ
//
//  Created by Alexandr Bondar on 28.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABServerObject.h"


@interface ABUser : ABServerObject

@property (strong, nonatomic) NSString * firstName;
@property (strong, nonatomic) NSString * lastName;
@property (strong, nonatomic) NSURL* imageURL;

- (id) initWithServerResponse:(NSDictionary*) response;


@end
