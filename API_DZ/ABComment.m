//
//  ABComment.m
//  API_DZ
//
//  Created by Alexandr Bondar on 01.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABComment.h"

@implementation ABComment

- (ABComment*)initWithCommentItems:(NSDictionary*)commentDict andUserProfile:(NSArray*)profile {
    
    self = [super init];
    if (self) {
        
        NSNumber* userID = [commentDict objectForKey:@"from_id"];
        
        for (NSDictionary* dictProfile in profile) {
            
            NSLog(@"User ID in post - %@", userID);
            NSLog(@"User ID in profile - %@", [dictProfile objectForKey:@"uid"]);
            
            if ([[dictProfile objectForKey:@"id"] isEqual:userID]) {
                
                
                
                self.firstName = [dictProfile objectForKey:@"first_name"];
                self.lastName = [dictProfile objectForKey:@"last_name"];
                
                NSString* urlString = [dictProfile objectForKey:@"photo_50"];
                if (urlString) {
                    self.imageURL = [NSURL URLWithString:urlString];
                }
                NSLog(@"Image URL - %@", urlString);
            }
        }
        
        self.text = [commentDict objectForKey:@"text"];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        
//        NSDictionary* commentDict = [commentDict objectForKey:@"comments"];
//        self.numberOfComments = [commentDict objectForKey:@"count"];
        
        NSDictionary* likeDict = [commentDict objectForKey:@"likes"];
        self.numberOfLikes = [likeDict objectForKey:@"count"];
        self.isLikedByMyself = [likeDict objectForKey:@"user_likes"];
        
        
        self.commentID = [commentDict objectForKey:@"id"];
        
        self.fromID = [commentDict objectForKey:@"from_id"];
        
        NSNumber* interval = [commentDict objectForKey:@"date"];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMMM | HH:mm"];
        
        self.commentDate = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:[interval integerValue]]];
        
        NSLog(@"*****************START COMMENT CONTENT*******************");
        NSLog(@"First Name - %@", self.firstName);
        NSLog(@"Last Name - %@",  self.lastName);
        NSLog(@"TEXT - %@", self.text);
        NSLog(@"Post ID - %@", self.commentID);
        NSLog(@"From ID - %@", self.fromID);
        NSLog(@"Like number - %@",      self.numberOfLikes);
        NSLog(@"*****************STOP COMMENT CONTENT*******************");
        
        
    }
    return self;

}


@end
