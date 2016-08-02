//
//  CustomSectionHeaderView.h
//  TableViewCollection
//
//  Created by 付宗建 on 16/8/1.
//  Copyright © 2016年 youran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *SectionHeaderButton;
+ (instancetype)defaultFromNib;
@end
