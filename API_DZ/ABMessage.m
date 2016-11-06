//
//  ABMessage.m
//  API_DZ
//
//  Created by Alexandr Bondar on 02.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABMessage.h"

@implementation ABMessage

- (ABMessage *)initWithMessageDict:(NSDictionary *)messageDict {
    
    self = [super init];
    if (self) {
        
        NSNumber* interval = [messageDict objectForKey:@"date"];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMMM | HH:mm"];
        
        self.messageDate = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:[interval integerValue]]];
        
        self.authorMessageID = [messageDict objectForKey:@"from_id"];
        
        self.isMyMessage = [[messageDict objectForKey:@"out"] boolValue];
        
        self.text = [messageDict objectForKey:@"body"];
        
        self.interlocutorID = [messageDict objectForKey:@"user_id"];
                
        NSLog(@"*****************START MESSAGE CONTENT*******************");
        NSLog(@"DATE - %@", self.messageDate);
        NSLog(@"TEXT - %@", self.text);
        NSLog(@"Is My Message - %zd", self.isMyMessage);
        NSLog(@"Author ID - %@", self.authorMessageID);
        NSLog(@"Interlocutor ID - %@",      self.interlocutorID);
        NSLog(@"*****************STOP MESSAGE CONTENT*******************");
        
    }
    return self;

    
}

@end
