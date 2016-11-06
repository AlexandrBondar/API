//
//  ABMyMessageCell.m
//  API_DZ
//
//  Created by Alexandr Bondar on 03.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABMyMessageCell.h"

@implementation ABMyMessageCell

- (void)awakeFromNib {

    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.height/2;
    self.avatarImageView.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForCellWithText:(NSString*)text {
    
    CGFloat offset = 210.f;
    
    UIFont* font = [UIFont systemFontOfSize:17.f];
    
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
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width - offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    
    //    return CGRectGetHeight(rect);
    return CGRectGetHeight(rect) + 64;
    
}


@end
