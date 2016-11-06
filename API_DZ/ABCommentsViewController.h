//
//  ABCommentsViewController.h
//  API_DZ
//
//  Created by Alexandr Bondar on 31.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>



@class ABPost;

@interface ABCommentsViewController : UIViewController

@property (strong, nonatomic) ABPost* post;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldBottomToBottomViewConstraint;

@property (weak, nonatomic) IBOutlet UITextField *textfieldComment;

- (IBAction)actionBack:(UIBarButtonItem *)sender;

@end
