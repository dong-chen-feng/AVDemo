//
//  KFMP4Muxer.h
//  AudioDemo
//
//  Created by dcf on 2022/8/8.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "KFMuxerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface KFMP4Muxer : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfig:(KFMuxerConfig *)config;

@property (nonatomic, strong, readonly) KFMuxerConfig *config;
@property (nonatomic, copy) void (^errorCallBack)(NSError *error); // 封装错误回调

- (void)startWriting; // 开始封装写入数据。
- (void)cancelWriting; // 取消封装写入数据。
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer; // 添加封装数据。
- (void)stopWriting:(void (^)(BOOL success, NSError *error))completeHandler; // 停止封装写入数据。


@end

NS_ASSUME_NONNULL_END
