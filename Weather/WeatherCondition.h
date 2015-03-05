//
//  WeatherCondition.h
//  Weather
//
//  Created by Sun on 15/2/2.
//  Copyright (c) 2015年 Sun. All rights reserved.
//
@import UIKit;

#import "MTLModel.h"

#import <Mantle.h>

@interface WeatherCondition : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSNumber *humidity;

@property (nonatomic, strong) NSNumber *temperature;

@property (nonatomic, strong) NSNumber *tempHigh;

@property (nonatomic, strong) NSNumber *tempLow;

@property (nonatomic, strong) NSString *locationName;

@property (nonatomic, strong) NSDate *sunrise;

@property (nonatomic, strong) NSDate *sunset;

@property (nonatomic, strong) NSString *conditionDescription;

@property (nonatomic, strong) NSString *condition;

@property (nonatomic, strong) NSNumber *windBearing;

@property (nonatomic, strong) NSNumber *windSpeed;

@property (nonatomic, strong) NSString *icon;


- (NSString *)imageName;

-(UIColor*)temperatureColor;

@end
