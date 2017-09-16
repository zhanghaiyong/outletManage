//
//  PiechartDetchView.m
//  PiechartsDemo
//
//  Created by LIAN on 16/2/25.
//  Copyright (c) 2016年 com.Alice. All rights reserved.
//

#import "PiechartDetchView.h"
#import "PiechartModel.h"

@implementation PiechartDetchView

@synthesize circlePath = _circlePath;
@synthesize bgCircleLayer = _bgCircleLayer;
@synthesize strokeWidth = _strokeWidth;

@synthesize percentLayer = _percentLayer;
@synthesize percentColor = _percentColor;
@synthesize perArray = _perArray;
@synthesize layerArray = _layerArray;

@synthesize isAnimation = _isAnimation;
@synthesize textV   = _textV;
@synthesize lab     = _lab;


-(id)initWithFrame:(CGRect)frame withStrokeWidth:(CGFloat )width andColor:(UIColor *)color andPerArray:(NSArray *)perArray andAnimation:(BOOL) animation
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        _layerArray = [[NSMutableArray alloc]init];
        _strokeWidth = width;
        _percentColor = color;
        _perArray = [NSArray arrayWithArray:perArray];
        _isAnimation = animation;
        
        CGPoint centerPoint = CGPointMake(frame.size.width /2, frame.size.height /2);
        CGFloat radius = (frame.size.width-width)/2;
//        if (frame.size.width <= frame.size.height) {
//            radius = (frame.size.width -10)/2;
//        }
//        else
//        {
//            radius = (frame.size.height -10)/2;
//        }
        
        _circlePath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:M_PI_2*3 endAngle:-M_PI_2 clockwise:NO];
        
        [self buildBGCircleLayer];
        
        [self initTextView:CGRectMake(width, frame.size.height/4, frame.size.width-width*2, 40)];
        [self initLabelWithFrame:CGRectMake(width, _textV.bottom, frame.size.width-width*2, 20)];
    }
    return self;
}

- (void)initTextView:(CGRect )frame {

    _textV = [[UITextView alloc]initWithFrame:frame];
    _textV.textColor = [Uitils colorWithHex:noDataTipsColor];
    _textV.backgroundColor = [UIColor clearColor];
    _textV.font = [UIFont boldSystemFontOfSize:12];
    _textV.textAlignment = NSTextAlignmentCenter;
    _textV.userInteractionEnabled = NO;
    _textV.editable = NO;
    [self addSubview:_textV];
}

- (void)initLabelWithFrame:(CGRect)frame {

    _lab = [[UILabel alloc]initWithFrame:frame];
    _lab.textColor = [UIColor blackColor];
    _lab.font = [UIFont systemFontOfSize:10];
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.adjustsFontSizeToFitWidth = YES;
//    _lab.backgroundColor = [UIColor purpleColor];
    [self addSubview:_lab];
}

-(void)buildBGCircleLayer
{
    _bgCircleLayer = [CAShapeLayer layer];
    _bgCircleLayer.path = _circlePath.CGPath;
    _bgCircleLayer.strokeColor = _percentColor.CGColor;
    _bgCircleLayer.fillColor = [UIColor clearColor].CGColor;
    _bgCircleLayer.lineWidth = _strokeWidth;
    
    [self.layer addSublayer:_bgCircleLayer];
    
    
    [self addShowPercentLayer];

}

-(void)addShowPercentLayer
{
    CGFloat startPer = 0;
    for (PiechartModel *model in _perArray) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = _circlePath.CGPath;
        layer.strokeColor = [model color].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = _strokeWidth;
        layer.strokeStart = startPer;
        layer.strokeEnd = startPer +[model.perStr floatValue];
        [self.layer addSublayer:layer];
        [_layerArray addObject:layer];
        
        startPer += [model.perStr floatValue];
        NSLog(@"the model per is %@",model.perStr);
        if (_isAnimation) {
            [self percentAnimationEveryLayer:layer];
        }
    }
   
}
-(void)percentAnimationEveryLayer:(CAShapeLayer *)layer
{
    CABasicAnimation *strokeEndAnimation = nil;
    strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = 1.0f;
    strokeEndAnimation.fromValue = @(layer.strokeStart);
    strokeEndAnimation.toValue = @(layer.strokeEnd);
    strokeEndAnimation.autoreverses = NO; //无自动动态倒退效果
    strokeEndAnimation.delegate = self;
    
    [layer addAnimation:strokeEndAnimation forKey:@"strokeEnd"];
}
//等动画结束之后的操作
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"动画结束干点什么好呢");

}


/**
 *  点击分离
 *
 *  @return <#return value description#>
 */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
