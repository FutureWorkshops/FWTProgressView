//
//  FWTProgressView.m
//  FWTProgressView
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTProgressView.h"

#define FWTPV_EXTRA_HEIGHT_DEFAULT     10.0f

NSString *const progressAnimationKey = @"progressAnimationKey";

@interface FWTProgressView ()
{
    UIImage *_patternImage;
    UIImage *_sliderImage;
    UIImage *_borderImage;
    
    CGFloat _progress;
    UIView *_backgroundContainerView;
    CAReplicatorLayer *_replicatorLayer;
    
    UIImageView *_sliderImageView;
    UIImageView *_borderImageView;
    BOOL _animationEnabled;
    CGFloat _extraHeight;
}

@property (nonatomic, retain) UIImage *patternImage, *sliderImage, *borderImage;

@property (nonatomic, retain) UIView *backgroundContainerView;
@property (nonatomic, retain) CAReplicatorLayer *replicatorLayer;
@property (nonatomic, retain) UIImageView *sliderImageView;
@property (nonatomic, retain) UIImageView *borderImageView;
@property (nonatomic, getter = isAnimationEnabled, assign) BOOL animationEnabled;
@property (nonatomic, assign) CGFloat extraHeight;
@end


@implementation FWTProgressView
@synthesize sliderImageView = _sliderImageView;
@synthesize progress = _progress;
@synthesize borderImageView = _borderImageView;
@synthesize animationEnabled = _animationEnabled;
@synthesize replicatorLayer = _replicatorLayer;

- (void)dealloc
{
    [self _unregisterFromApplicationNotifications];
    self.borderImageView = nil;
    self.sliderImageView = nil;
    self.replicatorLayer = nil;
    self.backgroundContainerView = nil;
    
    self.patternImage = nil;
    self.sliderImage = nil;
    self.borderImage = nil;
    
    [super dealloc];
}

- (id)init
{
    return [self initWithPatternImage:nil sliderImage:nil borderImage:nil];
}

- (id)initWithPatternImage:(UIImage *)patternImage sliderImage:(UIImage *)sliderImage borderImage:(UIImage *)borderImage
{
    return [self initWithPatternImage:patternImage sliderImage:sliderImage borderImage:borderImage extraHeight:FWTPV_EXTRA_HEIGHT_DEFAULT];
}

- (id)initWithPatternImage:(UIImage *)patternImage sliderImage:(UIImage *)sliderImage borderImage:(UIImage *)borderImage extraHeight:(CGFloat)extraHeight
{
    if ((self = [super init]))
    {
        self.patternImage = patternImage ? [self _flippedImage:patternImage] : [self _flippedImage:[FWTProgressView _patternImage]];  //  cg draws flipped
        self.sliderImage = sliderImage ? sliderImage : [FWTProgressView _sliderImage];
        self.borderImage = borderImage ? borderImage : [FWTProgressView _borderImage];
        
        self.patternImageAnimationEnabled = YES;
        self.extraHeight = extraHeight;
        self.frame = CGRectMake(.0f, .0f, 100.0f, self.patternImage.size.height+self.extraHeight);
        
        [self _registerToApplicationNotifications];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGRect previous = [[self valueForKey:@"frame"] CGRectValue];
    [super setFrame:frame];
    
    if (CGRectEqualToRect(frame, CGRectZero))
    {
        [self setAnimationEnabled:NO];
    }
    else if (!CGRectEqualToRect(previous, frame))
    {
        [self _configure];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.backgroundContainerView.superview)
        [self addSubview:self.backgroundContainerView];
    
    if (!self.replicatorLayer.superlayer)
        [self.backgroundContainerView.layer addSublayer:self.replicatorLayer];
    
    if (!self.sliderImageView.superview)
        [self.backgroundContainerView addSubview:self.sliderImageView];
    
    if (!self.borderImageView.superview)
        [self addSubview:self.borderImageView];
}

- (void)removeFromSuperview
{
    self.animationEnabled = NO;
    [super removeFromSuperview];
}

#pragma mark - Getters
- (UIView *)backgroundContainerView
{
    if (!self->_backgroundContainerView)
    {
        self->_backgroundContainerView = [[UIView alloc] init];
        self->_backgroundContainerView.clipsToBounds = YES;
    }
    
    return self->_backgroundContainerView;
}

- (CAReplicatorLayer *)replicatorLayer
{
    if (!self->_replicatorLayer)
        self->_replicatorLayer = [[CAReplicatorLayer alloc] init];
    
    return self->_replicatorLayer;
}

- (UIImageView *)sliderImageView
{
    if (!self->_sliderImageView)
    {
        self->_sliderImageView = [[UIImageView alloc] initWithImage:self.sliderImage];
        self->_sliderImageView.layer.anchorPoint = CGPointMake(1.0f, .5f);
    }
    
    return self->_sliderImageView;
}

- (UIImageView *)borderImageView
{
    if (!self->_borderImageView)
        self->_borderImageView = [[UIImageView alloc] initWithImage:self.borderImage];
    
    return self->_borderImageView;
}

- (void)setAnimationEnabled:(BOOL)enabled
{
    if (self->_animationEnabled != enabled && [self isPatternImageAnimationEnabled])
    {
        self->_animationEnabled = enabled;
        
        if (self->_animationEnabled && ![self.replicatorLayer animationForKey:progressAnimationKey])
        {
            CGFloat xValue = self.bounds.size.width*.5f;
            CGFloat yValue = self.replicatorLayer.position.y;
            CGFloat animationDuration = [self _animationDuration];
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.duration = animationDuration;
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(xValue, yValue)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-xValue, yValue)];
            animation.repeatCount = INFINITY;
            [self.replicatorLayer addAnimation:animation forKey:progressAnimationKey];
        }
        else if (!self->_animationEnabled && [self.replicatorLayer animationForKey:progressAnimationKey])
        {
            [self.replicatorLayer removeAnimationForKey:progressAnimationKey];
        }
    }
}

