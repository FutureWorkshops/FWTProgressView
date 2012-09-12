//
//  FWTProgressView.h
//  FWTProgressView
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

enum _FWTProgressViewAnimationType
{
    FWTProgressViewAnimationTypeNone,
    FWTProgressViewAnimationTypeFromRightToLeft,   
    FWTProgressViewAnimationTypeFromLeftToRight,    // default
};
typedef NSUInteger FWTProgressViewAnimationType;

@interface FWTProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) FWTProgressViewAnimationType animationType;

- (id)initWithProgressImage:(UIImage *)progressImage
                 trackImage:(UIImage *)trackImage
                borderImage:(UIImage *)borderImage;

- (id)initWithProgressImage:(UIImage *)progressImage
                 trackImage:(UIImage *)trackImage
                borderImage:(UIImage *)borderImage
                extraHeight:(CGFloat)extraHeight
       backgroundEdgeInsets:(UIEdgeInsets)backgroundEdgeInsets
           borderEdgeInsets:(UIEdgeInsets)borderEdgeInsets;

- (void)setProgress:(float)progress animated:(BOOL)animated;

+ (id)defaultProgressView;

@end
