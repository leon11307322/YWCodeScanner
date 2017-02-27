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
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code];
    
    
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didmissViewValue:)]) {
        
        [self.delegate didmissViewValue:value];
    }
    
    if (self.returnCodeBlock) {
        self.returnCodeBlock(value);
    }
}



@end
