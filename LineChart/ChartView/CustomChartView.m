//
//  CustomChartView.m
//  FinancialEW
//
//  Created by mac on 2019/12/25.
//  Copyright © 2019 Runo. All rights reserved.
//

#import "CustomChartView.h"

@interface CustomChartView()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSMutableArray *xAxisDataFrameArray;

@property(nonatomic,strong)NSArray *defaultLineColor;

//当前准星线所在索引，避免多次回调
@property(nonatomic,assign)NSInteger currentCrosshairIndex;

@property(nonatomic,strong)NSMutableArray *layerArray;

@end

@implementation CustomChartView

- (NSMutableArray *)layerArray{
    if (!_layerArray) {
        _layerArray = [NSMutableArray array];
    }
    return _layerArray;
}

//默认折线颜色
- (NSArray *)defaultLineColor{
    if (!_defaultLineColor) {
        _defaultLineColor = @[(__bridge id)kCustom0xColor(0x02084A, 1.f).CGColor];
    }
    return _defaultLineColor;
}

//x轴准星线
- (UIView *)xAxisCrosshairView{
    if (!_xAxisCrosshairView) {
        _xAxisCrosshairView = [[UIView alloc]init];
        _xAxisCrosshairView.frame = CGRectMake(self.marginLeft, self.marginTop, 1, self.height-self.marginTop-self.marginBottom);
        _xAxisCrosshairView.backgroundColor = kCustom0xColor(0x02084A, 1);
        _xAxisCrosshairView.hidden = YES;
    }
    return _xAxisCrosshairView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化参数
        [self initializationParameter];
        [self addGestureAction];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        //初始化参数
        [self initializationParameter];
        [self addGestureAction];
    }
    return self;
}

#pragma mark-添加手势
- (void)addGestureAction{
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0;
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    
    if (longPress.state == UIGestureRecognizerStateEnded) {
        //手势结束
        if (_cDelegate && [_cDelegate respondsToSelector:@selector(crosshairsEndMove)]) {
            [_cDelegate crosshairsEndMove];
        }
        return;
    }
     CGPoint point = [longPress locationInView:self];
     [self adjustTheAlignmentPosition:point];
    
}

#pragma mark-初始化参数
- (void)initializationParameter{
    
    self.xGridLinesCount = self.xGridLinesCount ?: 5;
    self.xGridLinesColor = self.xGridLinesColor ?:kCustom0xColor(0x02084A, 0.04);
    self.yGridLinesCount = self.yGridLinesCount ?: 4;
    self.yGridLinesColor = self.xGridLinesColor ?:kCustom0xColor(0x02084A, 0.04);
    //网格图表距离边界偏移
    self.marginLeft = 10;
    self.marginTop = 10;
    self.marginRight = 10;
    self.marginBottom = 14;
    self.yTickAmount = self.yTickAmount ?: 4;
    
}

#pragma mark-绘制图表网格
- (void)drawGraphGrid{
    
    CGFloat totalWidth = self.width - self.marginLeft - self.marginRight;
    CGFloat totalHeight = self.height - self.marginTop - self.marginBottom;
    
    //计算x轴网格间隔
    CGFloat xGridSpacing = totalWidth / (float)(self.xGridLinesCount - 1);
    //计算y轴网格间隔
    CGFloat yGridSpacing = totalHeight / (float)(self.yGridLinesCount -1);
    
    //绘制x轴网格
    for (int i = 0; i <= self.xGridLinesCount; i ++) {
        
        CGRect xRect = CGRectMake(xGridSpacing * i + self.marginLeft, self.marginTop, 0.5, totalHeight);
        UIView *xGridLine = [[UIView alloc]initWithFrame:xRect];
        xGridLine.backgroundColor = self.xGridLinesColor;
        [self addSubview:xGridLine];
        
    }
    
    //绘制y轴网格
    for (int i = 0; i < self.yGridLinesCount; i ++) {
        
        CGRect yRect = CGRectMake(self.marginLeft, self.marginTop + i * yGridSpacing, totalWidth , 0.5);
        UIView *yGridLine = [[UIView alloc]initWithFrame:yRect];
        yGridLine.backgroundColor = self.yGridLinesColor;
        [self addSubview:yGridLine];
        
    }
    
}

#pragma mark-更新图表
- (void)updateTheChart{
    
    self.xAxisCrosshairView.hidden = YES;
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    for (CALayer *layer in self.layerArray) {
        [layer removeFromSuperlayer];
    }
    
    //绘制x、y轴label
    [self drawAxisLabel];
    
    //绘制图表网格
    [self drawGraphGrid];
    
    //绘制折线
    [self drawLineData];
    
    //添加x轴准星线
    [self addSubview:self.xAxisCrosshairView];
    
}

