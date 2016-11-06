//
//  ViewController.m
//  API_DZ
//
//  Created by Alexandr Bondar on 25.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ViewController.h"
#import "ABServerManager.h"
#import "ABPost.h"
#import "ABUser.h"

#import <UIScrollView+SVInfiniteScrolling.h>
#import <UIScrollView+SVPullToRefresh.h>

#import "ABCommentsViewController.h"
#import "ABMessagesHistoryController.h"
#import "ABPostCell.h"
#import "ABTapGestureRecognizer.h"

#import "UIImageView+AFNetworking.h"


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* postsArray;
@property (assign, nonatomic) BOOL firstTimeAppear;
@property (strong, nonatomic) NSArray* allMessages;

@property (assign, nonatomic) BOOL loadingData;

@property (strong, nonatomic) NSOperation *currentOperation;
@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation ViewController

static NSInteger postsInRequest = 10;
static NSString* iosDevCourseGroupID = @"58860049";

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.postsArray = [NSMutableArray array];
    self.allMessages = [NSArray array];
    self.firstTimeAppear = YES;
    self.loadingData = YES;
    
    [self infiniteScrolling];

    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"iOSDevCourse";
    
    UIRefreshControl* refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshWall) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    

    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        
        self.firstTimeAppear = NO;
        
        [[ABServerManager sharedManager] authorizeUser:^(ABUser *user) {
            
            NSLog(@"BINGO!!!");
            NSLog(@"AUTHORIZED!!!");
            NSLog(@"%@ %@", user.firstName, user.lastName);
            
            [self getPostsFromGroup];
        }];
    }
    
    
}

#pragma mark - API


- (void)infiniteScrolling {
    
    __weak ViewController* weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        [weakSelf refreshWall];                                             // !!!!!!!!!!!!!!!!! поменять
        
        // once refresh, allow the infinite scroll again
        weakSelf.tableView.showsInfiniteScrolling = YES;
    }];
    
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        [weakSelf getPostsBackgroundFromGroup];
        
    }];
    
}

- (void)getPostsBackgroundFromGroup {
    
    self.queue = [[NSOperationQueue alloc] init];
    
    __weak NSOperation *weakCurrentOperation = self.currentOperation;
    
    __weak ViewController* weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if (![weakCurrentOperation isCancelled]) {
            
            [weakSelf getPostsFromGroup];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.currentOperation = nil;
        });
        
    }];
    
    [self.queue addOperation:self.currentOperation];
}

