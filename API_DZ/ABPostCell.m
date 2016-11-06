//
//  ABPostCell.m
//  API_DZ
//
//  Created by Alexandr Bondar on 26.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABPostCell.h"

@implementation ABPostCell

- (void)awakeFromNib {
    // Initialization code
    
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
    self.userImageView.clipsToBounds = YES;
    
//    self.cellButton.layer.cornerRadius = self.cellButton.frame.size.width/2;
//    self.cellButton.clipsToBounds = YES;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForCellWithText:(NSString*)text {
    
    CGFloat offset = 10.f;
    
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
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake([UIApplication sharedApplication].keyWindow.frame.size.width - offset*2, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    
//    return CGRectGetHeight(rect);
    return CGRectGetHeight(rect) + 171;

}

@end
