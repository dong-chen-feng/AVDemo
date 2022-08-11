//
//  KFAudioCaptureViewController.m
//  AudioDemo
//
//  Created by dcf on 2022/7/28.
//  实现采集音频数据进行 AAC 编码、M4A 封装和存储的逻辑。

#import "KFAudioCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KFAudioCapture.h"
#import "KFAudioEncoder.h"
#import "KFMP4Muxer.h"

@interface KFAudioCaptureViewController ()

@property (nonatomic, strong) KFAudioConfig *audioConfig;
@property (nonatomic, strong) KFAudioCapture *audioCapture;
//@property (nonatomic, strong) NSFileHandle *fileHandle;//用来把 pcm 数据写入本地
@property (nonatomic, strong) KFAudioEncoder *audioEncoder;
@property (nonatomic, strong) KFMuxerConfig *muxerConfig;
@property (nonatomic, strong) KFMP4Muxer *muxer;

@end

@implementation KFAudioCaptureViewController

#pragma mark - Property
- (KFAudioConfig *)audioConfig {
    if (!_audioConfig) {
        _audioConfig = [KFAudioConfig defaultConfig];
    }
    
    return _audioConfig;
}

- (KFAudioCapture *)audioCapture {
    if (!_audioCapture) {
        __weak typeof(self) weakSelf = self;
        _audioCapture = [[KFAudioCapture alloc] initWithConfig:self.audioConfig];
        _audioCapture.errorCallBack = ^(NSError* error) {
            NSLog(@"KFAudioCapture error: %zi %@", error.code, error.localizedDescription);
        };
        // 音频采集数据回调。
        //在这里将 PCM 数据写入文件。
//        _audioCapture.sampleBufferOutputCallBack = ^(CMSampleBufferRef sampleBuffer) {
//            if (sampleBuffer) {
//                // 1、获取 CMBlockBuffer，这里面封装着 PCM 数据。
//                CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
//                size_t lengthAtOffsetOutput, totalLengthOutput;
//                char *dataPointer;
//
//                // 2、从 CMBlockBuffer 中获取 PCM 数据存储到文件中。
//                CMBlockBufferGetDataPointer(blockBuffer, 0, &lengthAtOffsetOutput, &totalLengthOutput, &dataPointer);
//                [weakSelf.fileHandle writeData:[NSData dataWithBytes:dataPointer length:totalLengthOutput]];
//            }
//        };
        //在这里采集的 PCM 数据送给编辑器
        _audioCapture.sampleBufferOutputCallBack = ^(CMSampleBufferRef  _Nonnull sample) {
            [weakSelf.audioEncoder encodeSampleBuffer:sample];
        };
    }
    
    return _audioCapture;
}

//- (NSFileHandle *)fileHandle {
//    if (!_fileHandle) {
//        NSString *audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.pcm"];
//        NSLog(@"PCM file path: %@", audioPath);
//        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
//        [[NSFileManager defaultManager] createFileAtPath:audioPath contents:nil attributes:nil];
//        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:audioPath];
//    }
//
//    return _fileHandle;
//}

- (KFAudioEncoder *)audioEncoder {
    if (!_audioEncoder) {
        __weak typeof(self) weakSelf = self;
        _audioEncoder = [[KFAudioEncoder alloc] initWithAudioBitrate:96000];
        _audioEncoder.errorCallBack = ^(NSError * _Nonnull error) {
            NSLog(@"KFAudioEncoder error:%zi %@",error.code,error.localizedDescription);
        };
        //音频编码数据回调.这里编码的 AAC 数据送给封装器.
        //与之前将编码后的AAC 数据存储为 AAC 文件不同的是,这里编码后送给封装器的 AAC 数据是没有添加 ADTS 头的,因为我们这里封装的是M4A格式,不需要 ADTS 头.
        _audioEncoder.sampleBufferOutputCallBack = ^(CMSampleBufferRef  _Nonnull sample) {
            [weakSelf.muxer appendSampleBuffer:sample];
        };
    }
    return _audioEncoder;
}

- (KFMuxerConfig *)muxerConfig {
    if (!_muxerConfig) {
        _muxerConfig = [[KFMuxerConfig alloc] init];
        NSString *audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.m4a"];
        NSLog(@"M4A file path: %@",audioPath);
        [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
        _muxerConfig.outputURL = [NSURL fileURLWithPath:audioPath];
        _muxerConfig.muxerType = KFMediaAudio;
    }
    return _muxerConfig;
}

- (KFMP4Muxer *)muxer {
    if (!_muxer) {
        _muxer = [[KFMP4Muxer alloc] initWithConfig:self.muxerConfig];
        _muxer.errorCallBack = ^(NSError * _Nonnull error) {
            NSLog(@"KFMP4Muxer error:%zi %@",error.code, error.localizedDescription);
        };
    }
    return _muxer;
}
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAudioSession];
    [self setupUI];
    
    // 完成音频采集后，可以将 App Document 文件夹下面的 test.pcm 文件拷贝到电脑上，使用 ffplay 播放：
    // ffplay -ar 44100 -channels 2 -f s16le -i test.pcm
    // ffplay -i test.m4a
}

//- (void)dealloc {
//    if (_fileHandle) {
//        [_fileHandle closeFile];
//    }
//}

#pragma mark - Setup
- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = @"Audio Muxer";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // Navigation item.
    UIBarButtonItem *startBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
    UIBarButtonItem *stopBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:self action:@selector(stop)];
//    self.navigationItem.rightBarButtonItems = @[startBarButton, stopBarButton];
    self.navigationItem.leftBarButtonItem = startBarButton;
    self.navigationItem.rightBarButtonItem = stopBarButton;

}

- (void)setupAudioSession {
    NSError *error = nil;
    
    // 1、获取音频会话实例。
    AVAudioSession *session = [AVAudioSession sharedInstance];

    // 2、设置分类和选项。
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    if (error) {
        NSLog(@"AVAudioSession setCategory error.");
        error = nil;
        return;
    }
    
    // 3、设置模式。
    [session setMode:AVAudioSessionModeVideoRecording error:&error];
    if (error) {
        NSLog(@"AVAudioSession setMode error.");
        error = nil;
        return;
    }

    // 4、激活会话。
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"AVAudioSession setActive error.");
        error = nil;
        return;
    }
}

#pragma mark - Action
- (void)start {
    //启动采集器
    [self.audioCapture startRunning];
    
    //启动封装器
    [self.muxer startWriting];
}

- (void)stop {
    //停止采集器
    [self.audioCapture stopRunning];
    
    //停止封装器
    [self.muxer stopWriting:^(BOOL success, NSError * _Nonnull error) {
            NSLog(@"KFMP4Muxer %@",success ? @"success" : [NSString stringWithFormat:@"error %zi %@",error.code, error.localizedDescription]);
        }];
}

@end
