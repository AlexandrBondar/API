//
//  ABCommentsCell.m
//  API_DZ
//
//  Created by Alexandr Bondar on 31.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABCommentsCell.h"

@implementation ABCommentsCell

- (void)awakeFromNib {
    // Initialization code
    
    self.userAvatarImageView.layer.cornerRadius = self.userAvatarImageView.frame.size.height/2;
//    self.userAvatarImageView.layer.cornerRadius = 5;

    self.userAvatarImageView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForCellWithText:(NSString*)text {
    
    CGFloat offset = 10.f;
    
    UIFont* font = [UIFont systemFontOfSize:15.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    //    [paragraph setAlignment:NSTextAlignmentCenter];
    [paragraph setAlignment:NSTextAlignmentLeft];
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:font,      NSFontAttributeName,
                                shadow,    NSShadowAttributeName,
                                paragraph, NSParagraphStyleAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width - offset*2, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    
    //    return CGRectGetHeight(rect);
    return CGRectGetHeight(rect) + 105;
    
}


@end
