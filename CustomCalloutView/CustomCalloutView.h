//
//  CustomCalloutView.h
//  WiFiSurfing2
//
//  Created by aora on 15/5/29.
//  Copyright (c) 2015年 Aora. All rights reserved.
//

typedef void (^CustomCalloutViewClickedBlock)(id userinfo);

#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title, *subtitle;
@property (nonatomic, assign) id userinfo;

@property (nonatomic, copy) CustomCalloutViewClickedBlock clickedBlock;

@property (nonatomic, assign) BOOL rightArrowHidden;

-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image
                    andTitle:(NSString*)title andSubTitle:(NSString*)subtitle;

-(void)reLayoutSubviews;
@end
