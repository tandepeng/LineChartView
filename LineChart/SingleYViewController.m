//
//  SingleYViewController.m
//  LineChart
//
//  Created by mac on 2020/3/12.
//  Copyright © 2020 com.runo. All rights reserved.
//

#import "SingleYViewController.h"
#import "CustomChartView.h"

@interface SingleYViewController ()<CustomChartViewDelegate>

//图表
@property(nonatomic,strong)CustomChartView *chartView;
//x轴数据数组
@property(nonatomic,strong)NSArray<NSNumber *> *xAxis;
//Y轴数据数组
@property(nonatomic,strong)NSArray<NSNumber *> *yAxisFirstLine,*yAxisSecondLine,*yAxisThirdLine;

//Y轴折线渐变色数组
@property(nonatomic,strong)NSArray<NSArray *> *gradientColorsArray;

@property(nonatomic,assign)BOOL isSwitch;

@end

@implementation SingleYViewController

- (NSArray *)gradientColorsArray{
    if (!_gradientColorsArray) {
        _gradientColorsArray = @[@[(__bridge id)kCustom0xColor(0xFFE100, 1).CGColor,(__bridge id)kCustom0xColor(0xFFCF00, 1).CGColor,(__bridge id)kCustom0xColor(0xFBAB1B, 1).CGColor,(__bridge id)kCustom0xColor(0xF88B34, 1).CGColor],@[(__bridge id)kCustom0xColor(0xFC2FB1, 1).CGColor,(__bridge id)kCustom0xColor(0xD715F3, 1).CGColor,(__bridge id)kCustom0xColor(0xAA3CF0, 1).CGColor,(__bridge id)kCustom0xColor(0xC38BFF, 1).CGColor],@[(__bridge id)kCustom0xColor(0x90FEA2, 1).CGColor,(__bridge id)kCustom0xColor(0x21BCFF, 1).CGColor,(__bridge id)kCustom0xColor(0x406EE2, 1).CGColor,(__bridge id)kCustom0xColor(0x1D24C2, 1).CGColor]];
    }
    return _gradientColorsArray;
}

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
    
    [self createViews];
    
    [self configChartData];
}

- (void)config{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"单Y轴图表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更新数据" style:0 target:self action:@selector(rightAction)];
    
}

- (void)createViews{
    
    [self.view addSubview:self.chartView];
    
    //配置表格相关参数
    //x轴网格线个数
    self.chartView.xGridLinesCount = 4;
    //x轴网格线颜色
    self.chartView.xGridLinesColor = kCustom0xColor(0x02084A, 0.2);
    //y轴网格线个数
    self.chartView.yGridLinesCount = 4;
    //y轴网格线颜色
    self.chartView.yGridLinesColor = kCustom0xColor(0x02084A, 0.2);
    //Y轴数据显示的个数
    self.chartView.yTickAmount = 4;
    
    //网格图表距离边界偏移
    self.chartView.marginLeft = 10;
    self.chartView.marginTop = 10;
    self.chartView.marginRight = 10;
    self.chartView.marginBottom = 14;
    
    //以上配置都有默认值，可以不必设置
    
}

- (void)configChartData{
 
    //可以添加多条y轴
    self.yAxisFirstLine = @[@2,@4,@1,@0,@3,@6,@2];
    self.yAxisSecondLine = @[@0,@2,@4,@5,@3,@2,@6];
    self.yAxisThirdLine = @[@1,@2,@1,@3,@3,@4,@1];
    
    self.chartView.leftYAxisDataArray = @[self.yAxisFirstLine,self.yAxisSecondLine,self.yAxisThirdLine];
    //y轴的每条折线的渐变色数组。与每条折线需要一一对应
    self.chartView.leftGradientColorsArray = self.gradientColorsArray;
    
    //设置X轴的值
    self.xAxis = @[@"03-06",@"03-07",@"03-08",@"03-09",@"03-10",@"03-11",@"03-12"];
    self.chartView.xAxisDataArray = self.xAxis;
    
    //数据配置完成之后,绘制图表
    [self.chartView updateTheChart];
    
}

//更新图表数据
- (void)rightAction{
    
    if (self.isSwitch) {
        self.isSwitch = NO;
        [self configChartData];
    }else{
        self.isSwitch = YES;
        [self updateData];
    }
}

- (void)updateData{
 
    //可以添加多条y轴
    self.yAxisFirstLine = @[@3,@0,@1,@0,@3,@6,@2];
    self.yAxisSecondLine = @[@1,@2,@3,@2,@3,@5,@6];
    self.yAxisThirdLine = @[@1,@2,@3,@3,@1,@5,@3];
    
    self.chartView.leftYAxisDataArray = @[self.yAxisFirstLine,self.yAxisSecondLine,self.yAxisThirdLine];
    //y轴的每条折线的渐变色数组。与每条折线需要一一对应
    self.chartView.leftGradientColorsArray = self.gradientColorsArray;
    
    //设置X轴的值
    self.xAxis = @[@"03-06",@"03-07",@"03-08",@"03-09",@"03-10",@"03-11",@"03-12"];
    self.chartView.xAxisDataArray = self.xAxis;
    
    //数据配置完成之后,绘制图表
    [self.chartView updateTheChart];
    
}

#pragma mark-CustomChartDelegate
- (void)crosshairsMoveingWithIndex:(NSUInteger)index{
    
    NSLog(@"准星线位移:%lu",index);
}

- (void)crosshairsEndMove{
    
    NSLog(@"准星线移动结束");
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
