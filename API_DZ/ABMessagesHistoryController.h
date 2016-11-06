//
//  ABMessagesHistoryController.h
//  API_DZ
//
//  Created by Alexandr Bondar on 03.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABServerManager.h"
#import "ABUser.h"
#import "ABPost.h"

@interface ABMessagesHistoryController : UITableViewController

@property (strong, nonatomic) NSMutableArray* messagesArray;
@property (strong, nonatomic) ABUser* currentUser;
@property (strong, nonatomic) ABPost* post;

- (IBAction)addBarButton:(UIBarButtonItem *)sender;
- (IBAction)backBarButton:(UIBarButtonItem *)sender;

@end
