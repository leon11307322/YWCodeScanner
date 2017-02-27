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

/** 音频昵称--默认无铃声*/
@property (nonatomic, copy) NSString *video;

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
