//
//  AKAnalysisManager.m
//  Pods
//
//  Created by 李翔宇 on 2017/3/16.
//
//

#import "AKAnalysisManager.h"
#import <CoreLocation/CLLocationManager.h>
#import <TalkingData.h>
#import "AKAnalysisManagerMacro.h"

@interface AKAnalysisManager ()<CLLocationManagerDelegate>

@property (class, nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AKAnalysisManager

#pragma mark - 单例

+ (AKAnalysisManager *)manager {
    static AKAnalysisManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (id)alloc {
    return [self manager];
}

+ (id)allocWithZone:(NSZone * _Nullable)zone {
    return [self manager];
}

- (id)copy {
    return self;
}

- (id)copyWithZone:(NSZone * _Nullable)zone {
    return self;
}

#pragma mark - 公共方法

+ (void)startAnalysis:(NSString *)appID {
    dispatch_async(self.serialQueue, ^{
        AKAM_String_Nilable_Return(appID, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"appID不可为空");
            }
        });
        
        NSString *channel = self.channel;
        if(![channel isKindOfClass:[NSString class]]
           || !channel.length) {
            channel = @"AppStore";
        }
        
        [TalkingData sessionStarted:appID withChannelId:channel];
    });
}

+ (void)setGlobalValue:(id)value forKey:(NSString *)key {
    dispatch_async(self.serialQueue, ^{
        AKAM_String_Nilable_Return(key, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"key不可为空");
            }
        });
        
        [TalkingData setGlobalKV:key value:value];
    });
}

+ (void)trackEvent:(NSString *)eventID {
    dispatch_async(self.serialQueue, ^{
        AKAM_String_Nilable_Return(eventID, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"eventID不可为空");
            }
        });
        
        [TalkingData trackEvent:eventID];
    });
}

+ (void)trackEvent:(NSString *)eventID label:(NSString *)label {
    dispatch_async(self.serialQueue, ^{
        AKAM_String_Nilable_Return(eventID, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"eventID不可为空");
            }
        });
        
        AKAM_String_Nilable_Return(label, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"label不可为空");
            }
        });
        
        [TalkingData trackEvent:eventID label:label];
    });
}

+ (void)trackEvent:(NSString *)eventID label:(NSString *)label params:(NSDictionary *)params {
    dispatch_async(self.serialQueue, ^{
        AKAM_String_Nilable_Return(eventID, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"eventID不可为空");
            }
        });
        
        AKAM_String_Nilable_Return(label, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"label不可为空");
            }
        });
        
        if(![params isKindOfClass:[NSDictionary class]]
           || !params.allKeys.count) {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"params不可为空");
            }
            return;
        }
        
        [TalkingData trackEvent:eventID label:label parameters:params];
    });
}

+ (void)trackObjectBegin:(NSString *)name {
    dispatch_async(self.serialQueue, ^{
        AKAM_String_Nilable_Return(name, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"name不可为空");
            }
        });
        
        [TalkingData trackPageBegin:name];
    });
}

+ (void)trackObjectEnd:(NSString *)name {
    dispatch_async(self.serialQueue, ^{
        AKAM_String_Nilable_Return(name, NO, {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"name不可为空");
            }
        });
        
        [TalkingData trackPageEnd:name];
    });
}

#pragma mark - 私有方法

+ (dispatch_queue_t)serialQueue {
    NSString *label = [NSBundle.mainBundle.bundleIdentifier stringByAppendingString:@".AKAnalysisManager"];
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create(label.UTF8String, DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

+ (void)setTrackLocation:(BOOL)isTrack {
    if(isTrack) {
        if(![CLLocationManager locationServicesEnabled]) {
            if(self.isDebug) {
                AKAnalysisManagerLog(@"定位服务不可用");
            }
            return;
        }
        
        if(!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = [self manager];
        }
        
        switch (CLLocationManager.authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:{
                if(self.isDebug) {
                    AKAnalysisManagerLog(@"定位服务权限待请求");
                }
                [self.locationManager requestWhenInUseAuthorization];
                break;
            }
                
            case kCLAuthorizationStatusRestricted: {
                if(self.isDebug) {
                    AKAnalysisManagerLog(@"定位服务被限制");
                }
                return;
            }
                
            case kCLAuthorizationStatusDenied: {
                if(self.isDebug) {
                    AKAnalysisManagerLog(@"定位服务被拒绝");
                }
                return;
            }
                
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                /*case kCLAuthorizationStatusAuthorized:*/ {
                    if(self.isDebug) {
                        AKAnalysisManagerLog(@"定位服务可用");
                    }
                    [self.locationManager startUpdatingLocation];
                    break;
                }
                
            default:
                break;
        }
    }
}

+ (void)showLocationAuthorizationDeniedAlert {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"提示"
                                          message:@"定位服务被拒绝，是否重新打开？"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"去设置"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [rootViewController dismissViewControllerAnimated:YES completion:^{
                                                                  //                                                                   NSString *appStoreURL = [WeiboSDK getWeiboAppInstallUrl];
                                                                  //                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
                                                              }];
                                                          }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [rootViewController dismissViewControllerAnimated:YES completion:^{}];
                                                         }];
    [alertController addAction:settingAction];
    [alertController addAction:cancleAction];
    [rootViewController presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - CLLocationManagerDelegate
/*
 *  locationManager:didChangeAuthorizationStatus:
 *
 *  Discussion:
 *    Invoked when the authorization status changes for this application.
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(!AKAnalysisManager.isTrackLocation) {
        return;
    }
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            if(AKAnalysisManager.isDebug) {
                AKAnalysisManagerLog(@"定位服务权限待请求");
            }
            break;
        }
            
        case kCLAuthorizationStatusRestricted: {
            if(AKAnalysisManager.isDebug) {
                AKAnalysisManagerLog(@"定位服务被限制");
            }
        }
            
        case kCLAuthorizationStatusDenied: {
            if(AKAnalysisManager.isDebug) {
                AKAnalysisManagerLog(@"定位服务被拒绝");
            }
        }
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            /*case kCLAuthorizationStatusAuthorized:*/ {
                if(AKAnalysisManager.isDebug) {
                    AKAnalysisManagerLog(@"定位服务可用");
                }
                [manager startUpdatingLocation];
            }
            
        default:
            break;
    }
}

/*
 *  locationManager:didUpdateLocations:
 *
 *  Discussion:
 *    Invoked when new locations are available.  Required for delivery of
 *    deferred locations.  If implemented, updates will
 *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
 *
 *    locations is an array of CLLocation objects in chronological order.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    dispatch_async(AKAnalysisManager.serialQueue, ^{
        for(CLLocation *location in locations) {
            [TalkingData setLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        }
    });
}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(AKAnalysisManager.isDebug) {
        AKAnalysisManagerLog(@"%@", error);
    }
}

@end
