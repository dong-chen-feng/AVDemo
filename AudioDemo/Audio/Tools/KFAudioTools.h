//
//  KFAudioTools.h
//  AudioDemo
//
//  Created by dcf on 2022/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFAudioTools : NSObject

+ (NSData *)adtsDataWithChannels:(NSInteger)channels sampleRate:(NSInteger)sampleRate rawDataLength:(NSInteger)rawDataLength;

@end

NS_ASSUME_NONNULL_END
