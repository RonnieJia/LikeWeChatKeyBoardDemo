//
//  ViewController.m
//  RJKeyBoard
//
//  Created by jia on 16/4/27.
//  Copyright © 2016年 RJ. All rights reserved.
//

#import "ViewController.h"
#import "RJKeyBoard.h"
#import <AVFoundation/AVFoundation.h>

#import "VoiceView.h"

@interface ViewController ()<RJKeyBoardDelegate>
@property (nonatomic, weak)RJKeyBoard *keyBoard;
@property (nonatomic, weak)VoiceView *voice;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"chatBar_colorMore_photoSelected",@"chatBar_colorMore_audioCall",@"chatBar_colorMore_location",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png",@"chatBar_colorMore_video.png"];
    
    RJKeyBoard *bc = [[RJKeyBoard alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 46, [UIScreen mainScreen].bounds.size.width,46)];
    self.keyBoard = bc;
    bc.delegate = self;
    bc.imageArray = array;
    bc.placeholder = @"我来说几句";
    bc.currentCtr = self;
    bc.placeholderColor = [UIColor colorWithRed:133/255 green:133/255 blue:133/255 alpha:0.5];
    bc.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bc];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view, typically from a nib.
    
    VoiceView *voice = [[VoiceView alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    voice.backgroundColor = [UIColor redColor];
    [self.view addSubview:voice];
    self.voice = voice;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnclick {
    [self.keyBoard playVoice];
}

- (void)tap {
    [self.keyBoard resignFirstRespoder];

}

- (void)didSendText:(NSString *)text
{
    NSLog(@"%@",text);
}
- (void)returnHeight:(CGFloat)height
{
    NSLog(@"%f",height);
}
- (void)returnImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.image = image;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
