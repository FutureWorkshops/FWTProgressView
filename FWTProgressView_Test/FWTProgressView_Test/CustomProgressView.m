
//  CustomProgressView.m
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 13/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "CustomProgressView.h"

NSString *const keyFadeAnimation = @"keyProgressAnimation";

@interface FWTProgressView (Private)
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, getter = isAnimationEnabled, assign) BOOL animationEnabled;
@end

@interface CustomProgressView ()
{
    CAGradientLayer *_gradientLayer;
}
@property (nonatomic, retain) CAGradientLayer *gradientLayer;
@end

@implementation CustomProgressView
@synthesize gradientLayer = _gradientLayer;

- (void)dealloc
{
    self.gradientLayer = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.gradientLayer.superlayer)
        [self.contentView.layer insertSublayer:self.gradientLayer atIndex:0];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.gradientLayer.frame = self.contentView.bounds;
    [CATransaction commit];
}

#pragma mark - Getters
- (CAGradientLayer *)gradientLayer
{
    if (!self->_gradientLayer)
    {
        self->_gradientLayer = [[CAGradientLayer alloc] init];
        self->_gradientLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor redColor].CGColor];
        self->_gradientLayer.startPoint = CGPointMake(.0f, .5f);
        self->_gradientLayer.endPoint = CGPointMake(1.0f, .5f);
    }
    
    return self->_gradientLayer;
}


@end
