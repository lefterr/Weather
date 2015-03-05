//
//  WeatherManager.h
//  Weather
//
//  Created by Sun on 15/1/29.
//  Copyright (c) 2015年 Sun. All rights reserved.
//

@import CoreLocation;

#import <Foundation/Foundation.h>

#import "ReactiveCocoa/ReactiveCocoa.h"

#import "WeatherCondition.h"

@interface WeatherManager : NSObject<CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

@property (nonatomic, strong, readonly) WeatherCondition *currentCondition;

@property (nonatomic, strong, readonly) NSArray *hourlyForecast;

@property (nonatomic, strong, readonly) NSArray *dailyForecast;

@property (nonatomic, strong, readonly) NSString *backgroundImage;

- (void)findCurrentLocation;

- (RACSignal *)updateCurrentConditions;

- (RACSignal *)updateHourlyForecast;

- (RACSignal *)updateDailyForecast;
@end
