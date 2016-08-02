//
//  SearchConditonItemView.m
//  TableViewCollection
//
//  Created by 付宗建 on 16/8/2.
//  Copyright © 2016年 youran. All rights reserved.
//

#import "SearchConditonItemView.h"

@implementation SearchConditonItemView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView * bgView = [[UIImageView alloc]initWithFrame:self.bounds];
        bgView.image = [UIImage imageNamed:@"search_meterial_bg"];
        [self addSubview:bgView];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width * 0.7, height)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(width * 0.7, 0, width * 0.3, height);
        [_deleteButton setImage:[UIImage imageNamed:@"search_header_rmbtn"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"search_header_rmbtn_hl"] forState:UIControlStateHighlighted];
        [self addSubview:_deleteButton];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
