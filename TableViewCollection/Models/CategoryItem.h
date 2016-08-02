//
//  CategoryItem.h
//  TableViewCollection
//
//  Created by 付宗建 on 16/8/2.
//  Copyright © 2016年 youran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryItem : NSObject
@property(nonatomic, copy)NSString * name;
@property(nonatomic, copy)NSString * categroyName;
-(instancetype)initWithName:(NSString *)name categroyName:(NSString *)categroyName;
@end
