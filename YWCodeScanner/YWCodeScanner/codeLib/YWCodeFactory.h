//
//  YWCodeFactory.h
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWCodeScannerProtocol.h"
#import <AVFoundation/AVFoundation.h>

@interface YWCodeFactory : NSObject

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


/** 代理*/
@property (nonatomic, weak) id<YWCodeScannerProtocol>delegate;

/**
 *  1发送方声明回调的block引用
 */
@property (nonatomic, copy) void(^returnCodeBlock)(NSString * code);

-(id<YWCodeScannerProtocol>)getCodeView:(CGRect)frame;
-(id<YWCodeScannerProtocol>)getCodeLineView:(CGRect)frame;

/**
 开始扫描

 @param layerView 控制器的view
 */
-(void)startQRCode:(UIView *)layerView;




@end
