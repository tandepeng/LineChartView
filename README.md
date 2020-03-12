# LineChartView
背景因公司项目需要，需要绘制单Y轴以及双Y轴的渐变色折线图。此前尝试过功能强大的AAChartKit，功能全面、图表类型丰富。因项目UI的限制，以及项目中需要一个通过数据驱动图表中准星线移动的功能，不得不放弃AAChartKit。于是花了两天时间绘制了一个功能简单，使用更加简洁的折线图表。目前实现的功能1.单Y轴折线图，可展示多条折线，每条折线可设置渐变色2.自定义绘制网格的（如4x5:x轴网格线4条，y轴网格线5条）3.自定义网格线的颜色4.自定义y轴显示数据个数5.根据y轴数据自动计算y轴显示数据6.可更新刷新表格数据（x轴数据、y轴数据都可以刷新）7.支持双Y轴表格8.双Y轴表格功能设置与单Y轴功能相同说明该图表源码仅供学习交流使用。图表展示gif单y轴图表：双y轴图表：使用方法1.初始化？与普通view一致_chartView = [[CustomChartView alloc]initWithFrame:CGRectMake(12, 150, kScreenWidth-24, 210)];2.单Y轴还是双Y轴？_chartView.isDoubleY = NO;3.设置代理？准星线回调方法_chartView.cDelegate = self;//准信线所在索引- (void)crosshairsMoveingWithIndex:(NSUInteger)index;//准信线滑动结束- (void)crosshairsEndMove;4.配置表格相关参数?//x轴网格线个数
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
    self.chartView.marginBottom = 14;4中所有的配置都有默认值，可以不设置。5.折线渐变色颜色数组？- (NSArray *)gradientColorsArray{    if (!_gradientColorsArray) {        _gradientColorsArray = @[@[(__bridge id)kCustom0xColor(0xFFE100, 1).CGColor,(__bridge id)kCustom0xColor(0xFFCF00, 1).CGColor,(__bridge id)kCustom0xColor(0xFBAB1B, 1).CGColor,(__bridge id)kCustom0xColor(0xF88B34, 1).CGColor],@[(__bridge id)kCustom0xColor(0xFC2FB1, 1).CGColor,(__bridge id)kCustom0xColor(0xD715F3, 1).CGColor,(__bridge id)kCustom0xColor(0xAA3CF0, 1).CGColor,(__bridge id)kCustom0xColor(0xC38BFF, 1).CGColor],@[(__bridge id)kCustom0xColor(0x90FEA2, 1).CGColor,(__bridge id)kCustom0xColor(0x21BCFF, 1).CGColor,(__bridge id)kCustom0xColor(0x406EE2, 1).CGColor,(__bridge id)kCustom0xColor(0x1D24C2, 1).CGColor]];    }    return _gradientColorsArray;}//y轴的每条折线的渐变色数组。与每条折线需要一一对应






    _chartView.leftGradientColorsArray = self.gradientColorsArray;6.添加多条Y轴？self.yAxisFirstLine = @[@2,@4,@1,@0,@3,@6,@2];    self.yAxisSecondLine = @[@0,@2,@4,@5,@3,@2,@6];    self.yAxisThirdLine = @[@1,@2,@1,@3,@3,@4,@1];    



_chartView.leftYAxisDataArray = @[self.yAxisFirstLine,self.yAxisSecondLine,self.yAxisThirdLine];7.设置X轴上的数据self.xAxis = @[@"03-06",@"03-07",@"03-08",@"03-09",@"03-10",@"03-11",@"03-12"];
_chartView.xAxisDataArray = self.xAxis;8.每次数据完成，如何刷新图表？ //数据配置完成之后,绘制图表
    [_chartView updateTheChart];9.双Y轴的使用方法与单Y轴的一致，在这里就不做详细的介绍了~重要信息1.现在X轴数据因项目原因，都是时间参数，并且对X轴时间做了相关处理。如不需要，可以直接屏蔽掉，后期会进行优化处理2.y轴label展示位置不够完善，后期会处理最后附上项目下载地址 LineChartView。如有您有更好的想法或提议，可以在评论区进行交流互动，谢谢

作者：1年1℃的夏天
链接：https://juejin.im/post/5e69a8a4e51d450edd292d76
来源：掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
