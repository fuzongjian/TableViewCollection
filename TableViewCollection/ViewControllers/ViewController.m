//
//  ViewController.m
//  TableViewCollection
//
//  Created by 付宗建 on 16/8/1.
//  Copyright © 2016年 youran. All rights reserved.
//

#import "ViewController.h"
#import "CustomSectionHeaderView.h"
#import "CustomTableViewCell.h"
#import "CustomCollectionViewCell.h"
#import "CategoryItem.h"
#import "SearchConditonItemView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

static NSString * COLLECTION_CELL = @"Collection_Cell";
static NSString * TABLEVIEW_CELL = @"TableView_Cell";
const static long COLLECTION_TAG = 99210;
const static long HEADERSECTIONBUTTON_TAG = 12346;
const static long DELETEBUTTON_TAG = 56230;
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *SearchConditonView;
@property (nonatomic,strong) UILabel * titleLable;// 标题
// 数据源
@property (nonatomic,strong) NSDictionary * dataDictionary;
@property (nonatomic,strong) NSArray * dataArray;
// UITableView 与 UICollectionView
@property (nonatomic,strong) UITableView * tableView;
// 点击 SectionHeaderButton的index,默认为0
@property (nonatomic,assign) long SectionHeaderButtonIndex;
@property (nonatomic,strong) NSMutableDictionary * oldKeyDic;//存储选中元素
@property (nonatomic,strong) NSMutableDictionary * collectionDic;//存储collection
@property (nonnull,strong) NSMutableArray * searchConditionArray;//查询条件
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViewControllerUI];
    [self loadViewControllerData];
    
}
#pragma mark --- 初始化UI
- (void)configViewControllerUI{
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];//导航栏颜色
    self.navigationItem.titleView = self.titleLable;// 标题
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];//背景颜色
    [self.view addSubview:self.tableView];
    
    self.SectionHeaderButtonIndex = 0;
    self.oldKeyDic = [NSMutableDictionary dictionary];
    self.collectionDic = [NSMutableDictionary dictionary];
    self.searchConditionArray = [NSMutableArray array];
}
#pragma mark --- 按钮点击事件处理
- (void)SectionHeaderButtonClicked:(UIButton *)sender{
    if (sender.tag >= HEADERSECTIONBUTTON_TAG) {
        self.SectionHeaderButtonIndex = sender.tag - HEADERSECTIONBUTTON_TAG;
        [self.tableView reloadData];
    }
}
#pragma mark --- UITableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.SectionHeaderButtonIndex == indexPath.section) {
        return 108;
    }else{
        return 0;
    }
