//
//  YWCodeImageFactory.m
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "YWCodeImageFactory.h"

@implementation YWCodeImageFactory

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super init]) {
        
    }
    return self;
}

- (CIImage *)getCodeWithDefalutData:(NSString *)data{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 2、设置数据
    NSString *info = data;
    // 将字符串转换成
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    
    // 通过KVC设置滤镜inputMessage数据
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    
    // 3、获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    
    return outputImage;
}

/**
 返回常态的图片

 @param data 需要生成二维码的参数
 @return 返回图片
 */
- (UIImage *)getCodeDefalutData:(NSString *)data{
    
    CIImage *CI_image = [self getCodeWithDefalutData:data];
    
    return  [UIImage imageWithCIImage:CI_image];
}
/**
 返回常态的图片
 
 @param data 需要生成二维码的参数
 @param size 需要修改二维码大小的宽度
 @return 返回图片
 */
- (UIImage *)getCodeHightDefalut:(NSString *)data withImageSize:(CGFloat)size{
    
    CIImage *CI_image = [self getCodeWithDefalutData:data];

    
    CGRect extent = CGRectIntegral(CI_image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:CI_image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 生成一张带有logo的二维码

 @param logo logo的image名
 @param data 需要生成二维码的参数
 @param logoScale logo相对父视图（二维码）的比例
 @return 返回图片
 */
- (UIImage *)getCodeWithLogo:(NSString *)logo
                   withParam:(NSString *)data withSamllLogoScale:(CGFloat)logoScale{
    
   CIImage *outputImage = [self getCodeWithDefalutData:data];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    
    // 开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    
    // 再把小图片画上去
    NSString *icon_imageName = logo;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * logoScale;
    CGFloat icon_imageH = start_image.size.height * logoScale;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束编辑图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;

    
}


/**
 生成一张带有颜色的二维码
 
 @param data logo的image名
 @param backgroundColor 背景色
 @param mainColor 主色
 @return 返回图片
 */
- (UIImage *)getCodeWithtData:(NSString *)data
              backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor{
    
    // 获得滤镜输出的图像
    CIImage *outputImage= [self getCodeWithDefalutData:data];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    // 创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
//    inputImage,
//    inputColor0,
//    inputColor1
    NSLog(@"所有的key---%@",color_filter.inputKeys);
    
    // 需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];

    
}

@end
