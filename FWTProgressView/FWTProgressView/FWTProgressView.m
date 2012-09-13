//
//  FWTProgressView.m
//  FWTProgressView
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FWTProgressView.h"

#define FWTPV_EXTRA_HEIGHT_DEFAULT          10.0f
#define FWTPV_BACKGROUND_EDGE_INSETS        UIEdgeInsetsMake(.0f, 2.0f, .0f, 2.0f)
#define FWTPV_BORDER_EDGE_INSETS            UIEdgeInsetsMake(3.0f, .0f, 3.0f, .0f)

#define FWTPV_ANIMATION_DURATION            1.0f

NSString *const keyProgressAnimation = @"keyProgressAnimation";

@interface FWTProgressView ()
{
    UIImage *_progressImage;
    UIImage *_trackImage;
    UIImage *_borderImage;
    
    CGFloat _progress;
    UIView *_contentView;
    CALayer *_progressLayer;
    
    UIImageView *_trackImageView;
    UIImageView *_borderImageView;
    
    BOOL _animationEnabled;
    CGFloat _extraHeight;
}

@property (nonatomic, retain) UIImage *progressImage, *trackImage, *borderImage;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) CALayer *progressLayer;
@property (nonatomic, retain) UIImageView *trackImageView;
@property (nonatomic, retain) UIImageView *borderImageView;
@property (nonatomic, getter = isAnimationEnabled, assign) BOOL animationEnabled;
@property (nonatomic, assign) CGFloat extraHeight;
@property (nonatomic, assign) UIEdgeInsets backgroundEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets borderEdgeInsets;
@end


@implementation FWTProgressView
@synthesize trackImageView = _trackImageView;
@synthesize borderImageView = _borderImageView;

@synthesize progress = _progress;
@synthesize animationEnabled = _animationEnabled;

@synthesize progressLayer = _progressLayer;
@synthesize contentView = _contentView;

#pragma mark - Overrides
- (void)dealloc
{
    [self _unregisterFromApplicationNotifications];
    
    self.borderImageView = nil;
    self.trackImageView = nil;
    
    self.progressLayer = nil;
    self.contentView = nil;
    
    self.progressImage = nil;
    self.trackImage = nil;
    self.borderImage = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [self initWithProgressImage:nil trackImage:nil borderImage:nil]))
    {
        self.frame = frame;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGRect previous = [[self valueForKey:@"frame"] CGRectValue];
    frame.size.height = self.progressImage.size.height + self.extraHeight;
    [super setFrame:frame];
    
    if (CGRectEqualToRect(frame, CGRectZero))
    {
        [self setAnimationEnabled:NO];
    }
    else if (!CGSizeEqualToSize(previous.size, frame.size))
    {
        [self setAnimationEnabled:NO];
        [self _configure];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.contentView.superview)
        [self addSubview:self.contentView];
    
    if (!self.progressLayer.superlayer)
        [self.contentView.layer addSublayer:self.progressLayer];

    if (!self.trackImageView.superview)
        [self.contentView addSubview:self.trackImageView];
    
    if (!self.borderImageView.superview)
        [self addSubview:self.borderImageView];
}

- (void)removeFromSuperview
{
    self.animationEnabled = NO;
    [super removeFromSuperview];
}

#pragma mark - Getters
- (UIView *)contentView
{
    if (!self->_contentView)
    {
        self->_contentView = [[UIView alloc] init];
        self->_contentView.clipsToBounds = YES;
    }
    
    return self->_contentView;
}

- (CALayer *)progressLayer
{
    if (!self->_progressLayer)
        self->_progressLayer = [[CALayer alloc] init];
    
    return self->_progressLayer;
}

- (UIImageView *)trackImageView
{
    if (!self->_trackImageView)
    {
        self->_trackImageView = [[UIImageView alloc] initWithImage:self.trackImage];
        self->_trackImageView.layer.anchorPoint = CGPointMake(1.0f, .5f);
    }
    
    return self->_trackImageView;
}

- (UIImageView *)borderImageView
{
    if (!self->_borderImageView)
        self->_borderImageView = [[UIImageView alloc] initWithImage:self.borderImage];
    
    return self->_borderImageView;
}