//    return 108;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CustomSectionHeaderView * headerView = [CustomSectionHeaderView defaultFromNib];
    NSString * title = self.dataDictionary[self.dataArray[section]][@"title"];
    [headerView.SectionHeaderButton setTitle:title forState:UIControlStateNormal];
    headerView.SectionHeaderButton.tag = HEADERSECTIONBUTTON_TAG + section;
    [headerView.SectionHeaderButton addTarget:self action:@selector(SectionHeaderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TABLEVIEW_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //讲每一个collectionView保存到字典里以供其他的位置调用
    [self.collectionDic setObject:cell.categoryCollectionView forKey:self.dataArray[indexPath.section]];
   
    if (!cell.categoryCollectionView.dataSource || !cell.categoryCollectionView.delegate) {
         NSLog(@"---%d",indexPath.section);
        cell.categoryCollectionView.tag = COLLECTION_TAG + indexPath.section;
        cell.categoryCollectionView.dataSource = self;
        cell.categoryCollectionView.delegate = self;
        cell.categoryCollectionView.showsHorizontalScrollIndicator = NO;
        cell.categoryCollectionView.backgroundColor = [UIColor clearColor];
        [cell.categoryCollectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:COLLECTION_CELL];
    }
    return cell;
}
#pragma mark --- UICollectionView 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag >= COLLECTION_TAG) {
        long index = collectionView.tag - COLLECTION_TAG;
        NSArray * array = self.dataDictionary[self.dataArray[index]][@"data"];
        return array.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_CELL forIndexPath:indexPath];
    if (collectionView.tag >= COLLECTION_TAG) {
        long index = collectionView.tag - COLLECTION_TAG;
        NSArray * array = self.dataDictionary[self.dataArray[index]][@"data"];
        NSDictionary * dictionary = [array objectAtIndex:indexPath.row];
        // 得到当前collectionView选中的元素序号
        NSNumber * oldKey = self.oldKeyDic[self.dataArray[index]];
//        NSLog(@"%ld---%@",index,dictionary[@"iconName"]);
        if (dictionary[@"iconName"] && ![dictionary[@"iconName"] isEqualToString:@""]) {
            cell.bigLable.hidden = YES;
            cell.detailImageView.hidden = NO;
            cell.smallLable.hidden = NO;
            
            // 选中状态的设置
            if (oldKey && [oldKey isEqualToNumber:@(indexPath.row)]) {
                cell.detailImageView.image = [UIImage imageNamed:dictionary[@"hlIconName"]];
                cell.smallLable.text = dictionary[@"name"];
                cell.smallLable.textColor = [UIColor whiteColor];
                cell.bgImageView.image = [UIImage imageNamed:@"search_item_bg_hl"];
            }else{
                cell.detailImageView.image = [UIImage imageNamed:dictionary[@"iconName"]];
                cell.smallLable.text = dictionary[@"name"];
                cell.smallLable.textColor = [UIColor lightGrayColor];
                cell.bgImageView.image = [UIImage imageNamed:@"search_bg"];
            }
            
        }else{
            cell.bigLable.hidden = NO;
            cell.detailImageView.hidden = YES;
            cell.smallLable.hidden = YES;
            
            if (oldKey && [oldKey isEqualToNumber:@(indexPath.row)]) {
                cell.bigLable.textColor = [UIColor whiteColor];
                cell.bgImageView.image = [UIImage imageNamed:@"search_item_bg_hl"];
            }else{
                cell.bigLable.textColor = [UIColor lightGrayColor];
                cell.bgImageView.image = [UIImage imageNamed:@"search_bg"];
            }
            cell.bigLable.text = dictionary[@"name"];
            //文字大小自适应frame大小
            cell.bigLable.adjustsFontSizeToFitWidth = YES;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag >= COLLECTION_TAG) {
        long index = collectionView.tag - COLLECTION_TAG;
        //设置当前元素为选中状态
        self.oldKeyDic[self.dataArray[index]] = @(indexPath.row);
        //得到选中的元素的分类名称和元素的名称
        NSArray * array = self.dataDictionary[self.dataArray[index]][@"data"];
        NSDictionary * dictionary = array[indexPath.row];
        NSString * name = [dictionary objectForKey:@"name"];
        NSString * categoryName = self.dataArray[index];
        
        //判断当前元素是否是已经设置的条件的元素分类，如果是，则更新元素名称
        BOOL isContain = NO;
        for (CategoryItem * item in self.searchConditionArray) {
            if ([item.categroyName isEqualToString:categoryName]) {
                item.name = name;
                isContain = YES;
                break;
            }
        }
        // 如果不包含该条件的分类，则添加该分类以及分类名称
        if (!isContain) {
            [self.searchConditionArray addObject:[[CategoryItem alloc] initWithName:name categroyName:categoryName]];
        }
        //显示所有的条件Button
        [self showSearchConditionButton];
    }
    // 刷新当前的collectionView
    [collectionView reloadData];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)showSearchConditionButton{
    //首先移除所有条件的Button
    for (UIView * view in self.SearchConditonView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat itemWidth = (SCREEN_WIDTH - 60) / 3;
    for (int i = 0; i < self.searchConditionArray.count; i ++) {
        CategoryItem * item = self.searchConditionArray[i];
        SearchConditonItemView * itemView ;
        if (i >= 3) {
            itemView =[[SearchConditonItemView alloc] initWithFrame:CGRectMake(10 + 10 * (i - 3) + itemWidth * (i - 3), 55, itemWidth, 35)];
        }else{
            itemView = [[SearchConditonItemView alloc] initWithFrame:CGRectMake(10 + 10 * i + itemWidth * i, 10, itemWidth, 35)];
        }
        itemView.nameLabel.text = item.name;
        [self.SearchConditonView addSubview:itemView];
        itemView.deleteButton.tag = DELETEBUTTON_TAG + i;
        [itemView.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)deleteButtonClicked:(UIButton *)sender{
    if (sender.tag >= DELETEBUTTON_TAG) {
        //得到被点击的按钮的index
        long index = sender.tag - DELETEBUTTON_TAG;
        //根据index得到对应的数组的对象
        CategoryItem * item = [self.searchConditionArray objectAtIndex:index];
        //根据要删除的对象的categoryName删除对应的选中状态
        [self.oldKeyDic removeObjectForKey:item.categroyName];
        //删除选中状态后需要刷新的collectionView
        [self.collectionDic[item.categroyName] reloadData];
        // 删除对应的对象
        [self.searchConditionArray removeObjectAtIndex:index];
        // 移除对应的条件button
        [self removeSearchConditionButtonWithIndex:index];
    }
}
- (void)removeSearchConditionButtonWithIndex:(NSInteger)index{
    //首先移除点击删除按钮的条件Button
    SearchConditonItemView * itemView = self.SearchConditonView.subviews[index];
    [itemView removeFromSuperview];
    //得到剩下的所有的子视图
    NSArray * subviews = self.SearchConditonView.subviews;
    CGFloat itemWidth = (SCREEN_WIDTH - 60) / 3;
    //动画处理
    [UIView animateWithDuration:0.25 animations:^{
        for (int i = 0; i < subviews.count; i ++) {
            //修改剩下的子视图的frame
            SearchConditonItemView * itemView = subviews[i];
            itemView.deleteButton.tag = DELETEBUTTON_TAG + i;
            if (i >= 3) {
                itemView.frame = CGRectMake(10 + 10 * (i - 3) + itemWidth * (i - 3), 55, itemWidth, 35);
            }else{
                itemView.frame = CGRectMake(10 + 10 * i + itemWidth * i, 10, itemWidth, 35);
            }
        }
    }];
}
#pragma mark --- 数据加载
- (void)loadViewControllerData{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"fuzongjian" ofType:@"plist"];
    self.dataDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    self.dataArray = [self.dataDictionary objectForKey:@"order_titles"];
}
#pragma mark --- 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        
        CGFloat height = CGRectGetMaxY(self.SearchConditonView.frame) + 10;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:TABLEVIEW_CELL];
    }
    return _tableView;
}
- (UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _titleLable.text = @"UITableView嵌套UICollectionView";
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.font = [UIFont boldSystemFontOfSize:18];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}
@end
