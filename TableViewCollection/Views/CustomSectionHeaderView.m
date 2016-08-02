//
//  CustomSectionHeaderView.m
//  TableViewCollection
//
//  Created by 付宗建 on 16/8/1.
//  Copyright © 2016年 youran. All rights reserved.
//

#import "CustomSectionHeaderView.h"

@implementation CustomSectionHeaderView
+ (instancetype)defaultFromNib{
    return [[[NSBundle mainBundle] loadNibNamed:@"CustomSectionHeaderView" owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