- (void)setAnimationEnabled:(BOOL)enabled
{
    if (self->_animationEnabled != enabled && [self _isProgressImageAnimationEnabled])
    {
        self->_animationEnabled = enabled;
        
        if (self->_animationEnabled && ![self.progressLayer animationForKey:keyProgressAnimation])
        {
            [self.progressLayer addAnimation:[self _animation] forKey:keyProgressAnimation];
        }
        else if (!self->_animationEnabled && [self.progressLayer animationForKey:keyProgressAnimation])
        {            
            [self.progressLayer removeAnimationForKey:keyProgressAnimation];
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
    //  if progress is zero then hide replicator layer
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.progressLayer.hidden = (progress) == .0f ? YES : NO;
    [CATransaction commit];
    
    //
    [self setAnimationEnabled:(progress == .0f) ? NO : YES];
}

- (void)_configure
{
    //  if the width is still zero, hide the border and do nothing
    if (CGRectGetWidth(self.frame) <= .0f)
    {
        self.borderImageView.frame = CGRectZero;
        return;
    }
    
    //
    CGSize progressImageSize = self.progressImage.size;
    
    //  container frame and cornerRadius
    CGRect backgroundContainerFrame = UIEdgeInsetsInsetRect(self.bounds, self.backgroundEdgeInsets);
    backgroundContainerFrame.origin.y += (CGRectGetHeight(backgroundContainerFrame)-progressImageSize.height)*.5f;
    backgroundContainerFrame.size.height = progressImageSize.height;
    backgroundContainerFrame = CGRectIntegral(backgroundContainerFrame);
    self.contentView.frame = backgroundContainerFrame;
    self.contentView.layer.cornerRadius = CGRectGetMidY(self.contentView.bounds);
    
    //  adjust width
    CGRect adjustedProgressLayerFrame = self.contentView.bounds;
    CGFloat module = fmodf(CGRectGetWidth(adjustedProgressLayerFrame), progressImageSize.width);
    if (module != .0f) adjustedProgressLayerFrame.size.width += progressImageSize.width - module;
    CGRect progressLayerFrame = adjustedProgressLayerFrame;
    if ([self _isProgressImageAnimationEnabled])
    {
        progressLayerFrame.size.width += progressImageSize.width;
        progressLayerFrame = CGRectOffset(progressLayerFrame, (self.animationType != FWTProgressViewAnimationTypeFromRightToLeft) ? -progressImageSize.width : .0f, .0f);
    }
        
    //  progressLayer
    self.progressLayer.frame = progressLayerFrame;
    self.progressLayer.backgroundColor = [[UIColor colorWithPatternImage:self.progressImage] CGColor];
    
    //  track frame - bounds reflect the progress
    self.trackImageView.frame = self.contentView.bounds;
    self.trackImageView.bounds = [self _trackBoundsForProgress:self.progress];
    
    //  border
    self.borderImageView.frame = UIEdgeInsetsInsetRect(self.bounds, self.borderEdgeInsets);
    
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

- (CGRect)_trackBoundsForProgress:(CGFloat)progress
{
    CGRect toReturn = self.contentView.bounds;
    toReturn.size.width *= (1.0f - progress);
    return toReturn;
}

- (BOOL)_isProgressImageAnimationEnabled
{
    return self.animationType != FWTProgressViewAnimationTypeNone;
}

- (CABasicAnimation *)_animation
{
    CGPoint fromPoint = self.progressLayer.position;
    CGPoint toPoint = fromPoint;
    if (self.animationType == FWTProgressViewAnimationTypeFromRightToLeft)
        toPoint.x -= self.progressImage.size.width;
    else
        toPoint.x += self.progressImage.size.width;
    
    NSLog(@"from:%@, to:%@", NSStringFromCGPoint(fromPoint), NSStringFromCGPoint(toPoint));
    
    CABasicAnimation *toReturn = [CABasicAnimation animationWithKeyPath:@"position"];
    toReturn.duration = self.animationDuration;
    toReturn.fromValue = [NSValue valueWithCGPoint:fromPoint];
    toReturn.toValue = [NSValue valueWithCGPoint:toPoint];
    toReturn.repeatCount = INFINITY;
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
- (id)initWithProgressImage:(UIImage *)progressImage trackImage:(UIImage *)trackImage borderImage:(UIImage *)borderImage
{
    return [self initWithProgressImage:progressImage
                            trackImage:trackImage
                           borderImage:borderImage
                           extraHeight:FWTPV_EXTRA_HEIGHT_DEFAULT
                  backgroundEdgeInsets:FWTPV_BACKGROUND_EDGE_INSETS
                      borderEdgeInsets:FWTPV_BORDER_EDGE_INSETS];
}

- (id)initWithProgressImage:(UIImage *)progressImage
                 trackImage:(UIImage *)trackImage
                borderImage:(UIImage *)borderImage
                extraHeight:(CGFloat)extraHeight
       backgroundEdgeInsets:(UIEdgeInsets)backgroundEdgeInsets
           borderEdgeInsets:(UIEdgeInsets)borderEdgeInsets
{
    if ((self = [super initWithFrame:CGRectZero]))
    {
        self.progressImage = progressImage ? [self _flippedImage:progressImage] : [self _flippedImage:[FWTProgressView _progressImage]];  //  cg draws flipped
        self.trackImage = trackImage ? trackImage : [FWTProgressView _trackImage];
        self.borderImage = borderImage ? borderImage : [FWTProgressView _borderImage];
        self.extraHeight = extraHeight;
        self.backgroundEdgeInsets = backgroundEdgeInsets;
        self.borderEdgeInsets = borderEdgeInsets;
        self.animationType = FWTProgressViewAnimationTypeFromLeftToRight;
        self.animationDuration = FWTPV_ANIMATION_DURATION;
        
        self.frame = CGRectMake(.0f, .0f, .0f, self.progressImage.size.height + self.extraHeight);
        
        [self _registerToApplicationNotifications];
    }
    
    return self;
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (self->_progress != progress)
    {
        self->_progress = progress;
                
        //
        [self _restoreAnimationWithProgress:self->_progress];
        
        //
        if (animated)
            [UIView animateWithDuration:.25f animations:^{ self.trackImageView.bounds = [self _trackBoundsForProgress:self->_progress]; }];
        else
            self.trackImageView.bounds = [self _trackBoundsForProgress:self->_progress];
    }
}

+ (id)defaultProgressView
{
    return [[[FWTProgressView alloc] init] autorelease];
}

#pragma mark - UIImage
+ (UIImage *)_progressImage
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

+ (UIImage *)_trackImage
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

