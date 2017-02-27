//
//  YWCodeScannerProtocol.h
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YWCodeScannerProtocol <NSObject>
@optional

#pragma mark ---- 二维码扫描相关---------

/**
 统一初始化格式
 
 @param frame frame
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 获取code的view

 @return view
 */
- (UIView *)getCodeView;

/**
 设置code的view的背景图

 @param image 背景图
 */
- (void)setCodeViewBgImage:(UIImage *)image;

/**
 二维码或者条形码扫描成功的代理方法

 @param value 扫描结果
 */
- (void)didmissViewValue:(NSString *)value;

#pragma mark ---- 二维码生成相关---------
/**
 返回常态的图片
 
 @param data 需要生成二维码的参数
 @return 返回图片
 */
- (UIImage *)getCodeDefalutData:(NSString *)data;
/**
 返回常态的图片
 
 @param data 需要生成二维码的参数
 @param size 需要修改二维码大小的宽度
 @return 返回图片
 */
- (UIImage *)getCodeHightDefalut:(NSString *)data withImageSize:(CGFloat)size;
/**
 生成一张带有logo的二维码
 
 @param logo logo的image名
 @param data 需要生成二维码的参数
 @param logoScale logo相对父视图（二维码）的比例
 @return 返回图片
 */
- (UIImage *)getCodeWithLogo:(NSString *)logo
                   withParam:(NSString *)data withSamllLogoScale:(CGFloat)logoScale;
/**
 生成一张带有logo的二维码
 
 @param data logo的image名
 @param backgroundColor 需要生成二维码的参数
 @param mainColor logo相对父视图（二维码）的比例
 @return 返回图片
 */
- (UIImage *)getCodeWithtData:(NSString *)data
              backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;
@end
