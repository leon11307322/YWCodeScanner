//
//  YWCodeView.m
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "YWCodeView.h"

@interface YWCodeView ()

//扫描背景图
@property (nonatomic,strong)UIImageView *bgView;


@end

@implementation YWCodeView


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super init];
    
    if (self) {
        _bgView = [[UIImageView alloc] initWithFrame:frame];
        _bgView.image = [UIImage imageNamed:@"pick_bg"];
    }
    return self;
}
/**
 实现协议的方法

 @return 获取code的视图
 */
- (UIView *)getCodeView{
    
    return _bgView;
}
/**
 设置code的view的背景图
 
 @param image 背景图
 */
- (void)setCodeViewBgImage:(UIImage *)image{
    
    _bgView.image = image;
}

@end
