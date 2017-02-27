//
//  YWCodeLineView.m
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "YWCodeLineView.h"

@interface YWCodeLineView ()
//扫描线
@property (nonatomic,strong)UIImageView *lineView;

@end

@implementation YWCodeLineView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super init];
    
    if (self) {
        _lineView = [[UIImageView alloc] initWithFrame:frame];
        _lineView.image = [UIImage imageNamed:@"line"];
    }
    return self;
}
/**
 实现协议的方法
 
 @return 获取code的视图
 */
- (UIView *)getCodeView{
    
    return _lineView;
}
/**
 设置code的view的背景图
 
 @param image 背景图
 */
- (void)setCodeViewBgImage:(UIImage *)image{

    _lineView.image = image;
}

@end
