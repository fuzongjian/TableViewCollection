//
//  CustomCollectionViewCell.h
//  TableViewCollection
//
//  Created by 付宗建 on 16/8/1.
//  Copyright © 2016年 youran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *bigLable;
@property (weak, nonatomic) IBOutlet UILabel *smallLable;

@end
