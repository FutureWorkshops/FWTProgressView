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
@property (nonatomic, getter = isProgressImageAnimationEnabled, assign) BOOL progressImageAnimationEnabled;  //  default is YES

- (id)initWithProgressImage:(UIImage *)progressImage trackImage:(UIImage *)trackImage borderImage:(UIImage *)borderImage;
- (id)initWithProgressImage:(UIImage *)progressImage trackImage:(UIImage *)trackImage borderImage:(UIImage *)borderImage extraHeight:(CGFloat)extraHeight;

- (void)setProgress:(float)progress animated:(BOOL)animated;

+ (id)defaultProgressView;

@end