#pragma mark - Private
- (void)_registerToApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_applicationDidBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)_unregisterFromApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)_restoreAnimationWithProgress:(CGFloat)progress
{
    //
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.replicatorLayer.hidden = (progress) == .0f ? YES : NO;
    [CATransaction commit];
    
    //
    [self setAnimationEnabled:(progress == .0f) ? NO : YES];
}

- (void)_configure
{    
    CGFloat frameWidth = self.frame.size.width;
    
    //
    CGRect backgroundContainerFrame = self.bounds;
    backgroundContainerFrame.origin.y += (CGRectGetHeight(backgroundContainerFrame)-self.patternImage.size.height)*.5f;
    backgroundContainerFrame.size.height = self.patternImage.size.height;
    backgroundContainerFrame = CGRectInset(backgroundContainerFrame, 2.0f, .0f);
    backgroundContainerFrame = CGRectIntegral(backgroundContainerFrame);
    self.backgroundContainerView.frame = backgroundContainerFrame;
    self.backgroundContainerView.layer.cornerRadius = CGRectGetMidY(self.backgroundContainerView.bounds);
    
    //
    self.replicatorLayer.frame = CGRectMake(0, 0, CGRectGetWidth(backgroundContainerFrame), CGRectGetHeight(backgroundContainerFrame));
    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(frameWidth, 0., 0.);
    self.replicatorLayer.instanceCount = [self isPatternImageAnimationEnabled] ? 2 : 1;
    
    //
    NSArray *sublayers = [NSArray arrayWithArray:self.replicatorLayer.sublayers];
    [sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = CGRectMake(.0f, .0f, frameWidth, self.patternImage.size.height);
    //    subLayer.borderWidth = 1.0f;
    subLayer.backgroundColor = [[UIColor colorWithPatternImage:self.patternImage] CGColor];
    [self.replicatorLayer addSublayer:subLayer];
    
    //
    self.sliderImageView.frame = self.backgroundContainerView.bounds;
    CGRect bounds = self.backgroundContainerView.bounds;
    bounds.size.width *= (1.0f - self.progress);
    self.sliderImageView.bounds = bounds;
    
    //
    CGRect borderImageFrame = CGRectInset(self.bounds, .0f, 3.0f);
    self.borderImageView.frame = borderImageFrame;
    
    //
    [self _restoreAnimationWithProgress:self.progress];
}

- (UIImage *)_flippedImage:(UIImage *)sourceImage
{
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ctx, CGRectMake(.0f, .0f, size.width, size.height), sourceImage.CGImage);
    UIImage *toReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return toReturn;
}

- (CGFloat)_animationDuration
{
    CGFloat constant = .027f;
    CGFloat toReturn = constant*CGRectGetWidth(self.bounds);
    return toReturn;
}

#pragma mark - Application notifications
- (void)_applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    self.animationEnabled = NO;
}

- (void)_applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self _restoreAnimationWithProgress:self.progress];
}