//绘制x、y轴label
- (void)drawAxisLabel{
    //绘制y轴
    [self yAxisLabel];
    
    //绘制x轴
    [self xAxisLabel];
 
}

//绘制x轴
- (void)xAxisLabel{
    
    if (self.xAxisDataArray.count == 0) {
        return;
    }
    
    self.xAxisDataFrameArray = [NSMutableArray array];
    
    //x轴总宽度
    CGFloat totalWidth = self.width-self.marginLeft-self.marginRight;
    if (self.xTickAmount > self.xAxisDataArray.count) {
        self.xTickAmount = self.xAxisDataArray.count;
    }else if (self.xTickAmount == 0){
        self.xTickAmount = self.xAxisDataArray.count;
    }
    NSAssert(self.xTickAmount > 0,@"");
    
    CGFloat itemWidth = totalWidth/(float)(self.xAxisDataArray.count);
    CGFloat xPadding = totalWidth/(float)(self.xAxisDataArray.count - 1);
    
    //计算X轴准星线位置
    for (int i = 0; i < self.xAxisDataArray.count; i ++) {
        
        //x轴上的x坐标
        CGFloat x = self.marginLeft + i * xPadding;
        [self.xAxisDataFrameArray addObject:@(x)];
        
    }
    
    //计算X轴label位置
    CGFloat labelItemWidth = totalWidth/(float)self.xTickAmount;
    CGFloat labelxPadding = totalWidth/(float)self.xTickAmount-1;
    //计算x轴显示的数据
    NSMutableArray *xTickDataArray = [NSMutableArray array];
    if (self.isDoubleY) {
        /*双Y轴
         *计算最大时间和最小时间，总计取self.xTickAmount个值
         */
        xTickDataArray = [ChartDataManager selectPeriodFromxAxisDataArray:self.xAxisDataArray withXTickAmount:self.xTickAmount withTimeStringFormatter:@"hh:mm"];
        
    }else{
        
        if (self.xAxisDataArray.count<=7) {
             [xTickDataArray addObjectsFromArray:self.xAxisDataArray];
        }else{
            NSInteger pad = self.xAxisDataArray.count/5;
            for (int i = 0; i < 6; i ++) {
                if (i == 0) {
                    [xTickDataArray addObject:[self.xAxisDataArray firstObject]];
                }else if (i == 5){
                    [xTickDataArray addObject:[self.xAxisDataArray lastObject]];
                }else{
                    NSInteger index = i * pad;
                    [xTickDataArray addObject:self.xAxisDataArray[index]];
                }
            }
        }
        
        //处理时间
        NSMutableArray *handleXAxisArray = [NSMutableArray array];
        for (NSString *xAxis in xTickDataArray) {
//            NSRange range = [@"YYYY-MM-dd" rangeOfString:@"MM-dd"];
//            NSString *xDataString = [xAxis substringWithRange:range];
            [handleXAxisArray addObject:xAxis];
        }
        
        xTickDataArray = handleXAxisArray;
        self.xTickAmount = xTickDataArray.count;
        labelItemWidth = totalWidth/(float)self.xTickAmount;
    }
    
    for (int i = 0; i < self.xTickAmount; i ++) {
        CGRect xLabelRect = CGRectMake(self.marginLeft+labelItemWidth*i, self.height-self.marginBottom, labelItemWidth, self.marginBottom);
        UILabel *xLabel = [[UILabel alloc]initWithFrame:xLabelRect];
        xLabel.font = [UIFont systemFontOfSize:10];
        xLabel.textColor = kCustom0xColor(0x02084A, 0.4f);
        xLabel.text = [NSString stringWithFormat:@"%@",xTickDataArray[i]];
        [self addSubview:xLabel];
        
        if (i == 0) {
            xLabel.textAlignment = NSTextAlignmentLeft;
        }else if (i == self.xTickAmount-1){
            xLabel.textAlignment = NSTextAlignmentRight;
        }else{
            xLabel.textAlignment = NSTextAlignmentCenter;
        }
        
    }
}   

