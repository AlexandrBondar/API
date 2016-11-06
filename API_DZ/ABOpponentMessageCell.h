//
//  ABOpponentMessageCell.h
//  API_DZ
//
//  Created by Alexandr Bondar on 03.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABOpponentMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateMessageLabel;


+ (CGFloat) heightForCellWithText:(NSString*)text;


@end
