//
//  YWCodeFactory.m
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "YWCodeFactory.h"
#import "YWCodeView.h"
#import "YWCodeLineView.h"

@interface YWCodeFactory ()<AVCaptureMetadataOutputObjectsDelegate>

//设备对象(实例化摄像头)
@property (nonatomic,strong)AVCaptureDevice *device;

//输入流对象
@property (nonatomic,strong)AVCaptureDeviceInput *deviceInput;

//输出流对象(元数据:描述数据特征的数据)
//元数据:http://www.ruanyifeng.com/blog/2007/03/metadata.html
@property (nonatomic,strong)AVCaptureMetadataOutput *output;

//扫描会话
@property (nonatomic,strong)AVCaptureSession *Session;

//扫描图层
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *layer;


@property (nonatomic) id<YWCodeScannerProtocol>codeFactory;

@property (nonatomic) id<YWCodeScannerProtocol>codeLineFactory;


@end

@implementation YWCodeFactory

/**
 通过工厂模式获取相应codeview
 
 @param frame frame
 @return view
 */
- (id<YWCodeScannerProtocol>)getCodeView:(CGRect)frame{
    
    _codeFactory = [[YWCodeView alloc]initWithFrame:frame];
    
    return _codeFactory;
}
/**
 通过工厂模式获取相应codeLineView
 
 @param frame frame
 @return view
 */
-(id<YWCodeScannerProtocol>)getCodeLineView:(CGRect)frame{
    _codeLineFactory = [[YWCodeLineView alloc]initWithFrame:frame];
    return _codeLineFactory;
}

-(void)startQRCode:(UIView *)layerView{
    
    //实例化设备对象
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //实例化输入流对象
    NSError *error = nil;
    self.deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    
    if (error) {
        NSLog(@"不是真机");
        return;
    }
    
    //实例化输出流对象
    self.output = [AVCaptureMetadataOutput new];
    
    //添加代理
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //实例化扫描会话
    self.Session = [AVCaptureSession new];
    
    [self.Session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //添加输入和输入流对象
    [self.Session addInput:self.deviceInput];
    [self.Session addOutput:self.output];
    
    /*一定要在扫描会话添加了输出流以后,才能设置扫描的类型,否则会造成崩溃*/
    //设置扫描的类型
    /*
     AVMetadataObjectTypeQRCode 二维码类型
     
     AVMetadataObjectTypeCode128Code 条形码
     AVMetadataObjectTypeCode39Code
     AVMetadataObjectTypeCode39Mod43Code
     AVMetadataObjectTypeCode93Code
     */
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code];
    
    
    //扫描图层
    self.layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.Session];
    
    //设置图层的大小
    self.layer.frame = [_codeFactory getCodeView].frame;
    
    //把扫描图层插入到图层的最底部
    [layerView.layer insertSublayer:self.layer atIndex:0];
    
    //会话拉伸铺满整个图层
    //AVLayerVideoGravityResizeAspectFill 拉伸
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //开始扫描
    [self.Session startRunning];
    
    //启动扫描线
    [self moveViewAround];
}
-(void)moveViewAround{
    
    [UIView animateWithDuration:3.0f animations:^{
        
        //改变坐标
        CGRect rect = [_codeLineFactory getCodeView].frame;
        rect.origin.y += 278;
        [_codeLineFactory getCodeView].frame = rect;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:3.0f animations:^{
            
            //改变坐标
            CGRect rect = [_codeLineFactory getCodeView].frame;
            rect.origin.y -= 278;
            [_codeLineFactory getCodeView].frame = rect;

            
        } completion:^(BOOL finished) {
            
            //递归
            [self moveViewAround];
            
        }];
        
        
    }];
    
}
#pragma mark- AVCaptureMetadataOutputObjectsDelegate
//扫描完成后的回调代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    //手动停止扫描
    [self.Session stopRunning];

    NSLog(@"stringValue = %@",[metadataObjects[0] stringValue]);
    
    [self performSelector:@selector(delayMethod:) withObject:[metadataObjects[0] stringValue] /*可传任意类型参数*/ afterDelay:2.0];
    

}

- (void)delayMethod:(NSString *)value{
    
    if (![_video isEqualToString:@""]&&_video) {
        // 0、扫描成功之后的提示音
        [self playSoundEffect:_video];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didmissViewValue:)]) {
        
        [self.delegate didmissViewValue:value];
    }
    
    if (self.returnCodeBlock) {
        self.returnCodeBlock(value);
    }
}

- (void)setVideo:(NSString *)video{
    
    _video = video;
}

#pragma mark - - - 扫描提示声
/** 播放音效文件 */
- (void)playSoundEffect:(NSString *)name{
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    NSLog(@"播放完成...");
}


@end
