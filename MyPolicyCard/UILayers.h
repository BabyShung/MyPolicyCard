//
//  UILayers.h
//  EdibleBlueCheese
//
//  Created by Hao Zheng on 4/22/14.
//  Copyright (c) 2014 Hao Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILayers : NSObject


-(CALayer *)borderLayerWidth:(CGFloat) width andHeight:(CGFloat) height andBorderWidth:(CGFloat) bw andColor:(UIColor *) color;

-(CAShapeLayer *)innerShadow:(CGRect)bounds andTopOffset:(CGFloat)top andBottomOffset:(CGFloat)bottom andLeftOffset:(CGFloat)left andRightOffset:(CGFloat)right;
@end
