//
//  ViewController.m
//  LineChart
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 com.runo. All rights reserved.
//

#import "ViewController.h"
#import "SingleYViewController.h"
#import "DoubleYViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *myTableView;

@end

@implementation ViewController

- (UITableView *)myTableView{
    
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, kScreenWidth, kScreenHeight - 88) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
//        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.myTableView];
}

#pragma mark-UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"单Y轴图表";
    }else{
        cell.textLabel.text = @"双Y轴图表";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        SingleYViewController *singleY = [[SingleYViewController alloc]init];
        [self.navigationController pushViewController:singleY animated:YES];
    }else{
        DoubleYViewController *doubleY = [[DoubleYViewController alloc]init];
        [self.navigationController pushViewController:doubleY animated:YES];
    }
     
}


@end
