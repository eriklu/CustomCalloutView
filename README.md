# CustomCalloutView
为地图自定义的CustomCalloutView，主要特性是子标题会和左侧图片混排。

效果如下：
![效果图片](https://github.com/eriklu/CustomCalloutView/blob/master/1.png?raw=true)


代码使用例子

```
CustomCalloutView *calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectZero andImage:[UIImage imageNamed:@"wifi_cmcc"] andTitle:@"中国移动" andSubTitle:@"中华人民共和国广东省深圳市福田区深南大道6007号安徽大厦创展中心（西门）停车场"];
    [calloutView reLayoutSubviews];
    CGSize  winSize = [UIScreen mainScreen].bounds.size;
    __weak CustomCalloutView *weakObj = calloutView;
    calloutView.userinfo = @"userinfo";//设置事件对象，作为响应事件的参数回传。
    //设置按钮点击响应block
    calloutView.clickedBlock = ^(id userinfo){
        if(weakObj.rightArrowHidden){
            weakObj.rightArrowHidden = NO;
            //修改内容后，需要重新计算布局。
            [weakObj reLayoutSubviews];
        }else{
            weakObj.rightArrowHidden = YES; //不显示右侧箭头，同时点击事件也不响应。
            weakObj.subtitle = [NSString stringWithFormat:@"%@|%@", weakObj.subtitle, @"中国"];
            [weakObj reLayoutSubviews];
        }
        weakObj.center = CGPointMake(winSize.width / 2, 100);

    };
    
    
    calloutView.center = CGPointMake(winSize.width / 2, 100);
    [self.view addSubview:calloutView];

```

