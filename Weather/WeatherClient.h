//
//  WeatherClient.h
//  Weather
//
//  Created by Sun on 15/1/29.
//  Copyright (c) 2015年 Sun. All rights reserved.
//
@import CoreLocation;

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface WeatherClient : NSObject <NSXMLParserDelegate>

- (RACSignal *)fetchJSONFromURL:(NSURL *)url;

- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;

- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;

- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;

@end
