//
//  ABPost.m
//  API_DZ
//
//  Created by Alexandr Bondar on 25.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABPost.h"

@implementation ABPost

- (ABPost*)initWithPostItems:(NSDictionary*)postDict andUserProfile:(NSArray*)profile
{
    self = [super init];
    if (self) {
        
        NSNumber* userID = [postDict objectForKey:@"from_id"];
        
        for (NSDictionary* dictProfile in profile) {
            
            NSLog(@"User ID in post - %@", userID);
            NSLog(@"User ID in profile - %@", [dictProfile objectForKey:@"uid"]);
            
            if ([[dictProfile objectForKey:@"uid"] isEqual:userID]) {
                
                
                
                self.firstName = [dictProfile objectForKey:@"first_name"];
                self.lastName = [dictProfile objectForKey:@"last_name"];
                
                NSString* urlString = [dictProfile objectForKey:@"photo"];
                if (urlString) {
                    self.imageURL = [NSURL URLWithString:urlString];
                }
                NSLog(@"Image URL - %@", urlString);
            }
        }
        
        self.text = [postDict objectForKey:@"text"];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];

        
        NSDictionary* commentDict = [postDict objectForKey:@"comments"];
        self.numberOfComments = [commentDict objectForKey:@"count"];
        
        NSDictionary* likeDict = [postDict objectForKey:@"likes"];
        self.numberOfLikes = [likeDict objectForKey:@"count"];
        self.isLikedByMyself = [[likeDict objectForKey:@"user_likes"] boolValue];
        
        NSLog(@"MY like - %zd", self.isLikedByMyself);
        
        self.postID = [postDict objectForKey:@"id"];
        
        self.fromID = [postDict objectForKey:@"from_id"];
        
        NSNumber* interval = [postDict objectForKey:@"date"];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMMM | HH:mm"];

        self.postDate = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:[interval integerValue]]];
        
        NSLog(@"*****************START POST CONTENT*******************");
        NSLog(@"First Name - %@", self.firstName);
        NSLog(@"Last Name - %@",  self.lastName);
        NSLog(@"TEXT - %@", self.text);
        NSLog(@"Post ID - %@", self.postID);
        NSLog(@"From ID - %@", self.fromID);
        NSLog(@"Comments number - %@",  self.numberOfComments);
        NSLog(@"Like number - %@",      self.numberOfLikes);
        NSLog(@"*****************STOP POST CONTENT*******************");

        
    }
    return self;
}

@end
