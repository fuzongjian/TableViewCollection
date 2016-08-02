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
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

static NSString * COLLECTION_CELL = @"Collection_Cell";
static NSString * TABLEVIEW_CELL = @"TableView_Cell";
const static long COLLECTION_TAG = 12303;

const static long HEADERSECTIONBUTTON_TAG = 1240712;
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UILabel * titleLable;// 标题
// 数据源
@property (nonatomic,strong) NSDictionary * dataDictionary;
@property (nonatomic,strong) NSArray * dataArray;
// UITableView 与 UICollectionView
@property (nonatomic,strong) UITableView * tableView;
// 点击 SectionHeaderButton的index,默认为0
@property (nonatomic,assign) long SectionHeaderButtonIndex;
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
    if (!cell.categoryCollectionView.dataSource || !cell.categoryCollectionView.delegate) {
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
        if (dictionary[@"iconName"] && ![dictionary[@"iconName"] isEqualToString:@""]) {
            cell.bigLable.hidden = YES;
            cell.detailImageView.hidden = NO;
            cell.smallLable.hidden = NO;
            cell.detailImageView.image = [UIImage imageNamed:dictionary[@"iconName"]];
            cell.smallLable.text = dictionary[@"name"];
        }else{
            cell.bigLable.hidden = NO;
            cell.detailImageView.hidden = YES;
            cell.smallLable.hidden = YES;
            cell.bigLable.text = dictionary[@"name"];
            cell.bigLable.adjustsFontSizeToFitWidth = YES;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell * cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bgImageView.image = [UIImage imageNamed:@"search_item_bg_hl"];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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
