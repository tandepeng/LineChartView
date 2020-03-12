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
        _chartView.isDoubleY = YES;
        _chartView.cDelegate = self;
        _chartView.xTickAmount = 5;//x轴显示个数
        //右侧Y轴折线颜色数组
        _chartView.rightGradientColorsArray = @[@[(__bridge id)kCustom0xColor(0x60ECB5, 1).CGColor,(__bridge id)kCustom0xColor(0x00A4F2, 1).CGColor,(__bridge id)kCustom0xColor(0x002AB6, 1).CGColor]];
        //左侧Y轴折线颜色数组
        _chartView.leftGradientColorsArray = @[@[(__bridge id)kCustom0xColor(0xFFDB38, 1).CGColor,(__bridge id)kCustom0xColor(0xFFC238, 1).CGColor,(__bridge id)kCustom0xColor(0xFF843D, 1).CGColor]];
    }
    return _chartView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
    
    [self createSubviews];
    
    [self configChartData];
}

- (void)config{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"双Y轴图表";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更新数据" style:0 target:self action:@selector(rightAction)];
    
}

//更新数据
- (void)rightAction{
    
    
}

- (void)createSubviews{
    
    [self.view addSubview:self.chartView];
}

- (void)configChartData{
 
    NSArray *xAxisDataArray = @[@"2020-03-12 00:03:29",@"2020-03-12 00:34:51",@"2020-03-12 01:06:14",@"2020-03-12 01:37:37",@"2020-03-12 02:08:59",@"2020-03-12 02:40:22",@"2020-03-12 03:11:44",@"2020-03-12 03:43:06",@"2020-03-12 04:14:28",@"2020-03-12 04:45:50",@"2020-03-12 05:17:13",@"2020-03-12 05:48:35",@"2020-03-12 06:19:57",@"2020-03-12 06:51:19"];
    NSArray *leftYAxisDataArray = @[@13250.6,@13250.8,@13253.7,@13254.5,@13258.2,@13259.1,@13261.5,@13262.4,@13262.9,@13263.6,@13263.9,@13265.8,@13267.9,@13269.2];
    NSArray *rightYAxisDataArray = @[@0,@12.9,@11,@33.3,@46.3,@57.4,@61.1,@42.5,@62.9,@9.1,@51.8,@21,@10,@30];
    
    self.chartView.xAxisDataArray = xAxisDataArray;
    //可以添加多条折线
    self.chartView.leftYAxisDataArray = @[leftYAxisDataArray];
    self.chartView.rightYAxisDataArray = @[rightYAxisDataArray];
    
    [self.chartView updateTheChart];
    
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