- (void) getPostsFromGroup {
    
    [[ABServerManager sharedManager] getPostsFromGroup:@"58860049"
                                            WithOffset:[self.postsArray count]
                                                 count:postsInRequest
                                             onSuccess:^(NSArray * posts) {
                                                 
                                                 if ([posts count] > 0) {
                                                     
                                                     [self.postsArray addObjectsFromArray:posts];
                                                     
                                                     //                                                 [self.tableView reloadData];
                                                     
                                                     NSMutableArray* newPaths = [NSMutableArray array];
                                                     
                                                     for (int i = (int)([self.postsArray count]-[posts count]); i<[self.postsArray count]; i++) {
                                                         
                                                         [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                     }
                                                     
                                                     [self.tableView beginUpdates];
                                                     [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                                                     [self.tableView endUpdates];
                                                 
                                                }
                                                 
                                                 self.loadingData = NO;
                                                 [self.tableView.infiniteScrollingView stopAnimating];
                                                
                                             }
                                             onFailure:^(NSError *error) {
                                                 
                                                 self.tableView.showsInfiniteScrolling = NO;
                                                 [self.tableView.infiniteScrollingView stopAnimating];
                                                 
                                                 NSLog(@"error = %@", [error localizedDescription]);
                                                 
                                                 UIAlertController* alertVC =
                                                 [UIAlertController alertControllerWithTitle:@"Network error occured"
                                                                                     message:[error localizedDescription]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                                 [alertVC addAction:[UIAlertAction actionWithTitle:@"Close"
                                                                                             style:UIAlertActionStyleCancel
                                                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                                                               [alertVC dismissViewControllerAnimated:YES completion:nil];
                                                                                               
                                                                                           }]];
                                             }];
    
}



- (void) refreshWall {
    
    if (self.loadingData == NO) {
        self.loadingData = YES;
        
        [[ABServerManager sharedManager]
         getPostsFromGroup:iosDevCourseGroupID
         WithOffset:0
         count:MAX(postsInRequest, [self.postsArray count])
         onSuccess:^(NSArray *posts) {
             
             if ([posts count] > 0) {
                 [self.postsArray removeAllObjects];
                 
                 [self.postsArray addObjectsFromArray:posts];
                 
                 [self.tableView reloadData];
                 
             }
             
             self.loadingData = NO;
             
             [self.tableView.pullToRefreshView stopAnimating];
             
         }
         onFailure:^(NSError *error) {
             
             NSLog(@"error = %@", [error localizedDescription]);
             
             
             [self.tableView.pullToRefreshView stopAnimating];
             
         }];
        
    }
    
}

- (void) likePost:(ABPost*)post{
    
    [[ABServerManager sharedManager] addLikeForComment:post.postID
                                           withOwnerID:iosDevCourseGroupID
                                    andTypeLikedObject:@"post"
                                             onSuccess:^(NSDictionary *result) {
                                                 
                                                 NSLog(@"LIKE!  \n%@", result);
                                                 NSNumber* numberOfLikes = [[result objectForKey:@"response"] objectForKey:@"likes"];
                                                 
                                                 post.isLikedByMyself = YES;
                                                 post.numberOfLikes = numberOfLikes;
                                                 [self.tableView reloadData];
                                                 
                                                 
                                             } onFailure:^(NSError *error) {
                                                 
                                                 NSLog(@"ERROR LIKE - %@", [error localizedDescription]);
                                                 
                                             }];

    
}

- (void) dislikePost:(ABPost*)post {
    
    [[ABServerManager sharedManager] dislikeForComment:post.postID
                                           withOwnerID:iosDevCourseGroupID
                                    andTypeLikedObject:@"post" onSuccess:^(NSDictionary *result) {
                                        
                                        NSLog(@"LIKE!  \n%@", result);
                                        NSNumber* numberOfLikes = [[result objectForKey:@"response"] objectForKey:@"likes"];
                                        
                                        post.isLikedByMyself = NO;
                                        post.numberOfLikes = numberOfLikes;
                                        [self.tableView reloadData];
                                        
                                    } onFailure:^(NSError *error) {
                                        
                                        NSLog(@"ERROR DISLIKE - %@", [error localizedDescription]);

                                    }];
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.postsArray count];
    
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* postCellIdentifier =       @"ABPostCell";
    
        ABPostCell* cell = [tableView dequeueReusableCellWithIdentifier:postCellIdentifier];

        ABPost* post = self.postsArray[indexPath.row];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:post.imageURL];
        
        
        __weak ABPostCell* weakCell = cell;
        
        [cell.userImageView setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           weakCell.userImageView.image = image;
                                           
                                       }
                                       failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                           
                                       }];
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", post.firstName, post.lastName];
        
        cell.textOfPostLabel.numberOfLines = 0;
        cell.textOfPostLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textOfPostLabel.text = post.text;
        cell.numberOfCommentsLabel.text = [NSString stringWithFormat:@"%@", post.numberOfComments];

        cell.numberOfLikesLabel.text = [NSString stringWithFormat:@"%@", post.numberOfLikes];
        
        cell.dateOfPostLabel.text = [NSString stringWithFormat:@"%@", post.postDate];
        
        if (post.isLikedByMyself) {
            cell.likesImageView.image = [UIImage imageNamed:@"like_b_32.png"];
            cell.numberOfLikesLabel.textColor = [UIColor blueColor];
        } else {
            cell.likesImageView.image = [UIImage imageNamed:@"like_32.png"];
            cell.numberOfLikesLabel.textColor = [UIColor blackColor];

        }
    
        cell.commentImageView.image = [UIImage imageNamed:@"comment_32.png"];
        
        ABTapGestureRecognizer* avatarTapGesture = [[ABTapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleTapOnAvatar:)];
        avatarTapGesture.tag = indexPath.row;
        [cell.userImageView setUserInteractionEnabled:YES];
        [cell.userImageView addGestureRecognizer:avatarTapGesture];
        
        ABTapGestureRecognizer* commentTapGesture = [[ABTapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleTapOnComments:)];
        commentTapGesture.tag = indexPath.row;
        [cell.commentImageView setUserInteractionEnabled:YES];
        [cell.commentImageView addGestureRecognizer:commentTapGesture];
        
        ABTapGestureRecognizer* likeTapGesture = [[ABTapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleTapOnLikes:)];
        likeTapGesture.tag = indexPath.row;
        [cell.likesImageView setUserInteractionEnabled:YES];
        [cell.likesImageView addGestureRecognizer:likeTapGesture];
        
        return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.postsArray count]) {
        
        [self getPostsFromGroup];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ABPost* post = self.postsArray[indexPath.row];
    
    return [ABPostCell heightForCellWithText:post.text];
}


#pragma mark - Handle

- (void) handleTapOnAvatar:(ABTapGestureRecognizer*)sender {

    NSLog(@"Tag avatar-TAP - %zd", sender.tag);

    ABPost* post = self.postsArray[sender.tag];
    
    ABMessagesHistoryController* mhtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ABMessagesHistoryController"];

    mhtvc.currentUser = [ABServerManager sharedManager].currentUser;
    
    mhtvc.post = post;
    
    [self.navigationController pushViewController:mhtvc animated:YES];
    
}

- (void) handleTapOnComments:(ABTapGestureRecognizer*)sender {
    
    ABCommentsViewController* commentsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ABCommentsViewController"];
    
    ABPost* post = self.postsArray[sender.tag];
    
    commentsVC.post = post;

   [self.navigationController pushViewController:commentsVC animated:YES];
    
    NSLog(@"Tag avatar-TAP - %zd", sender.tag);

    
}

- (void) handleTapOnLikes:(ABTapGestureRecognizer*)sender {
    
    NSLog(@"Tag likes-TAP - %zd", sender.tag);

    ABPost* post = self.postsArray[sender.tag];
    
    if (post.isLikedByMyself) {
        
        [self dislikePost:post];

    } else {
        
        [self likePost:post];
    }    
}

@end
