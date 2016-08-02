//
//  CategoryItem.m
//  TableViewCollection
//
//  Created by 付宗建 on 16/8/2.
//  Copyright © 2016年 youran. All rights reserved.
//

#import "CategoryItem.h"

@implementation CategoryItem
-(instancetype)initWithName:(NSString *)name categroyName:(NSString *)categroyName{
    if (self = [super init]) {
        self.name = name;
        self.categroyName = categroyName;
    }
    return self;
}
@end
