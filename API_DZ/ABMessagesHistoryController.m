//
//  ABMessagesHistoryController.m
//  API_DZ
//
//  Created by Alexandr Bondar on 03.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABMessagesHistoryController.h"
#import "ABMessage.h"
#import "ABMyMessageCell.h"
#import "ABOpponentMessageCell.h"

#import "ABWriteMessageController.h"

#import "UIImageView+AFNetworking.h"

@interface ABMessagesHistoryController ()

@end

@implementation ABMessagesHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl* refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshMessages) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    self.messagesArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessages) name:@"shouldRefreshPosts" object:nil];
    
    [self getHistoryMessegeWithUserFromPost:self.post];
    
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}


#pragma mark - API

- (void) getHistoryMessegeWithUserFromPost:(ABPost*)post {
    
    [[ABServerManager sharedManager] getHistoryMessagesWithUser:post.fromID
                                                      onSuccess:^(NSArray* allMessages) {
                                                          
                                                          [self.messagesArray addObjectsFromArray:allMessages];
                                                          
                                                          [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ %@ - %ld сообщений", self.post.firstName,
                                                                                         self.post.lastName, (unsigned long)[self.messagesArray count]]];

                                                          [self.tableView reloadData];
                                                          
                                                      } onFailure:^(NSError *error) {
                                                          
                                                          NSLog(@"ERROR -messages.getHistory- %@", [error localizedDescription]);
                                                          
                                                      }];
    
    
}

-(void)refreshMessages {
    
    if (!self.refreshControl.isRefreshing) {
        [self.refreshControl beginRefreshing];
    }
    [[ABServerManager sharedManager] getHistoryMessagesWithUser:self.post.fromID
     
        onSuccess:^(NSArray* allMessages) {
                                                          
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ %@ - %ld сообщений", self.post.firstName,
                                                                                           self.post.lastName,
                                                                                           (unsigned long)[self.messagesArray count]]];
        [self.messagesArray removeAllObjects];
        [self.messagesArray addObjectsFromArray:allMessages];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
        
    } onFailure:^(NSError *error) {
        
        NSLog(@"ERROR -messages.getHistory- %@", [error localizedDescription]);
        
        [self.refreshControl endRefreshing];
        
    }];
    
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.messagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* myCellIdentifier =       @"ABMyMessageCell";
    static NSString* opponentCellIdentifier = @"ABOpponentMessageCell";

    ABMessage* message = self.messagesArray[indexPath.row];
    
        if (message.isMyMessage) {
            
            ABMyMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
            
            cell.dateMessageLabel.text = message.messageDate;

            cell.textMessageLabel.text = message.text;

            NSLog(@"MY MESSAGE - %@", cell.textMessageLabel.text);
            
            NSURLRequest* request = [NSURLRequest requestWithURL:self.currentUser.imageURL];
            
            __weak ABMyMessageCell* weakCell = cell;
            
            [cell.avatarImageView setImageWithURLRequest:request
                                      placeholderImage:nil
                                               success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                   
                                                   weakCell.avatarImageView.image = image;
                                                   
                                               }
                                               failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                   
                                               }];
            return cell;
        } else {
            
            ABOpponentMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:opponentCellIdentifier];
            
            cell.dateMessageLabel.text = message.messageDate;
            cell.textMessageLabel.text = message.text;
            cell.nameLabel.text        = [NSString stringWithFormat:@"%@ %@", self.post.firstName, self.post.lastName];
            
            NSURLRequest* request = [NSURLRequest requestWithURL:self.post.imageURL];
            
            __weak ABOpponentMessageCell* weakCell = cell;
            
            [cell.avatarImageView setImageWithURLRequest:request
                                        placeholderImage:nil
                                                 success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                     
                                                     weakCell.avatarImageView.image = image;
                                                     
                                                 }
                                                 failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                     
                                                 }];
            return cell;
        }
    return nil;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ABMessage* message = self.messagesArray[indexPath.row];
    
    return [ABMyMessageCell heightForCellWithText:message.text];
}

#pragma mark - Action

- (IBAction)addBarButton:(UIBarButtonItem *)sender {
    
    ABWriteMessageController* wmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABWriteMessageController"];
   
    wmvc.post = self.post;
    
    [self presentViewController:wmvc animated:YES completion:nil];
}

- (IBAction)backBarButton:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
