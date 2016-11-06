//
//  ABCommentsCell.h
//  API_DZ
//
//  Created by Alexandr Bondar on 31.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABCommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (weak, nonatomic) IBOutlet UIImageView *likesImageView;

+ (CGFloat) heightForCellWithText:(NSString*)text;

@end
