//
//  VoiceView.m
//  RJKeyBoard
//
//  Created by jia on 16/4/27.
//  Copyright © 2016年 RJ. All rights reserved.
//

#import "VoiceView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface VoiceView ()<AVAudioRecorderDelegate>
@property (nonatomic, strong)AVAudioRecorder *recorder;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation VoiceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupButton];
        [self audio];
    }
    return self;
}

- (void)setupButton {
    UIButton *pressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pressBtn.layer.cornerRadius = 2.0f;
    pressBtn.layer.borderColor = [UIColor grayColor].CGColor;
    pressBtn.layer.borderWidth = 1.0f;
    pressBtn.frame = self.bounds;
    [self addSubview:pressBtn];
    [pressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [pressBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [pressBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    
    [pressBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];// 按下按钮
    
    [pressBtn addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];// 录制完成
    
    [pressBtn addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragExit];// 放弃录制
}

- (void)btnDown:(id)sender

{
    
    //创建录音文件，准备录音
    
    if ([self.recorder prepareToRecord]) {
        
        //开始录制
        NSLog(@"kaishi");
        [self.recorder record];
        
    }
    
    //设置NSTimer定时检测，刷新音量数据
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    
}

- (void)btnUp:(id)sender

{
    if (self.recorder.currentTime > 2) {//如果录制时间<2s 不发送
        
        NSLog(@"wancehng111");
        [self.recorder deleteRecording];
        
    }else {
        NSLog(@"wancehng");

        //说话事件太短，要删除记录的文件
        
        [self.recorder deleteRecording];
        
    }
    
    [self.recorder stop];
    
    [self.timer invalidate];
    
}

- (void)btnDragUp:(id)sender

{
    
    //删除录制文件
    NSLog(@"cancel");

    [self.recorder deleteRecording];
    
    [self.recorder stop];
    
    [self.timer invalidate];
    
}

- (void)detectionVoice

{
    [self.recorder updateMeters];//刷新音量数据
}

- (void)audio {
    //录音设置
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    
    [recordSetting setValue:[NSNumber numberWithFloat:96000] forKey:AVSampleRateKey];
    
    //录音通道数  1 或 2
    
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    
    //线性采样位数  8、16、24、32
    
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    
    //录音的质量
    
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/voice.caf", strUrl]];
    
    //语音录制完成后存放在本地，我们将该本地路径赋值给我们全局定义好的NSURL类型的voiceUrl
    
    self.voiceUrl = url;
    
    NSError *error;
    
    //初始化
    
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    
    //开启音量检测
    
    self.recorder.meteringEnabled = YES;
    
    self.recorder.delegate = self;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    [session setActive:YES error:&error];
}

@end