#pragma mark-绘制y轴
- (void)yAxisLabel{
    
    //判断是否为双Y轴
    if (self.isDoubleY) {
        
        //计算右侧Y轴数据显示宽度（+10）
        NSMutableArray *yData = [NSMutableArray array];
        for (NSArray *array in self.rightYAxisDataArray) {
            [yData addObjectsFromArray:array];
        }
        //空数组不处理
        if (yData.count == 0) {
            return;
        }
        NSString *rightYMaxString = [ChartDataManager maximumValueInTheData:yData];
        CGFloat rightLabelWidth = [ChartDataManager maximumValueWidth:rightYMaxString] + 10;
        self.marginRight = rightLabelWidth;//chart最右侧距离边框的宽度
        
        //根据最大值与最小值与Y轴个数，计算出Y轴显示的值
        NSArray *yAxisArray = [ChartDataManager yAxisDataArrayWithMaxValue:rightYMaxString withMinValue:[ChartDataManager minimumValueInTheData:yData] withYTickAmount:self.yTickAmount];
        //创建右侧Y轴label
        CGFloat yAxisPadding = (self.height-self.marginTop-self.marginBottom - (yAxisArray.count-2) * 13) / (float)yAxisArray.count;
        
        for (int i = 0; i < yAxisArray.count; i ++) {
            CGRect yAxisRect = CGRectMake(self.width-self.marginRight, (self.marginTop) + (yAxisPadding+13) * i- (yAxisPadding/2.0f-5), self.marginRight, 13);
            UILabel *yAxisLabel = [[UILabel alloc]initWithFrame:yAxisRect];
            yAxisLabel.text = yAxisArray[i];
            yAxisLabel.textAlignment = NSTextAlignmentCenter;
            yAxisLabel.font = [UIFont systemFontOfSize:9];
            yAxisLabel.textColor = kCustom0xColor(0x02084A, 0.3);
            [self addSubview:yAxisLabel];
        }
        
    }
    
    //创建左侧Y轴
    //计算右侧Y轴数据显示宽度（+10）
    NSMutableArray *yLeftData = [NSMutableArray array];
    for (NSArray *array in self.leftYAxisDataArray) {
        [yLeftData addObjectsFromArray:array];
    }
    if (yLeftData.count == 0) {
        return;
    }
    NSString *leftYMaxString = [ChartDataManager maximumValueInTheData:yLeftData];
    CGFloat leftLabelWidth = [ChartDataManager maximumValueWidth:leftYMaxString] + 10;
    self.marginLeft = leftLabelWidth;//chart最右侧距离边框的宽度
    
    //根据最大值与最小值与Y轴个数，计算出Y轴显示的值
    NSArray *yLeftAxisArray = [ChartDataManager yAxisDataArrayWithMaxValue:leftYMaxString withMinValue:[ChartDataManager minimumValueInTheData:yLeftData] withYTickAmount:self.yTickAmount];
    //创建右侧Y轴label
    CGFloat yAxisPadding = (self.height-self.marginTop-self.marginBottom - (yLeftAxisArray.count-2) * 13) / (float)yLeftAxisArray.count;
    
    for (int i = 0; i < yLeftAxisArray.count; i ++) {
        CGRect yLeftAxisRect = CGRectMake(0, (self.marginTop) + (yAxisPadding+13) * i, self.marginLeft, 13);
        UILabel *yLeftAxisLabel = [[UILabel alloc]initWithFrame:yLeftAxisRect];
        yLeftAxisLabel.text = yLeftAxisArray[i];
        yLeftAxisLabel.textAlignment = NSTextAlignmentCenter;
        yLeftAxisLabel.font = [UIFont systemFontOfSize:9];
        yLeftAxisLabel.textColor = kCustom0xColor(0x02084A, 0.3);
        [self addSubview:yLeftAxisLabel];
    }
    
}

#pragma mark-绘制折线
- (void)drawLineData{
    
    //如果是双Y轴
    if (self.isDoubleY) {
        
        [self rightYAxisFold];
        
    }
    
    //画左侧的Y轴
    [self leftYAxisFold];
    
}