#pragma mark - Public
- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (self->_progress != progress)
    {
        self->_progress = progress;
        
        void (^updateProgressImageBounds)() = ^{
            CGRect bounds = self.backgroundContainerView.bounds;
            bounds.size.width *= (1.0f - self->_progress);
            self.sliderImageView.bounds = bounds;
        };
        
        //
        [self _restoreAnimationWithProgress:self->_progress];
        
        //
        if (animated)
            [UIView animateWithDuration:.25f animations:updateProgressImageBounds];
        else
            updateProgressImageBounds();
    }
}

+ (id)defaultProgressView
{
    return [[[FWTProgressView alloc] init] autorelease];
}

#pragma mark - 
+ (UIImage *)_patternImage
{
    CGFloat baseWidth = 11.0f;
    CGFloat baseHeight = 18.0f;
    CGFloat spaceBetween = 9.0f;
    CGFloat period = baseWidth+spaceBetween;
    
    CGSize size = CGSizeMake(period, baseHeight);
    CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.31f green:.72f blue:.25f alpha:1.0f].CGColor);
    CGContextFillRect(ctx, ctxRect);
    
    //
    UIBezierPath *bp = [UIBezierPath bezierPath];
    [bp moveToPoint:CGPointMake(.0f, baseHeight)];
    [bp addLineToPoint:CGPointMake(16.0f, .0f)];
    [bp addLineToPoint:CGPointMake(16.0f+baseWidth, .0f)];
    [bp addLineToPoint:CGPointMake(baseWidth, baseHeight)];
    [bp closePath];
    
    //
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.20f green:.56f blue:.13f alpha:1.0f].CGColor);
    CGContextAddPath(ctx, bp.CGPath);
    CGContextFillPath(ctx);
    
    //
    CGContextTranslateCTM(ctx, -period, .0f);
    CGContextAddPath(ctx, bp.CGPath);
    CGContextFillPath(ctx);
    
    //
    CGContextTranslateCTM(ctx, period, .0f);
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] colorWithAlphaComponent:.125f].CGColor);
    CGContextFillRect(ctx, CGRectOffset(ctxRect, .0f, 1.0f));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)_sliderImage
{
    CGSize size = CGSizeMake(6.0f, 18.0f);
    CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.25f green:.25f blue:.26f alpha:1.0f].CGColor);
    CGContextFillRect(ctx, ctxRect);
    
    UIColor *startColor = [UIColor colorWithRed:.24f green:.24f blue:.24f alpha:1.0f];
    UIColor *endColor = [UIColor colorWithRed:.25f green:.25f blue:.26f alpha:1.0f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.f, 1.f};
    const void *colors[2] = {startColor.CGColor, endColor.CGColor};
    CFArrayRef gradientColors = CFArrayCreate(NULL, colors, 2, NULL);
    CGGradientRef _gradientRef = CGGradientCreateWithColors(colorSpace, gradientColors, locations);
    CGColorSpaceRelease(colorSpace);
    CFRelease(gradientColors);
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(4.0f, .0f);
    CGContextDrawLinearGradient(ctx, _gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(_gradientRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(.0f, 4.0f, .0f, 1.0f)];
}

+ (UIImage *)_borderImage
{
    CGFloat cornerRadius = 8.0f;
    CGFloat emptyBorder = 2.0f;
    CGFloat tiledArea = 1.0f;
    CGColorRef colorRef = [UIColor colorWithRed:.17f green:.17f blue:.18f alpha:1.0f].CGColor;
    CGColorRef shadowColorRef = [[UIColor whiteColor] colorWithAlphaComponent:.5f].CGColor;
    CGSize shadowOffset = CGSizeMake(.0f, .75f);
    CGFloat shadowBlur = 1.0f;
    
    //
    CGSize size = CGSizeMake(cornerRadius*2+emptyBorder*2+tiledArea, cornerRadius*2+emptyBorder*2+tiledArea);
    CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
    CGRect availableRect = CGRectInset(ctxRect, emptyBorder, emptyBorder);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, colorRef);
    CGContextSetFillColorWithColor(ctx, colorRef);
    UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:availableRect cornerRadius:cornerRadius];
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, shadowOffset, shadowBlur, shadowColorRef);
    [bp fill];
    [bp addClip];
    [[UIColor clearColor] setFill];
    UIRectFill(CGContextGetClipBoundingBox(ctx));
    CGContextRestoreGState(ctx);
    [bp stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //
    CGFloat cap = cornerRadius+emptyBorder;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(cap, cap, cap, cap)];
    return image;
}
@end

