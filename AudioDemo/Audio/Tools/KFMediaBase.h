//
//  KFMediaBase.h
//  AudioDemo
//
//  Created by dcf on 2022/8/8.
//

#ifndef KFMediaBase_h
#define KFMediaBase_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KFMediaType) {
    KFMediaNone = 0,
    KFMediaAudio = 1 << 0, // 仅音频。
    KFMediaVideo = 1 << 1, // 仅视频。
    KFMediaAV = KFMediaAudio | KFMediaVideo,  // 音视频都有。
};

#endif /* KFMediaBase_h */
