//
//  KFMuxerConfig.m
//  AudioDemo
//
//  Created by dcf on 2022/8/5.
//

#import "KFMuxerConfig.h"

@implementation KFMuxerConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _muxerType = KFMediaAV;
        _preferredTransform = CGAffineTransformIdentity;
    }
    return self;
}

@end
