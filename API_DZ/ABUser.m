//
//  ABUser.m
//  API_DZ
//
//  Created by Alexandr Bondar on 28.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABUser.h"

@implementation ABUser


- (id) initWithServerResponse:(NSDictionary*) response

{
    self = [super initWithServerResponse:response];
    if (self) {
        
        self.firstName = [response objectForKey:@"first_name"];
        self.lastName = [response objectForKey:@"last_name"];
        
        NSString* urlString = [response objectForKey:@"photo_100"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
    }
    return self;
}
@end
