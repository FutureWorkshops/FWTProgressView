//
//  Factory.h
//  FWTProgressView_Test
//
//  Created by Marco Meschini on 13/09/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWTProgressView.h"

@interface Factory : NSObject

+ (FWTProgressView *)progressViewWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)progressViewDictionariesArray;

@end
