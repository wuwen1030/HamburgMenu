//
//  HamburgButton.m
//  HamburgMenu
//
//  Created by Ben on 15/1/16.
//  Copyright (c) 2015年 Tuniu. All rights reserved.
//

#import "HamburgButton.h"

@interface CALayer (Private)

- (void)ocb_applyAnimation:(CABasicAnimation *)animation;

@end

@implementation CALayer (Private)

- (void)ocb_applyAnimation:(CABasicAnimation *)animation
{
    CABasicAnimation *copyAnimation = [animation copy];
    
    if (!copyAnimation.fromValue)
    {
        copyAnimation.fromValue = [self.presentationLayer valueForKeyPath:copyAnimation.keyPath];
    }
    
    [self addAnimation:copyAnimation forKey:copyAnimation.keyPath];
    [self setValue:copyAnimation.toValue forKey:copyAnimation.keyPath];
}

@end

static CGFloat menuStrokeStart = 0.325;
static CGFloat menuStrokeEnd = 0.9;
static CGFloat hamburgerStrokeStart = 0.028;
static CGFloat hamburgerStrokeEnd = 0.111;


@interface HamburgButton ()

@property (nonatomic, strong) CAShapeLayer *top;
@property (nonatomic, strong) CAShapeLayer *middle;
@property (nonatomic, strong) CAShapeLayer *bottom;
@property (nonatomic, strong) UIBezierPath *shortStroke;
@property (nonatomic, strong) UIBezierPath *outline;

@end

@implementation HamburgButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.top = [CAShapeLayer layer];
    self.middle = [CAShapeLayer layer];
    self.bottom = [CAShapeLayer layer];
    
    self.top.path = self.shortStroke.CGPath;
    self.middle.path = self.outline.CGPath;
    self.bottom.path = self.shortStroke.CGPath;
    
    for (CAShapeLayer *layer in @[self.top, self.middle, self.bottom])
    {
        layer.fillColor = nil;
        layer.strokeColor = [UIColor whiteColor].CGColor;
        layer.lineWidth = 4;
        layer.miterLimit = 4;
        layer.lineCap = kCALineCapRound;
        layer.masksToBounds = YES;
        
        CGPathRef strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4);
        layer.bounds = CGPathGetPathBoundingBox(strokingPath);
        
        // Disable default animation for those keys
        layer.actions = @{@"strokeStart":[NSNull null],
                          @"strokeEnd":[NSNull null],
                          @"transform":[NSNull null]};
        
        [self.layer addSublayer:layer];
        
        self.top.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
        self.top.position = CGPointMake(40, 18);
        
        self.middle.position = CGPointMake(27, 27);
        self.middle.strokeStart = hamburgerStrokeStart;
        self.middle.strokeEnd = hamburgerStrokeEnd;
        
        self.bottom.anchorPoint = CGPointMake(28.0 / 30.0, 0.5);
        self.bottom.position = CGPointMake(40, 36);
    }
}

- (UIBezierPath *)shortStroke
{
    if (_shortStroke == nil)
    {
        _shortStroke = [UIBezierPath bezierPath];
        [_shortStroke moveToPoint:CGPointMake(2, 2)];
        [_shortStroke addLineToPoint:CGPointMake(28, 2)];
    }
    return _shortStroke;
}

- (UIBezierPath *)outline
{
    if (_outline == nil)
    {
        _outline = [UIBezierPath bezierPath];
        [_outline moveToPoint:CGPointMake(10, 27)];
        [_outline addCurveToPoint:CGPointMake(40, 27) controlPoint1:CGPointMake(12, 27) controlPoint2:CGPointMake(28.02, 27)];
        [_outline addCurveToPoint:CGPointMake(27, 2) controlPoint1:CGPointMake(55.92, 27) controlPoint2:CGPointMake(50.47, 2.0)];
        [_outline addCurveToPoint:CGPointMake(2, 27) controlPoint1:CGPointMake(13.16, 2) controlPoint2:CGPointMake(2, 13.16)];
        [_outline addCurveToPoint:CGPointMake(27, 52) controlPoint1:CGPointMake(2, 40.84) controlPoint2:CGPointMake(13.16, 52)];
        [_outline addCurveToPoint:CGPointMake(52, 27) controlPoint1:CGPointMake(40.84, 52) controlPoint2:CGPointMake(52, 40.84)];
        [_outline addCurveToPoint:CGPointMake(27, 2) controlPoint1:CGPointMake(52, 13.16) controlPoint2:CGPointMake(42.39, 2)];
        [_outline addCurveToPoint:CGPointMake(2, 27) controlPoint1:CGPointMake(13.16, 2) controlPoint2:CGPointMake(2, 13.16)];
    }
    return _outline;
}

- (void)setShowMenu:(BOOL)showMenu
{
    _showMenu = showMenu;
    
    CABasicAnimation *strokeStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    CABasicAnimation *strokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    if (showMenu)
    {
        strokeStart.toValue = @(menuStrokeStart);
        strokeStart.duration = 0.5f;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.4 :0.5 :1];
        
        strokeEnd.toValue = @(menuStrokeEnd);
        strokeEnd.duration = 0.6f;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :-0.4 :0.5 :1];
    }
    else
    {
        strokeStart.toValue = @(hamburgerStrokeStart);
        strokeStart.duration = 0.5f;
        strokeStart.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0 :0.5 :1.2];
        strokeStart.beginTime = CACurrentMediaTime() + 0.1;
        strokeStart.fillMode = kCAFillModeBackwards;
        
        strokeEnd.toValue = @(hamburgerStrokeEnd);
        strokeEnd.duration = 0.6f;
        strokeEnd.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.3 :0.5 :0.9];
    }
    
    [self.middle ocb_applyAnimation:strokeStart];
    [self.middle ocb_applyAnimation:strokeEnd];
    
    CABasicAnimation *topTransform = [CABasicAnimation animationWithKeyPath:@"transform"];
    topTransform.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5 :-0.8 :0.5 :1.85];
    topTransform.duration = 0.4f;
    topTransform.fillMode = kCAFillModeBackwards;
    
    CABasicAnimation *bottomTransform = [topTransform copy];
    
    if (showMenu)
    {
        CATransform3D transition = CATransform3DMakeTranslation(-4, 0, 0);
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transition, -0.7853975, 0, 0, 1)];
        topTransform.beginTime = CACurrentMediaTime() + 0.25;
        
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transition, 0.7853975, 0, 0, 1)];
        bottomTransform.beginTime = CACurrentMediaTime() + 0.25;
    }
    else
    {
        topTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        topTransform.beginTime = CACurrentMediaTime() + 0.5;
        
        bottomTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        bottomTransform.beginTime = CACurrentMediaTime() + 0.5;
    }
    
    [self.top ocb_applyAnimation:topTransform];
    [self.bottom ocb_applyAnimation:bottomTransform];
}

@end
