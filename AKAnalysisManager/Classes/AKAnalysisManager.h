//
//  AKAnalysisManager.h
//  Pods
//
//  Created by 李翔宇 on 2017/3/16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AKAnalysisManager : NSObject

/**
 标准单例模式
 
 @return AKAnalysisManager
 */
+ (AKAnalysisManager *)manager;

@property (class, nonatomic, assign, getter=isDebug) BOOL debug;

@property (class, nonatomic, copy) NSString *channel;

/**
 启动数据分析，异步操作
 
 @param appKey 数据服务平台提供的appKey
 */
+ (void)startAnalysis:(NSString *)appID;

@property (class, nonatomic, assign, getter=isTrackLocation) BOOL trackLocation;

/**
 设置全局参数
 
 @param value 全局参数
 @param key 参数对应key
 */
+ (void)setGlobalValue:(id)value forKey:(NSString *)key;

/**
 统计自定义事件
 
 @param eventID 事件ID
 */
+ (void)trackEvent:(NSString *)eventID;

/**
 统计带标签的自定义事件，用标签来区别同一个事件的不同应用场景
 
 @param eventID 事件ID
 @param label 标签
 */
+ (void)trackEvent:(NSString *)eventID label:(NSString *)label;

/**
 统计带标签的自定义事件，用标签来区别同一个事件的不同应用场景，添加更多业务参数
 
 @param eventID 事件ID
 @param label 标签
 @param params 业务参数
 */
+ (void)trackEvent:(NSString *)eventID label:(NSString *)label params:(NSDictionary *)params;

/**
 开始对象跟踪
 
 @param page 页面
 */
+ (void)trackObjectBegin:(NSString *)name;

/**
 结束对象跟踪
 
 @param page 页面
 */
+ (void)trackObjectEnd:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
