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

extern NSTimeInterval const FWTProgressViewAnimationDuration;   // default is 1.0s

@interface FWTProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) FWTProgressViewAnimationType animationType;
@property (nonatomic, assign) NSTimeInterval animationDuration; 
@property (nonatomic, assign) CGFloat contentHorizontalInset;
@property (nonatomic, assign) CGFloat contentCornerRadius;
@property (nonatomic, assign) UIEdgeInsets borderEdgeInsets;

- (id)initWithProgressImage:(UIImage *)progressImage
                 trackImage:(UIImage *)trackImage
                borderImage:(UIImage *)borderImage;

- (void)setProgress:(float)progress animated:(BOOL)animated;

+ (id)defaultProgressView;

@end
