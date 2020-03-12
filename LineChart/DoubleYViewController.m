//
//  DoubleYViewController.m
//  LineChart
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 com.runo. All rights reserved.
//

#import "DoubleYViewController.h"
#import "CustomChartView.h"

@interface DoubleYViewController ()<CustomChartViewDelegate>

//图表
@property(nonatomic,strong)CustomChartView *chartView;
//x轴数据数组
@property(nonatomic,strong)NSArray<NSNumber *> *xAxis;

@end

@implementation DoubleYViewController

- (CustomChartView *)chartView{
    if (!_chartView) {
        _chartView = [[CustomChartView alloc]initWithFrame:CGRectMake(12, 150, kScreenWidth-24, 210)];
        _chartView.isDoubleY = NO;
        _chartView.cDelegate = self;
    }
    return _chartView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
    
    [self createSubviews];
}

- (void)config{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"双Y轴图表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更新数据" style:0 target:self action:@selector(rightAction)];
    
}

//更新数据
- (void)rightAction{
    
    
}

- (void)createSubviews{
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
