//
//  ABWriteMessageController.m
//  API_DZ
//
//  Created by Alexandr Bondar on 03.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABWriteMessageController.h"

@interface ABWriteMessageController () <UITextViewDelegate>

@end

@implementation ABWriteMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.containerView.layer setCornerRadius:4.f];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.post.firstName, self.post.lastName];

    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapToDismiss:)];
    [self.view addGestureRecognizer:tapToDismiss];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)handleTapToDismiss:(UITapGestureRecognizer *)tap {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    } else {
        CGRect alertFrame = [self.view convertRect:self.containerView.frame toView:nil];
        CGPoint tapLocation = [self.view convertPoint:[tap locationInView:self.view] toView:nil];
        if (!CGRectContainsPoint(alertFrame, tapLocation)) {
            [self.view endEditing:YES];
            self.post = nil;
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}



#pragma mark - Notification

- (void) keyboardWasShown:(NSNotification*) notification {
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.bottomContainerViewConstraint.constant < keyboardRect.size.height) {
        
        [UIView animateWithDuration:0.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.bottomContainerViewConstraint.constant = keyboardRect.size.height;
                             
                             [self.view layoutIfNeeded];
                             
                         } completion:nil];
    }
}

- (void) keyboardWillBeHidden:(NSNotification*) notification {
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.bottomContainerViewConstraint.constant = 226;
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:nil];
    
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

#pragma mark - API


-(void)dismissWithSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRefreshPosts" object:nil];
    [self.sendButton setUserInteractionEnabled:YES];
    [self dismissViewControllerAnimated:YES completion:^{    }];
}


-(void) sendMessage:(NSString*)message toUser:(NSString*)userID {
    
    [[ABServerManager sharedManager] sendMessage:message
                                          toUser:userID
                                       onSuccess:^(NSDictionary *result) {
                                           
                                           NSLog(@"RESULT - messages.send - %@", result);
                                           [self dismissWithSuccess];
                                           
                                       } onFailure:^(NSError *error) {
                                           
                                           NSLog(@"ERROR -messages.send- %@", [error localizedDescription]);
                                           
                                       }];
    
}

- (IBAction)sendButton:(UIButton *)sender {
    
    if (self.textView.text.length == 0) {
        return;
    }
    
    [self sendMessage:self.textView.text toUser:self.post.fromID];

}


@end


