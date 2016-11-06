//
//  ABAccessToken.h
//  API_DZ
//
//  Created by Alexandr Bondar on 25.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABAccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSDate* expirationDate;

@end
