//
//  Factory.m
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 13/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "Factory.h"
#import "UIImage+Sample.h"

NSString *const kClassName  = @"kClass";
NSString *const kPattern    = @"kPattern";
NSString *const kSlider     = @"kSlider";
NSString *const kBorder     = @"kBorder";
NSString *const kAnim       = @"kAnim";

@implementation Factory

+ (FWTProgressView *)progressViewWithDictionary:(NSDictionary *)dictionary
{
    id pattern = [dictionary valueForKey:kPattern];
    id slider  = [dictionary valueForKey:kSlider];
    id border  = [dictionary valueForKey:kBorder];
    id anim    = [dictionary valueForKey:kAnim];
    NSString *className = [dictionary valueForKey:kClassName];
    if (!className)
        className = NSStringFromClass([FWTProgressView class]);
    
    FWTProgressView *toReturn = [[[NSClassFromString(className) alloc] initWithProgressImage:pattern ? pattern : nil
                                                                                  trackImage:slider ? slider : nil
                                                                                 borderImage:border ? border : nil] autorelease];
    
    if (anim) toReturn.animationType = [anim integerValue];

    toReturn.frame = CGRectInset(toReturn.frame, .0f, -5.0f);
    toReturn.contentHorizontalInset = 2.0f;
    toReturn.contentCornerRadius = 9.0f;
    toReturn.borderEdgeInsets = UIEdgeInsetsMake(3.0f, .0f, 3.0f, .0f);
    
    return toReturn;
}

+ (NSArray *)progressViewDictionariesArray
{
    NSArray *toReturn =
    @[
    
    // the default one
    //
    @{},
    
    // yellow-black stripes
    //
    @{kPattern : [UIImage warning_progressImage], kAnim : [NSNumber numberWithInt:FWTProgressViewAnimationTypeFromRightToLeft]},
    
    // barber
    //
    @{kPattern : [UIImage barberShop_progressImage], kSlider : [UIImage barberShop_trackImage], kBorder : [UIImage barberShop_borderImage]},
    
    // a static gradient
    //
    @{kPattern : [UIImage blueGradient_progressImage], kAnim : [NSNumber numberWithInt:FWTProgressViewAnimationTypeNone]},
    
    // a waste of time
    //
    @{kPattern : [UIImage iLikeTheWaves_progressImage], kAnim : [NSNumber numberWithInt:FWTProgressViewAnimationTypeFromRightToLeft]},
    
    //
    @{kPattern : [UIImage arrow_progressImage], kAnim : [NSNumber numberWithInt:FWTProgressViewAnimationTypeFromRightToLeft], kClassName : @"CustomProgressView"},
     
    ];

    return toReturn;
}

@end
