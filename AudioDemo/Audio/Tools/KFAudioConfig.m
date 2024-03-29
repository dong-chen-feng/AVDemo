//
//  KFAudioConfig.m
//  AudioDemo
//
//  Created by dcf on 2022/7/27.
//

#import "KFAudioConfig.h"

@implementation KFAudioConfig

+ (instancetype)defaultConfig {
    KFAudioConfig *config = [[self alloc] init];
    config.channels = 2;
    config.sampleRate = 44100;
    config.bitDepth = 16;
    
    return config;
}

@end
