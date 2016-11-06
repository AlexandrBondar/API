//
//  ABWriteMessageController.h
//  API_DZ
//
//  Created by Alexandr Bondar on 03.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABServerManager.h"
#import "ABUser.h"
#import "ABPost.h"

@interface ABWriteMessageController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContainerViewConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) ABPost* post;

- (IBAction)sendButton:(UIButton *)sender;

@end
