//
//  UILayers.m
//  EdibleBlueCheese
//
//  Created by Hao Zheng on 4/22/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import "UILayers.h"
@implementation UILayers


-(CALayer *)borderLayerWidth:(CGFloat) width andHeight:(CGFloat) height andBorderWidth:(CGFloat) bw andColor:(UIColor *) color{
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, width, height);
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setBorderWidth:bw];
    [borderLayer setBorderColor:[color CGColor]];
    
    return borderLayer;
}

-(CAShapeLayer *)innerShadow:(CGRect)bounds andTopOffset:(CGFloat)top andBottomOffset:(CGFloat)bottom andLeftOffset:(CGFloat)left andRightOffset:(CGFloat)right{
    
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    
    shadowLayer.masksToBounds = YES;
    shadowLayer.needsDisplayOnBoundsChange = YES;
    shadowLayer.shouldRasterize = YES;
    
    [shadowLayer setFrame:bounds];
    
    // Standard shadow stuff
    [shadowLayer setShadowColor:[[UIColor colorWithWhite:0 alpha:1] CGColor]];
    [shadowLayer setShadowOffset:CGSizeMake(0.0f, 15.0f)];//55 is height of shadow offset
    [shadowLayer setShadowOpacity:1.0f];
    [shadowLayer setShadowRadius:20];
    
    // Causes the inner region in this example to NOT be filled.
    [shadowLayer setFillRule:kCAFillRuleEvenOdd];
    
    CGRect largerRect = CGRectMake(bounds.origin.x - left,
                                   bounds.origin.y - top,
                                   bounds.size.width + left + right,
                                   bounds.size.height + top + bottom);
    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, largerRect);
    
    // Add the inner path so it's subtracted from the outer path.
    // someInnerPath could be a simple bounds rect, or maybe
    // a rounded one for some extra fanciness.
    CGFloat cornerRadius = 0;
    UIBezierPath *bezier;
    if (cornerRadius) {
        bezier = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:cornerRadius];
    } else {
        bezier = [UIBezierPath bezierPathWithRect:bounds];
    }
    
    CGPathAddPath(path, NULL, bezier.CGPath);
    CGPathCloseSubpath(path);
    
    [shadowLayer setPath:path];
    CGPathRelease(path);
    
    return shadowLayer;

}

@end