#pragma mark-双Y轴图表绘制右侧Y轴数据
- (void)rightYAxisFold{
    
    NSMutableArray *yRightData = [NSMutableArray array];
      for (NSArray *array in self.rightYAxisDataArray) {
          [yRightData addObjectsFromArray:array];
      }
    //无数据不做处理
    if (yRightData.count <= 0) {
        return;
    }
      //Y轴最大最小值
      float maxRightY = [[ChartDataManager maximumValueInTheData:yRightData] floatValue];
      float minRightY = [[ChartDataManager minimumValueInTheData:yRightData] floatValue];
      float difference = maxRightY - minRightY;
      maxRightY += difference * 0.1;
      minRightY -= difference * 0.1;
      
      //Y轴长度
      float yLength = self.height-self.marginTop-self.marginBottom;
      //y轴间隔
      float yPadding = yLength / (float)([self.rightYAxisDataArray firstObject].count-1);
      //X轴长度
      float xLength = self.width-self.marginLeft-self.marginRight;
      //x轴间隔
      float xPadding = xLength / (float)(self.xAxisDataArray.count-1);
      
      int rightDataIndex = 0;
      for (NSArray *array in self.rightYAxisDataArray) {
          CGPoint prePonit;
          //计算points
          NSMutableArray *allPointsArray = [NSMutableArray array];
          [allPointsArray removeAllObjects];
          for (int i = 0; i < array.count; i ++) {
              CGFloat pointX = self.marginLeft + i * xPadding;
              float y = [array[i] floatValue];
              
              CGFloat accounted = ((maxRightY-minRightY) == 0)?0: (y-minRightY) / (maxRightY - minRightY) * yLength;
              CGFloat pointY = self.height - accounted - self.marginBottom;
              CGPoint point = CGPointMake(pointX, pointY);
              [allPointsArray addObject:[NSValue valueWithCGPoint:point]];
                              
          }
          UIBezierPath *path = [UIBezierPath bezierPath];
          [path moveToPoint:[allPointsArray[0] CGPointValue]];
          CGPoint PrePonit;
          for (int i = 0; i < allPointsArray.count; i ++) {
              if (i==0) {
                  
                 PrePonit = [allPointsArray[0] CGPointValue];
                  
              }else{
                  
                 CGPoint nowPoint = [allPointsArray[i] CGPointValue];
                 [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((PrePonit.x+nowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+nowPoint.x)/2, nowPoint.y)]; //三次曲线
                 PrePonit = nowPoint;
                             
              }
          }
          
         CAShapeLayer *shapeLayer = [CAShapeLayer layer];
         shapeLayer.path = path.CGPath;
         shapeLayer.strokeColor = [UIColor redColor].CGColor;
         shapeLayer.fillColor = [UIColor clearColor].CGColor;
         shapeLayer.borderWidth = 1.2;
          //测试渐变色
          CAGradientLayer  *gradientLayer = [[CAGradientLayer alloc]init];
          gradientLayer.colors = (self.rightGradientColorsArray.count > rightDataIndex) ? self.rightGradientColorsArray[rightDataIndex] : self.defaultLineColor;
          rightDataIndex ++;
          gradientLayer.startPoint = CGPointMake(0, 1);
          gradientLayer.endPoint = CGPointMake(1, 1);
          gradientLayer.frame = self.bounds;
          [self.layer addSublayer:gradientLayer];
          [self.layerArray addObject:gradientLayer];
          gradientLayer.mask = shapeLayer;
          
          //添加动画
          [shapeLayer addAnimation:[self lineAnimation] forKey:@"strokeEndAnimation"];
    
      }
    
}

#pragma mark-绘制左侧Y轴数据
- (void)leftYAxisFold{
    
    NSMutableArray *yLeftData = [NSMutableArray array];
    for (NSArray *array in self.leftYAxisDataArray) {
        [yLeftData addObjectsFromArray:array];
    }
    //无数据不做处理
    if (yLeftData.count <= 0) {
        return;
    }
    //Y轴最大最小值
    float maxLeftY = [[ChartDataManager maximumValueInTheData:yLeftData] floatValue];
    float minLeftY = [[ChartDataManager minimumValueInTheData:yLeftData] floatValue];
    float difference = maxLeftY - minLeftY;
    maxLeftY += difference * 0.1;
    minLeftY -= difference * 0.1;
    
    //Y轴长度
    float yLeftLength = self.height-self.marginTop-self.marginBottom;
    //y轴间隔
    float yLeftPadding = yLeftLength / (float)([self.leftYAxisDataArray firstObject].count-1);
    //X轴长度
    float xLength = self.width-self.marginLeft-self.marginRight;
    //x轴间隔
    float xPadding = xLength / (float)(self.xAxisDataArray.count-1);
    
    int leftDataIndex = 0;
    for (NSArray *array in self.leftYAxisDataArray) {
        CGPoint prePonit;
        //计算points
        NSMutableArray *allPointsArray = [NSMutableArray array];
        [allPointsArray removeAllObjects];
        for (int i = 0; i < array.count; i ++) {
            CGFloat pointX = self.marginLeft + i * xPadding;
            float y = [array[i] floatValue];
            CGFloat pointY = self.height - (y-minLeftY) / (maxLeftY - minLeftY) * yLeftLength - self.marginBottom;
            CGPoint point = CGPointMake(pointX, pointY);
            [allPointsArray addObject:[NSValue valueWithCGPoint:point]];
    
        }
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:[allPointsArray[0] CGPointValue]];
        CGPoint PrePonit;
        for (int i = 0; i < allPointsArray.count; i ++) {
            if (i==0) {
                
               PrePonit = [allPointsArray[0] CGPointValue];
                
            }else{
                
               CGPoint nowPoint = [allPointsArray[i] CGPointValue];
               [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((PrePonit.x+nowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+nowPoint.x)/2, nowPoint.y)]; //三次曲线
               PrePonit = nowPoint;
                           
            }
        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.borderWidth = 1.2;
        //渐变色图层
        CAGradientLayer  *gradientLayer = [[CAGradientLayer alloc]init];
        gradientLayer.colors = (self.leftGradientColorsArray.count > leftDataIndex) ? self.leftGradientColorsArray[leftDataIndex] : self.defaultLineColor;
        leftDataIndex ++;
        gradientLayer.frame = self.bounds;
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        [self.layer addSublayer:gradientLayer];
        [self.layerArray addObject:gradientLayer];
        gradientLayer.mask = shapeLayer;
        
        [shapeLayer addAnimation:[self lineAnimation] forKey:@"strokeEndAnimation"];
    }
    
}

