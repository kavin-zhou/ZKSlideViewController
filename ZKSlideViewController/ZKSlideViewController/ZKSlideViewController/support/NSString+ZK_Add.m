//
//  NSString+ZK_Add.m
//  ZKSlideViewController
//
//  Created by Zhou Kang on 2017/11/20.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "NSString+ZK_Add.h"

@implementation NSString (ZK_Add)

- (CGFloat)zk_stringWidthWithFont:(UIFont *)font height:(float)height {
    if (self == nil || self.length == 0) {
        return 0;
    }
    
    NSString *copyString = [NSString stringWithFormat:@"%@", self];
    
    CGSize size = CGSizeZero;
    CGSize constrainedSize = CGSizeMake(CGFLOAT_MAX, height);
    
    if ([copyString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping; //e.g.
        
        size = [copyString boundingRectWithSize: constrainedSize
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraph }
                                        context: nil].size;
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        size = [copyString sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
#pragma GCC diagnostic pop
    }
    return ceilf(size.width+0.5);
}

@end
