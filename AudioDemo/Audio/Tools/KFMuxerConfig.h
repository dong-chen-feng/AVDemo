//
//  KFMuxerConfig.h
//  AudioDemo
//
//  Created by dcf on 2022/8/5.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "KFMediaBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface KFMuxerConfig : NSObject

@property (nonatomic, strong) NSURL *outputURL; // 封装文件输出地址。
@property (nonatomic, assign) KFMediaType muxerType; // 封装文件类型。
@property (nonatomic, assign) CGAffineTransform preferredTransform; // 图像的变换信息。比如：视频图像旋转。

@end

NS_ASSUME_NONNULL_END
