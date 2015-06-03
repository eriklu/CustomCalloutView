//
//  CustomCalloutView.m
//  WiFiSurfing2
//
//  Created by aora on 15/5/29.
//  Copyright (c) 2015年 Aora. All rights reserved.
//

#import "CustomCalloutView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define MAX_WIDTH (SCREEN_WIDTH - 30)

#define MARGIN_LEFT 5

#define ICON_SIZE 35

#define ICON_ARROW_SIZE 20

#define MARGIN_RIGHT 5
#define MARGIN_TOP 5
#define MARGIN_BOTTON 5

#define TIP_ARROW_HEIGHT 15

#define TITLE_TOP_MARGIN 5
#define SUBTITLE_TOP_MARGIN 20

#define TITLE_FONT_SIZE 17

#define SUBTITLE_FONT_SIZE 12


@interface CustomCalloutView ()
{
    NSTextStorage *_storage;
    NSLayoutManager *_layoutManager;
    NSTextContainer *_container;
}
@end

@implementation CustomCalloutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame andImage:(UIImage*)image
                    andTitle:(NSString*)title andSubTitle:(NSString*)subtitle{
    if(self = [super initWithFrame:frame]){
        self.title = title;
        self.image = image;
        self.subtitle = subtitle;
        self.backgroundColor = [UIColor clearColor];
        
        
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, ICON_SIZE, ICON_SIZE)];
        iv.image = image;
        iv.tag = 101;
        [self addSubview:iv];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_LEFT + ICON_SIZE + 10, TITLE_TOP_MARGIN, frame.size.width - 10 - 60, 14)];
        lbl.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        lbl.text = self.title;
        lbl.tag = 102;
        [self addSubview:lbl];
        
        CGSize size = [subtitle boundingRectWithSize:CGSizeMake(lbl.frame.size.width, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
        UILabel * lblSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, size.width, size.height)];
        lblSubtitle.text = subtitle;
        lblSubtitle.tag = 103;
        lblSubtitle.font = [UIFont systemFontOfSize:SUBTITLE_FONT_SIZE];
        lblSubtitle.numberOfLines = 0;
        [self addSubview:lblSubtitle];
        
        NSAttributedString *textString =  [[NSAttributedString alloc] initWithString:subtitle attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]                                                                                                                                 }];
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:textString];
        _storage = textStorage;
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        _layoutManager = layoutManager;
        [textStorage addLayoutManager: layoutManager];
        NSTextContainer *textContainer = [NSTextContainer new];
        textContainer.size = CGSizeMake(200, 100);
        UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0,  ICON_SIZE, 10)];

        textContainer.exclusionPaths = @[path1];
        textContainer.lineBreakMode = NSLineBreakByWordWrapping;
        _container = textContainer;
        [layoutManager addTextContainer: textContainer];
        
        UITextView *tvSubtitle = [[UITextView alloc] initWithFrame:CGRectZero textContainer:textContainer];
        tvSubtitle.frame = CGRectMake(MARGIN_LEFT  - tvSubtitle.contentInset.left, SUBTITLE_TOP_MARGIN - tvSubtitle.contentInset.top, 0, 0);
        tvSubtitle.tag = 104;
        tvSubtitle.backgroundColor = [UIColor clearColor];
        tvSubtitle.scrollEnabled = NO;
        tvSubtitle.editable = NO;
        //tvSubtitle.backgroundColor = [UIColor redColor];
        [self addSubview:tvSubtitle];
        
        UIImageView *rigthArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail"]];
        rigthArrow.tag = 105;
        [self addSubview:rigthArrow];
        
        UIButton *btnBg = [UIButton buttonWithType:UIButtonTypeSystem];
        btnBg.frame = frame;
        btnBg.tag = 100;
        [btnBg addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBg];
    }
    
    [self reLayoutSubviews];
    return self;
}

-(void)btnClicked:(id)sender{
    if(!self.rightArrowHidden && self.clickedBlock){
        self.clickedBlock(self.userinfo);
    }
}


#define kArrorHeight        10

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

-(void)reLayoutSubviews{
    int width_max_msg = MAX_WIDTH - MARGIN_LEFT - MARGIN_RIGHT - ICON_SIZE - 10 - (self.rightArrowHidden ? 0 : (ICON_ARROW_SIZE + 10));
    
    CGSize sizeTitle = [self.title boundingRectWithSize:CGSizeMake(width_max_msg, 20) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TITLE_FONT_SIZE]} context:nil].size;
    CGSize sizeSubtitle = [self.subtitle boundingRectWithSize:CGSizeMake(width_max_msg, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SUBTITLE_FONT_SIZE]} context:nil].size;
    
    int width = MAX(sizeTitle.width, sizeSubtitle.width) + 1;
    
    if(sizeSubtitle.height > 15){//多行显示
        UIView *lbl = [self viewWithTag:103];
        lbl.hidden = YES;
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.subtitle attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:SUBTITLE_FONT_SIZE]                                                                                                                                 }];
        [_storage setAttributedString:str];
        _container.size = CGSizeMake(width + 10 + ICON_SIZE, 200);
        
        CGSize size = [_layoutManager boundingRectForGlyphRange:NSMakeRange(0, [self.subtitle length]) inTextContainer:_container].size;
        UITextView *tv = (UITextView *)[self viewWithTag:104];
        
        CGRect r = tv.frame;
        tv.frame = CGRectMake(r.origin.x, r.origin.y, width + tv.textContainerInset.left + tv.textContainerInset.right + ICON_SIZE + 10 , size.height + tv.textContainerInset.top + tv.textContainerInset.bottom + 2);
        tv.hidden = NO;
        
        self.frame = CGRectMake(0, 0, width  - (- MARGIN_LEFT - MARGIN_RIGHT - ICON_SIZE - 10) + (self.rightArrowHidden ? 0 : (ICON_ARROW_SIZE + 10)), tv.frame.origin.y + tv.frame.size.height + 10);
        

    }else {//一行显示
        UIView *tv = [self viewWithTag:104];
        tv.hidden = YES;
        UILabel *lbl = (UILabel *)[self viewWithTag:103];
        lbl.hidden = NO;
        lbl.text = self.subtitle;
        lbl.frame = CGRectMake(MARGIN_LEFT + ICON_SIZE + 10, SUBTITLE_TOP_MARGIN, width, 20);
        
        self.frame = CGRectMake(0, 0, width  - (- MARGIN_LEFT - MARGIN_RIGHT - ICON_SIZE - 10) + (self.rightArrowHidden ? 0 : (ICON_ARROW_SIZE + 10)), 60);
    }
    
    UIView *lblTitle = [self viewWithTag: 102];
    lblTitle.frame = CGRectMake(MARGIN_LEFT + ICON_SIZE + 10, TITLE_TOP_MARGIN, width, 20);
    
    UIView *ivRightArrow = [self viewWithTag: 105];
    ivRightArrow.center = CGPointMake(self.frame.size.width - 10 - ICON_ARROW_SIZE / 2, self.frame.size.height / 2);
    ivRightArrow.hidden = self.rightArrowHidden;
    
    UIView *btn = [self viewWithTag:100];
    btn.frame = self.frame;
    [self setNeedsDisplay];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    UILabel *lbl = (UILabel *)[self viewWithTag:102];
    lbl.text = title;
}

-(void)setImage:(UIImage *)image{
    UIImageView *iv = (UIImageView*)[self viewWithTag:101];
    iv.image = image;
}



@end
