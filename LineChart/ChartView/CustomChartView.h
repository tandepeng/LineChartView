//
//  CustomChartView.h
//  FinancialEW
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019 Runo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CustomChartViewDelegate<NSObject>

@optional
- (void)crosshairsMoveingWithIndex:(NSUInteger)index;

- (void)crosshairsEndMove;

@end


@interface CustomChartView : UIView

@property(nonatomic,weak)id<CustomChartViewDelegate>cDelegate;

//是否为双Y轴
@property(nonatomic,assign)BOOL isDoubleY;

//y轴数据（左侧数据）
@property(nonatomic,strong)NSArray<NSArray *> *leftYAxisDataArray;

//y轴渐变色(左侧)
@property(nonatomic,strong)NSArray<NSArray *> *leftGradientColorsArray;

//y轴数据（右侧数据）
@property(nonatomic,strong)NSArray<NSArray *> *rightYAxisDataArray;

//y轴渐变色(右侧)
@property(nonatomic,strong)NSArray<NSArray *> *rightGradientColorsArray;

//x轴数据
@property(nonatomic,strong)NSArray *xAxisDataArray;

//x轴网格线个数(默认值：5)
@property(nonatomic,assign)NSUInteger xGridLinesCount;

//x轴网格线颜色(默认值:kCustom0xColor(0x02084A, 0.04))
@property(nonatomic,strong)UIColor *xGridLinesColor;

//x轴数据显示个数
@property(nonatomic,assign)NSUInteger xTickAmount;

//y轴网格线个数(默认值:4)
@property(nonatomic,assign)NSUInteger yGridLinesCount;

//y轴网格线颜色(默认值：kCustom0xColor(0x02084A, 0.04))
@property(nonatomic,strong)UIColor *yGridLinesColor;

//y轴数据显示个数（默认值：4）
@property(nonatomic,assign)NSUInteger yTickAmount;

//x轴准星线
@property(nonatomic,strong)UIView *xAxisCrosshairView;

//默认图表距离边界距离
@property(nonatomic,assign)CGFloat marginLeft,marginTop,marginRight,marginBottom;

//更新重绘图表(赋值数据之后调用)
- (void)updateTheChart;

/*
 *通过数据驱动X轴准星线移动
 *index 数据所在x轴的索引
 */
- (void)driveCrosshairLineMovement:(double)index;

@end

@interface ChartDataManager : NSObject

//获取数据中的最大值
+ (NSString *)maximumValueInTheData:(NSArray *)dataArray;

//获取数据中的最小值
+ (NSString *)minimumValueInTheData:(NSArray *)dataArray;

//计算最大值的宽度
+ (CGFloat)maximumValueWidth:(NSString *)maximum;

//计算Y轴显示的数据
+ (NSArray *)yAxisDataArrayWithMaxValue:(NSString *)maxValue withMinValue:(NSString *)minValue withYTickAmount:(NSUInteger)yTickAmount;

//将时间字符串转给时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)timeString;

//从两个时间字符串选X段时间
+ (NSMutableArray *)selectPeriodFromxAxisDataArray:(NSArray *)xAxisDataArray  withXTickAmount:(NSInteger)xTickAmount withTimeStringFormatter:(NSString *)formatter;

@end

NS_ASSUME_NONNULL_END