//动画
- (CABasicAnimation *)lineAnimation{
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration       = 1;
    animation.repeatCount    = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue      = [NSNumber numberWithFloat:0.0f];
    
    animation.toValue        = [NSNumber numberWithFloat:1.0f];
    return animation;
}

//处理手势位置，调准准星线位置
- (void)adjustTheAlignmentPosition:(CGPoint)point{
    
    if (self.xAxisDataFrameArray.count>1) {
        self.xAxisCrosshairView.hidden = NO;
    }
    
    CGFloat pointX = point.x;
    NSUInteger xIndex = [self beforeTheNumerical:pointX];
    
    if (xIndex == 0) {
        //回调索引（避免多次回调与上次所在索引比较）
        if (self.currentCrosshairIndex != xIndex) {
            self.currentCrosshairIndex = xIndex;
            //第一个X点的处理
            self.xAxisCrosshairView.x = [[self.xAxisDataFrameArray firstObject] floatValue];
            if (_cDelegate && [_cDelegate respondsToSelector:@selector(crosshairsMoveingWithIndex:)]) {
                [_cDelegate crosshairsMoveingWithIndex:xIndex];
            }
        }
        
        return;
    }else if (xIndex == self.xAxisDataFrameArray.count-1){
       
        //回调索引（避免多次回调与上次所在索引比较）
        if (self.currentCrosshairIndex != xIndex) {
            self.currentCrosshairIndex = xIndex;
            //最后一个X点的处理
            self.xAxisCrosshairView.x = [[self.xAxisDataFrameArray lastObject] floatValue];
            if (_cDelegate && [_cDelegate respondsToSelector:@selector(crosshairsMoveingWithIndex:)]) {
                [_cDelegate crosshairsMoveingWithIndex:xIndex];
            }
        }
        return;
    }
    
    CGFloat lastX = [self.xAxisDataFrameArray[xIndex-1] floatValue];
    CGFloat nextX = [self.xAxisDataFrameArray[xIndex] floatValue];
    
    NSUInteger index = ((pointX-lastX) >= (nextX-pointX)) ? xIndex : (xIndex-1);
    
    //回调索引（避免多次回调与上次所在索引比较）
    if (self.currentCrosshairIndex != xIndex) {
        self.currentCrosshairIndex = xIndex;
        if (self.xAxisDataFrameArray.count > index) {
            self.xAxisCrosshairView.x = [self.xAxisDataFrameArray[index] floatValue];
        }
        
        if (_cDelegate && [_cDelegate respondsToSelector:@selector(crosshairsMoveingWithIndex:)]) {
            [_cDelegate crosshairsMoveingWithIndex:index];
        }
    }
    
}

//获取滑动手势在哪个数值之前
- (NSUInteger)beforeTheNumerical:(CGFloat)pointX{
    NSInteger count = self.xAxisDataFrameArray.count;
    for (int i = 0; i < count; i ++) {
        if (pointX<=[self.xAxisDataFrameArray[i] floatValue]) {
            return i;
        }else if (pointX >= [self.xAxisDataFrameArray[count-1] floatValue]){
            return count-1;
        }
    }
    return 0;
}

