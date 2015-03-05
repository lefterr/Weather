//
//  WeatherDailyForecast.m
//  Weather
//
//  Created by Sun on 15/1/28.
//  Copyright (c) 2015年 Sun. All rights reserved.
//

#import "WeatherDailyForecast.h"


@implementation WeatherDailyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    
    paths[@"tempHigh"] = @"temp.max";
    
    paths[@"tempLow"] = @"temp.min";

    return paths;
}

@end
