//
//  UIImage+Sample.m
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "UIImage+Sample.h"

@implementation UIImage (Sample)

+ (UIImage *)warning_progressImage
{
    CGFloat baseWidth = 12.0f;
    CGFloat baseHeight = 18.0f;
    CGFloat spaceBetween = 8.0f;
    CGFloat period = baseWidth+spaceBetween;
    
    CGSize size = CGSizeMake(period, baseHeight);
    CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor yellowColor] setFill];
    UIRectFill(ctxRect);
    
    UIBezierPath *bp1 = [UIBezierPath bezierPath];
    [bp1 moveToPoint:CGPointMake(.0f, baseHeight)];
    [bp1 addLineToPoint:CGPointMake(16.0f, .0f)];
    [bp1 addLineToPoint:CGPointMake(16.0f+baseWidth, .0f)];
    [bp1 addLineToPoint:CGPointMake(baseWidth, baseHeight)];
    [bp1 closePath];
    
    [[UIColor blackColor] setFill];
    [bp1 fill];
    
    CGContextTranslateCTM(ctx, -period, .0f);
    [bp1 fill];
    
    CGContextTranslateCTM(ctx, period, .0f);
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] colorWithAlphaComponent:.2f].CGColor);
    CGContextFillRect(ctx, CGRectMake(.0f, baseHeight-1.0f, period, 1.0f));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)barberShop_progressImage
{
    CGFloat baseWidth = 12.0f;
    CGFloat baseHeight = 18.0f;
    CGFloat spaceBetween = 8.0f;
    CGFloat period = baseWidth+spaceBetween;
    
    CGSize size = CGSizeMake(period, baseHeight);
    CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
    UIRectFill(ctxRect);
    
    UIBezierPath *bp1 = [UIBezierPath bezierPath];
    [bp1 moveToPoint:CGPointMake(.0f, baseHeight)];
    [bp1 addLineToPoint:CGPointMake(16.0f, .0f)];
    [bp1 addLineToPoint:CGPointMake(16.0f+baseWidth, .0f)];
    [bp1 addLineToPoint:CGPointMake(baseWidth, baseHeight)];
    [bp1 closePath];
    
    [[UIColor redColor] setFill];
    [bp1 fill];
    
    CGContextTranslateCTM(ctx, -period, .0f);
    [bp1 fill];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)barberShop_trackImage
{
    CGSize size = CGSizeMake(6.0f, 18.0f);
    CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:.0f green:.37f blue:.62f alpha:1.0f].CGColor);
    CGContextFillRect(ctx, ctxRect);
    
    UIColor *startColor = [UIColor colorWithRed:.0f green:.32f blue:.57f alpha:1.0f];
    UIColor *endColor = [UIColor colorWithRed:.0f green:.37f blue:.62f alpha:1.0f];
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

+ (UIImage *)barberShop_borderImage
{
    CGFloat cornerRadius = 8.0f;
    CGFloat emptyBorder = 2.0f;
    CGFloat tiledArea = 1.0f;
    CGColorRef colorRef = [UIColor colorWithRed:1.0f green:.3f blue:.3f alpha:1.0f].CGColor;
    CGColorRef shadowColorRef = [[UIColor blackColor] colorWithAlphaComponent:.5f].CGColor;
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
    CGContextSetShadowWithColor(ctx, CGSizeMake(.0f, .0f), 2.f, shadowColorRef);
    [bp stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //
    CGFloat cap = cornerRadius+emptyBorder;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(cap, cap, cap, cap)];
    return image;
}

