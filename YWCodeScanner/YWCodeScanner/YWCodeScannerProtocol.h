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

- (void)didmissViewValue:(NSString *)value;

@end
