//
//  ABCommentsViewController.m
//  API_DZ
//
//  Created by Alexandr Bondar on 31.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABCommentsViewController.h"
#include "ABServerManager.h"
#import "ABPost.h"
#import "ABComment.h"

#import "ABPostCell.h"
#import "ABCommentsCell.h"

#import "UIImageView+AFNetworking.h"

@interface ABCommentsViewController () <UITextFieldDelegate, UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* comments;

@end

@implementation ABCommentsViewController

static NSString* groupID = @"58860049";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.comments = [NSMutableArray array];
    
    [self getCommentsForPost:[NSString stringWithFormat:@"%@", self.post.postID]];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

#pragma mark - API

- (void) getCommentsForPost:(NSString*)postID {
    
    [[ABServerManager sharedManager] getCommentsForPost:postID
                                            withGroupID:groupID
                                              onSuccess:^(NSMutableArray *comments) {
                                                  
                                                  self.comments = comments;
                                                  
                                                  [self.tableView reloadData];
                                                  
//                                                  NSMutableArray* newPaths = [NSMutableArray array];
//                                                  
//                                                  for (int i = (int)([self.comments count]); i<[self.comments count]; i++) {
//                                                      
//                                                      [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//                                                  }
//                                                  
//                                                  [self.tableView beginUpdates];
//                                                  [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
//                                                  [self.tableView endUpdates];
                                                  
                                              } onFailure:^(NSError *error) {
                                                  
                                                  NSLog(@"ERROR - get comments in controller - %@", [error localizedDescription]);

                                                  
                                              }];
    
}

- (void) postCommentForPost:(NSString*)postID withText:(NSString*)text {
    
    __weak ABCommentsViewController* weakCVC = self;
    
    [[ABServerManager sharedManager] postCommentForPost:postID
                                                onGroup:groupID
                                               withText:text
                                              onSuccess:^(NSDictionary *result) {
                                                  
                                                  NSLog(@"POST!!!");
                                                  NSLog(@"JSON - wall.createComment - %@", result);
                                                  
                                                  //[self.tableView reloadData];
                                                  
                                                  [weakCVC getCommentsForPost:[NSString stringWithFormat:@"%@", self.post.postID]];
                                                  
                                              } onFailure:^(NSError *error) {
                                                  
                                                  
                                              }];
}



#pragma mark - Notifications actions

- (void) keyboardWillShow:(NSNotification*) notification {
    
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.textfieldBottomToBottomViewConstraint.constant = keyboardRect.size.height;
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:nil];
    
}

- (void) keyboardWillHide:(NSNotification*) notification {
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.textfieldBottomToBottomViewConstraint.constant = 10;
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:nil];
    
    //[self getCommentsForPost:[NSString stringWithFormat:@"%@", self.post.postID]];

    
}




#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.comments count] + 2;
    
//    return [self.post.numberOfComments integerValue] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* postCellIdentifier = @"ABPostCell";
    static NSString* commentCellIdentifier = @"ABCommentsCell";
    static NSString* isolationCellIdentifier = @"IsolationCell";
    
    if (indexPath.row == 0) {
        
        ABPostCell* cell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier];
        
        
        NSURLRequest* request = [NSURLRequest requestWithURL:self.post.imageURL];
        
        
        __weak ABPostCell* weakCell = cell;
        
        [cell.userImageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               
                                               weakCell.userImageView.image = image;
                                               
                                               
                                           }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                               
                                               
                                               
                                           }];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.post.firstName, self.post.lastName];
        
        cell.textOfPostLabel.numberOfLines = 0;
        cell.textOfPostLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.likesImageView.image = [UIImage imageNamed:@"like_32.png"];
        cell.commentImageView.image = [UIImage imageNamed:@"comment_32.png"];
        
        cell.textOfPostLabel.text = self.post.text;
        cell.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%@", self.post.numberOfComments];
        cell.numberOfLikesLabel.text = [NSString stringWithFormat:@"%@", self.post.numberOfLikes];
        cell.dateOfPostLabel.text = self.post.postDate;
        
        return cell;
        
    } else if (indexPath.row == 1) {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:isolationCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:isolationCellIdentifier];
        }
       cell.backgroundColor = [UIColor grayColor];
        return cell;
        
    } else if (indexPath.row > 1) {
        
        ABCommentsCell* cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        
        ABComment* comment = self.comments[indexPath.row - 2];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:comment.imageURL];
        
        
        __weak ABCommentsCell* weakCell = cell;
        
        [cell.userAvatarImageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               
                                               weakCell.userAvatarImageView.image = image;
                                               
                                           }
                                           failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                               
                                           }];
        
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", comment.firstName, comment.lastName];
        
        cell.commentTextLabel.numberOfLines = 0;
        cell.commentTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.likesImageView.image = [UIImage imageNamed:@"like_32.png"];
        
        cell.commentTextLabel.text = comment.text;
        cell.numberOfLikes.text = [NSString stringWithFormat:@"%@", comment.numberOfLikes];
        cell.dateOfPostLabel.text = comment.commentDate;
        
        NSLog(@"*****************START CONTENT FROM COMMENT CELL*******************");
        NSLog(@"First Name - %@", comment.firstName);
        NSLog(@"Last Name - %@",  comment.lastName);
        NSLog(@"TEXT - %@", comment.text);
        NSLog(@"Post ID - %@", comment.commentID);
        NSLog(@"From ID - %@", comment.fromID);
        NSLog(@"Like number - %@",      comment.numberOfLikes);
        NSLog(@"*****************STOP CONTENT FROM COMMENT CELL*******************");

        
        return cell;
    }

    return nil;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    
    if (indexPath.row == 0) {
        height = [ABPostCell heightForCellWithText:self.post.text];
        
    } else if (indexPath.row == 1) {
        height = 5;
        
    } else if (indexPath.row > 1) {
        ABComment* comment = self.comments[indexPath.row - 2];  
        height = [ABCommentsCell heightForCellWithText:comment.text];
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Action

- (IBAction)actionBack:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.textfieldComment.text length] > 0) {
        
        [self postCommentForPost:[NSString stringWithFormat:@"%@", self.post.postID]  withText:textField.text];
        
        NSLog(@"Send comment - %@!", textField.text);

       textField.text = @"";
        
        [textField resignFirstResponder];

        
        
        
    } else {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}


@end