+ (UIImage *)blueGradient_progressImage
{
    CGSize size = CGSizeMake(1.0f, 18.0f);
    CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextFillRect(ctx, ctxRect);
    
    UIColor *startColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    UIColor *endColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:.3f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.f, 1.f};
    const void *colors[2] = {startColor.CGColor, endColor.CGColor};
    CFArrayRef gradientColors = CFArrayCreate(NULL, colors, 2, NULL);
    CGGradientRef _gradientRef = CGGradientCreateWithColors(colorSpace, gradientColors, locations);
    CGColorSpaceRelease(colorSpace);
    CFRelease(gradientColors);
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(.0f, size.height);
    CGContextDrawLinearGradient(ctx, _gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(_gradientRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)iLikeTheWaves_progressImage
{
    void (^drawGradient)(CGContextRef, CGColorRef, CGColorRef) = ^(CGContextRef ctx, CGColorRef colorA, CGColorRef colorB){
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[2] = {0.f, 1.f};
        const void *colors[2] = {colorA, colorB};
        CFArrayRef gradientColors = CFArrayCreate(NULL, colors, 2, NULL);
        CGGradientRef _gradientRef = CGGradientCreateWithColors(colorSpace, gradientColors, locations);
        CGColorSpaceRelease(colorSpace);
        CFRelease(gradientColors);
        CGPoint startPoint = CGPointZero;
        CGPoint endPoint = CGPointMake(.0f, CGContextGetClipBoundingBox(ctx).size.height);
        CGContextDrawLinearGradient(ctx, _gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
        CGGradientRelease(_gradientRef);
    };
    
    CGFloat baseWidth = 11.0f;
    CGFloat baseHeight = 18.0f;
    CGFloat spaceBetween = 9.0f;
    CGFloat period = baseWidth+spaceBetween;
    
    CGSize size = CGSizeMake(period, baseHeight);
    CGRect ctxRect = CGRectMake(.0f, .0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, ctxRect);
    drawGradient(ctx, [UIColor colorWithWhite:.8f alpha:1.0f].CGColor, [UIColor colorWithWhite:.9f alpha:.2f].CGColor);
    
    CGFloat y = 7;
    
    //
    UIBezierPath *bp = [UIBezierPath bezierPath];
    [bp moveToPoint:CGPointMake(.0f, y)];
    [bp addLineToPoint:CGPointMake(2.0f, y)];
    [bp addQuadCurveToPoint:CGPointMake(6.0f, 13.0f) controlPoint:CGPointMake(6, y)];
    [bp addQuadCurveToPoint:CGPointMake(10.0f,17.0f) controlPoint:CGPointMake(6, 17)];
    [bp addQuadCurveToPoint:CGPointMake(14, 13) controlPoint:CGPointMake(14, 17)];
    [bp addQuadCurveToPoint:CGPointMake(18, y) controlPoint:CGPointMake(14, y)];
    [bp addLineToPoint:CGPointMake(20, y)];
    [bp addLineToPoint:CGPointMake(20, baseHeight)];
    [bp addLineToPoint:CGPointMake(.0f, baseHeight)];
    [bp addLineToPoint:CGPointMake(.0f, y)];
    [bp closePath];
    
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(.0f, 1.0f), 2.0f, [UIColor blackColor].CGColor);
    [[UIColor blueColor] setStroke];
    [bp stroke];
    [[UIColor blueColor] setFill];
    [bp fill];
    CGContextRestoreGState(ctx);
    
    [bp addClip];
    drawGradient(ctx, [UIColor colorWithWhite:1.0f alpha:1.0f].CGColor, [UIColor colorWithWhite:1.0f alpha:.2f].CGColor);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)arrow_progressImage
{
    CGSize size = CGSizeMake(30, 18);
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *startColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    UIColor *endColor = [[UIColor blackColor] colorWithAlphaComponent:.2f];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.f, 1.f};
    const void *colors[3] = {startColor.CGColor, endColor.CGColor, startColor.CGColor};
    CFArrayRef gradientColors = CFArrayCreate(NULL, colors, 3, NULL);
    CGGradientRef _gradientRef = CGGradientCreateWithColors(colorSpace, gradientColors, locations);
    CGColorSpaceRelease(colorSpace);
    CFRelease(gradientColors);
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(.0f, size.height);
    CGContextDrawLinearGradient(ctx, _gradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    CGGradientRelease(_gradientRef);
    
    UIBezierPath *bp1 = [UIBezierPath bezierPath];
    [bp1 moveToPoint:CGPointMake(.0f, 9.0f)];
    [bp1 addLineToPoint:CGPointMake(15.0f, .0f)];
    [bp1 addLineToPoint:CGPointMake(30.0f, .0f)];
    [bp1 addLineToPoint:CGPointMake(15.0f, 9.0f)];
    [bp1 addLineToPoint:CGPointMake(30.0f, 18.0f)];
    [bp1 addLineToPoint:CGPointMake(15.0f, 18.0f)];
    [bp1 closePath];
    
    [[UIColor blackColor] setFill];
    [bp1 fill];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
