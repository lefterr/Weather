//
//  ViewController.m
//  Weather
//
//  Created by Sun on 15/1/27.
//  Copyright (c) 2015年 Sun. All rights reserved.
//

#import "ViewController.h"

#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

#import "WeatherManager.h"

#import "WeatherCondition.h"

#import "UIScrollView+RefreshControl.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *blurredImageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;

@property (nonatomic, strong) NSDateFormatter *dailyFormatter;

@end

@implementation ViewController

- (id)init {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (self = [super init]) {
        self.hourlyFormatter = [[NSDateFormatter alloc] init];
        
        self.hourlyFormatter.dateFormat = @"h a";
        
        self.dailyFormatter = [[NSDateFormatter alloc] init];
        
        self.dailyFormatter.dateFormat = @"EEEE";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [super viewDidLoad];
    
    //Get and store the screen height
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIImage *background = [UIImage imageNamed:@"bg"];
    
    // Create a static image background and add it to the view
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:self.backgroundImageView];
  
    //create blurredImageView
    self.blurredImageView = [[UIImageView alloc] init];
    
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.blurredImageView.alpha = 0;
    
    [self.view addSubview:self.blurredImageView];
    
    //create tableView
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.pagingEnabled = YES;
    
    [self.view addSubview:self.tableView];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //缩放
    CGAffineTransform scaleZero = CGAffineTransformMakeScale(0, 0);
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    
    //间距
    CGFloat inset = 20;
    
    
    CGFloat circleSize = 200;
    
    //温度lable高度
    CGFloat temperatureHeight = 60;
    
    //高低温度
    CGFloat hiLoTemperatureSize = 42;
    
    //天气情况
    CGFloat conditionHeight = 30;
    
    CGRect circleFrame = CGRectMake((headerFrame.size.width - circleSize) / 2,
                                    (headerFrame.size.height - circleSize) / 2,
                                    circleSize,
                                    circleSize);
    //温度文本框
    CGRect temperatureFrame = CGRectMake(0,
                                         (circleFrame.size.height - temperatureHeight) / 2,
                                         circleSize,
                                         temperatureHeight);
    //天气文本框
    CGRect conditionsFrame = CGRectMake(0,
                                        temperatureFrame.origin.y - conditionHeight - 15,
                                        circleSize,
                                        conditionHeight);
    //高低温度文本框
    CGRect hiFrame = CGRectMake(hiLoTemperatureSize / 4,
                                circleSize - hiLoTemperatureSize - (hiLoTemperatureSize / 4),
                                hiLoTemperatureSize,
                                hiLoTemperatureSize);
    
    CGRect loFrame = hiFrame;
    
    
    
    loFrame.origin.x = circleSize - hiLoTemperatureSize - (hiLoTemperatureSize / 4);
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    
    header.backgroundColor = [UIColor clearColor];
    
    
    self.tableView.tableHeaderView = header;
    
    self.circleView = [[UIView alloc] initWithFrame:circleFrame];
    
    self.circleView.layer.cornerRadius = circleSize / 2;
    
    self.circleView.transform = scaleZero;
    
    [header addSubview:self.circleView];
    
    
    
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    
    temperatureLabel.backgroundColor = [UIColor clearColor];
    
    temperatureLabel.textColor = [UIColor whiteColor];
    
    temperatureLabel.text = @"0°";
    
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:76];
    
    temperatureLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.circleView addSubview:temperatureLabel];
    
    
  
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    
    conditionsLabel.backgroundColor = [UIColor clearColor];
    
    conditionsLabel.textColor = [UIColor whiteColor];
    
    conditionsLabel.text = @"";
    
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
    conditionsLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.circleView addSubview:conditionsLabel];
   
    
    
    UILabel *hiLabel = [[UILabel alloc] initWithFrame:hiFrame];
    
    hiLabel.backgroundColor = [UIColor whiteColor];
    
    hiLabel.textColor = [UIColor colorWithRed:1 green:0.384 blue:0.357 alpha:1];
    
    hiLabel.text = @"0°";
    
    hiLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
    hiLabel.textAlignment = NSTextAlignmentCenter;
    
    hiLabel.layer.cornerRadius = hiLoTemperatureSize / 2;
    
    hiLabel.layer.masksToBounds = YES;
    
    hiLabel.transform = scaleZero;
    
    [self.circleView addSubview:hiLabel];
    
    
    
    UILabel *loLabel = [[UILabel alloc] initWithFrame:loFrame];
    
    loLabel.layer.cornerRadius = hiLoTemperatureSize / 2;
    
    loLabel.backgroundColor = [UIColor whiteColor];
    
    loLabel.textColor = [UIColor colorWithRed:0.051 green:0.38 blue:0.682 alpha:1];
    
    loLabel.text = @"0°";
    
    loLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
    loLabel.textAlignment = NSTextAlignmentCenter;
    
    loLabel.layer.cornerRadius = hiLoTemperatureSize / 2;
    
    loLabel.layer.masksToBounds = YES;
    
    loLabel.transform = scaleZero;
    
    [self.circleView addSubview:loLabel];
    
    
    
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, inset, headerFrame.size.width, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    
    cityLabel.textColor = [UIColor whiteColor];
    
    cityLabel.text = @"Loading...";
    
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
    cityLabel.textAlignment = NSTextAlignmentCenter;
    
    [header addSubview:cityLabel];
    
    
    
    [[WeatherManager sharedManager] findCurrentLocation];
    
    [[RACObserve([WeatherManager sharedManager], currentCondition) deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(WeatherCondition *newCondition) {
        if (newCondition) {
            
            UIColor *backgroundColor = [[newCondition temperatureColor] colorWithAlphaComponent:0.5];
            
            self.circleView.backgroundColor = backgroundColor;
            
            temperatureLabel.text = [NSString stringWithFormat:@"%.0f°", newCondition.temperature.floatValue];
            
            conditionsLabel.text = [newCondition.condition capitalizedString];
            
            cityLabel.text = [newCondition.locationName capitalizedString];
            
            
            [UIView animateWithDuration:0.4
             
                                  delay:0
             
                 usingSpringWithDamping:0.7
             
                  initialSpringVelocity:0.2
             
                                options:UIViewAnimationOptionCurveEaseOut
             
                             animations:^{
                                 
                                 CGAffineTransform scaleTrans = CGAffineTransformMakeScale(1, 1);
                                 
                                 self.circleView.transform = scaleTrans;
                                 
                             }
             
                             completion:nil];
            
            
            [UIView animateWithDuration:0.6
             
                                  delay:0.2
             
                 usingSpringWithDamping:0.6
             
                  initialSpringVelocity:0.1
             
                                options:UIViewAnimationOptionCurveEaseOut
             
                             animations:^{
                                 
                                 CGAffineTransform scaleTrans = CGAffineTransformMakeScale(1, 1);
                                 
                                 hiLabel.transform = scaleTrans;
                                 
                                 loLabel.transform = scaleTrans;
                             }
                             completion:nil];
        }
        
    }];
    
    [[RACObserve([WeatherManager sharedManager], hourlyForecast) deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSArray *newForecast) {
        
        [self.tableView reloadData];
        
    }];
    
    [[RACObserve([WeatherManager sharedManager], dailyForecast) deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSArray *newForecast) {
        
        [self.tableView reloadData];
        
    }];
 
    
    RAC(hiLabel, text) = [[RACSignal combineLatest:@[RACObserve([WeatherManager sharedManager], currentCondition.tempHigh)]
                                            reduce:^(NSNumber *high) {
                                                return [NSString stringWithFormat:@"%.0f°", high.floatValue];
                                            }] deliverOn:RACScheduler.mainThreadScheduler];
    
    RAC(loLabel, text) = [[RACSignal combineLatest:@[RACObserve([WeatherManager sharedManager], currentCondition.tempLow)]
                                            reduce:^(NSNumber *low) {
                                                return [NSString stringWithFormat:@"%.0f°", low.floatValue];
                                            }] deliverOn:RACScheduler.mainThreadScheduler];
    ///refresh;
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addTopRefreshControlUsingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            [[WeatherManager sharedManager] findCurrentLocation];
            
            [[WeatherManager sharedManager] updateCurrentConditions];
            
            [[WeatherManager sharedManager] updateDailyForecast];
            
            [[WeatherManager sharedManager] updateHourlyForecast];
        
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView topRefreshControlStopRefreshing];
            
            [weakSelf.tableView reloadData];
            
        });
        
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    self.tableView.statusTextColor = [UIColor orangeColor];
    
    self.tableView.loadingCircleColor = [UIColor orangeColor];
    
    self.tableView.arrowColor = [UIColor orangeColor];
    
}


- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    
    self.blurredImageView.frame = bounds;
    
    self.tableView.frame = bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return MIN([[WeatherManager sharedManager].hourlyForecast count], 6) + 1;
    }
    
    return MIN([[WeatherManager sharedManager].hourlyForecast count], 6) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self configureHeaderCell:cell title:@"Hourly Forecasts"];
        }
        
        else {
            
            WeatherCondition *weather = [WeatherManager sharedManager].hourlyForecast[indexPath.row - 1];
            
            
            [self configureHourlyCell:cell weather:weather];
            
            
        }
        
    }
    
    else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            [self configureHeaderCell:cell title:@"Daily Forecast"];
            
        }
        
        else {
            
            WeatherCondition *weather = [WeatherManager sharedManager].dailyForecast[indexPath.row - 1];
            [self configureDailyCell:cell weather:weather];
            
        }
    }
    
    return cell;
}

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    cell.textLabel.text = title;
    
    cell.detailTextLabel.text = @"";
    
    cell.imageView.image = nil;
}

- (void)configureHourlyCell:(UITableViewCell *)cell weather:(WeatherCondition *)weather {
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°", weather.temperature.floatValue];
    
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.backgroundColor = [[weather temperatureColor] colorWithAlphaComponent:0.5];
    
}

- (void)configureDailyCell:(UITableViewCell *)cell weather:(WeatherCondition *)weather {
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°", weather.tempHigh.
                                 floatValue, weather.tempLow.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.backgroundColor = [[weather temperatureColor] colorWithAlphaComponent:0.5];
    
}

- (void)refresh {
    NSLog(@"Refreshing content...");
    [[WeatherManager sharedManager] findCurrentLocation];
}

#pragma mark - UIScorllViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat height = scrollView.bounds.size.height;
    
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    
    CGFloat percent = MIN(position / height, 1.0);
    
    self.blurredImageView.alpha = percent;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    
    return self.screenHeight / (CGFloat)cellCount;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
