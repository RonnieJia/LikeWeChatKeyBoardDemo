//
//  VoiceView.m
//  RJKeyBoard
//
//  Created by jia on 16/4/27.
//  Copyright © 2016年 RJ. All rights reserved.
//

#import "VoiceView.h"
#import <AVFoundation/AVFoundation.h>

@interface VoiceView ()<AVAudioRecorderDelegate>

{
    //录音器
    AVAudioRecorder *recorder;
    //播放器
    AVAudioPlayer *player;
    NSDictionary *recorderSettingsDict;
    
    //定时器
    NSTimer *timer;
    //图片组
    NSMutableArray *volumImages;
    double lowPassResults;
    
    //录音名字
    NSString *playName;

}
@end

@implementation VoiceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupSession];
        [self setupButton];
    }
    return self;
}

- (void)setupSession {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
    
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    playName = [NSString stringWithFormat:@"%@/play.aac",docDir];
    self.voiceUrl = playName;
    //录音设置
    recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                           [NSNumber numberWithInt:1000.0],AVSampleRateKey,
                           [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                           [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                           nil];
    
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
    if ([self canRecord]) {
        
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:playName] settings:recorderSettingsDict error:&error];
        
        if (recorder) {
            recorder.meteringEnabled = YES;
            if ([recorder prepareToRecord]) {
            [recorder record];
            }
            
            //启动定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
            
        } else {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
    }

    
}

- (void)playVoice {
    NSError *playerError;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:playName] error:&playerError];
    if (player == nil)
    {
        NSLog(@"ERror creating player: %@", [playerError description]);
    }else{
        [player play];
    }
    //服务器上传文件
}

- (void)btnUp:(id)sender

{
    if (recorder.currentTime > 2) {//如果录制时间<2s 不发送
        
        //松开 结束录音
        
        //播放
        
        //图片重置

    }else {
        NSLog(@"wancehng");

        //说话事件太短，要删除记录的文件
        
        [recorder deleteRecording];
        
    }
    
    [recorder stop];
    recorder = nil;
    [timer invalidate];
    timer = nil;
    
}

- (void)btnDragUp:(id)sender

{
    
    //删除录制文件
    NSLog(@"cancel");

    [recorder deleteRecording];
    
    [recorder stop];
    
    [timer invalidate];
    
}

-(void)levelTimer:(NSTimer*)timer_
{
    //call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
    [recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
    NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
    /*
    if (lowPassResults>=0.8) {
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:7]];
    }else if(lowPassResults>=0.7){
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:6]];
    }else if(lowPassResults>=0.6){
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:5]];
    }else if(lowPassResults>=0.5){
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:4]];
    }else if(lowPassResults>=0.4){
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:3]];
    }else if(lowPassResults>=0.3){
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:2]];
    }else if(lowPassResults>=0.2){
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:1]];
    }else if(lowPassResults>=0.1){
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:0]];
    }else{
        soundLodingImageView.image = [UIImage imageNamed:[volumImages objectAtIndex:0]];
    }
    */
}


//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}

@end