#pragma mark-通过数据驱动X轴准星线移动
- (void)driveCrosshairLineMovement:(double)index{
    
    self.xAxisCrosshairView.hidden = NO;
    if (self.xAxisDataFrameArray.count > index) {
        self.xAxisCrosshairView.x = self.marginLeft + (self.width-self.marginLeft-self.marginRight)*index;
    }
}

@end


@implementation ChartDataManager

//获取数据中的最大值
+ (NSString *)maximumValueInTheData:(NSArray *)dataArray{
    
    NSString *maxDataString = @"";
    maxDataString = [dataArray firstObject];
    for (NSString *value in dataArray) {
        if ([value floatValue] > [maxDataString floatValue]) {
            maxDataString = value;
        }
    }
    return maxDataString;
}

//获取数据中的最小值
+ (NSString *)minimumValueInTheData:(NSArray *)dataArray{
    
    NSString *minDataString = @"";
    minDataString = [dataArray firstObject];
    for (NSString *value in dataArray) {
        if ([value floatValue] < [minDataString floatValue]) {
            minDataString = value;
        }
    }
    return minDataString;
}

//计算最大值的宽度
+ (CGFloat)maximumValueWidth:(NSString *)maximum{
    
    maximum = [NSString stringWithFormat:@"%.1f",[maximum floatValue]];
    UILabel *text = [[UILabel alloc]init];
    text.text = maximum;
    text.font = [UIFont systemFontOfSize:9];
    CGSize size = [text.text sizeWithAttributes:@{NSFontAttributeName:text.font}];
    return size.width;
}

//计算Y轴显示的数据
+ (NSArray *)yAxisDataArrayWithMaxValue:(NSString *)maxValue withMinValue:(NSString *)minValue withYTickAmount:(NSUInteger)yTickAmount{
    
    float maxV = [maxValue floatValue];
    float minV = [minValue floatValue];
    float difference = maxV - minV;
    maxV += difference * 0.1;
    minV -= difference * 0.1;
    if (minV<0) {
        minV = 0;
    }
    
    float space = (maxV - minV) / yTickAmount;
    NSMutableArray *yAxisData = [NSMutableArray array];
    for (int i = 0; i < (int)yTickAmount; i ++) {
        if (i == 0) {
            [yAxisData addObject:[NSString stringWithFormat:@"%.f",maxV]];
        }else if (i == (int)yTickAmount-1){
            [yAxisData addObject:[NSString stringWithFormat:@"%.f",minV]];
        }else{
            [yAxisData addObject:[NSString stringWithFormat:@"%.f",(maxV - space*i)]];
        }
    }
    
    return yAxisData;
}

//从两个时间字符串选X段时间
+ (NSMutableArray *)selectPeriodFromxAxisDataArray:(NSArray *)xAxisDataArray  withXTickAmount:(NSInteger)xTickAmount withTimeStringFormatter:(NSString *)formatter{
    
    
    NSMutableArray *timeArray = [NSMutableArray array];
    
    xTickAmount = (xTickAmount < 2) ? 2:xTickAmount;
    NSInteger padding = xAxisDataArray.count/(xTickAmount-1);
    for (int i = 0; i < xTickAmount; i ++) {
        if (i == 0) {
            NSString *startTime = [xAxisDataArray firstObject];
            [timeArray addObject:[ChartDataManager timestampSwitchTime:startTime andFormatter:formatter]];
        }else if (i == xTickAmount-1){
            NSString *endTimes = [xAxisDataArray lastObject];
            [timeArray addObject:[ChartDataManager timestampSwitchTime:endTimes andFormatter:formatter]];
        }else{
            NSInteger newIndex = i * padding;
            if (newIndex < xAxisDataArray.count) {
                NSString *currentTime = xAxisDataArray[newIndex];
                [timeArray addObject:[ChartDataManager timestampSwitchTime:currentTime andFormatter:formatter]];
            }else{
                
                [timeArray addObject:[ChartDataManager timestampSwitchTime:[xAxisDataArray lastObject] andFormatter:formatter]];
            }
        }
    
    }
    
    return timeArray;
}

+(NSString *)timestampSwitchTime:(NSString *)times andFormatter:(NSString *)format{
    
    NSRange rang = [@"YYYY-MM-dd hh:mm:ss" rangeOfString:format];
    NSString *time = [times substringWithRange:rang];
    return time;
    
}

@end
