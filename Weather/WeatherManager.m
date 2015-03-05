//
//  WeatherManager.m
//  Weather
//
//  Created by Sun on 15/1/29.
//  Copyright (c) 2015年 Sun. All rights reserved.
//

#import "WeatherManager.h"

#import "WeatherClient.h"

#import <TSMessages/TSMessage.h>

@interface WeatherManager()

@property (nonatomic, strong, readwrite) WeatherCondition *currentCondition;

@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@property (nonatomic, strong, readwrite) NSArray *hourlyForecast;

@property (nonatomic, strong, readwrite) NSArray *dailyForecast;

@property (nonatomic, strong, readwrite) NSString *backgroundImage;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL isFirstUpdate;

@property (nonatomic, strong) WeatherClient *client;


@end

@implementation WeatherManager

+ (instancetype)sharedManager {
    
    static id _sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {

    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
   
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        
        [self.locationManager requestAlwaysAuthorization];
        
        [self.locationManager requestWhenInUseAuthorization];
            
        }
        
        [self.locationManager startUpdatingLocation];
    
        _client = [[WeatherClient alloc] init];
        
        [[[[RACObserve(self, currentLocation) ignore:nil]
           
           // Flatten and subscribe to all 3 signals when currentLocation updates
           
           flattenMap:^(CLLocation *newLocation) {
               
               return [RACSignal merge:@[
                                         [self updateCurrentConditions],
                                         
                                         [self updateDailyForecast],
                                         
                                         [self updateHourlyForecast]
                                         
                                         ]];
               
           }] deliverOn:RACScheduler.mainThreadScheduler]
         
         subscribeError:^(NSError *error) {
             
             [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching the latest weather." type:TSMessageNotificationTypeError];
             
         }];
        
    }
    
    return self;
    
}

- (void)findCurrentLocation {
    
    self.isFirstUpdate = YES;
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [_locationManager startUpdatingLocation];

    } else if (status == kCLAuthorizationStatusAuthorized) {
        
        
        [_locationManager startUpdatingLocation];
        
    } else if (status > kCLAuthorizationStatusNotDetermined) {
        
        
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy > 0) {
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
    }
}


- (RACSignal *)updateCurrentConditions {
    
    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate] doNext:^(WeatherCondition *condition) {
        
        self.currentCondition = condition;
        
    }];
    
}

- (RACSignal *)updateHourlyForecast {
    
    return [[self.client fetchHourlyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        
        self.hourlyForecast = conditions;
        
    }];
}

- (RACSignal *)updateDailyForecast {
    
    return [[self.client fetchDailyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        
        self.dailyForecast = conditions;
        
    }];
 
}

@end
