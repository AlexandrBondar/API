//
//  ABPostCell.h
//  API_DZ
//
//  Created by Alexandr Bondar on 26.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *textOfPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCommentsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *likesImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;


+ (CGFloat) heightForCellWithText:(NSString*)text;

@end
