//
//  FWTProgressView.h
//  FWTProgressView
//
//  Created by Marco Meschini on 06/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWTProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, getter = isPatternImageAnimationEnabled, assign) BOOL patternImageAnimationEnabled;  //  default is YES

- (id)initWithPatternImage:(UIImage *)patternImage sliderImage:(UIImage *)sliderImage borderImage:(UIImage *)borderImage;
- (id)initWithPatternImage:(UIImage *)patternImage sliderImage:(UIImage *)sliderImage borderImage:(UIImage *)borderImage extraHeight:(CGFloat)extraHeight;

- (void)setProgress:(float)progress animated:(BOOL)animated;

+ (id)defaultProgressView;

@end
