//
//  ViewController.m
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "ViewController.h"
#import "YWCodeFactory.h"

@interface ViewController ()<YWCodeScannerProtocol>
{
    YWCodeFactory *_factory;
}
@end



@implementation ViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    _factory = [[YWCodeFactory alloc]init];
    
   id<YWCodeScannerProtocol>codeTool = [_factory getCodeView:CGRectMake(([UIScreen mainScreen].bounds.size.width - 280) /2.0, 100, 280, 280)];
    //获取背景
    [self.view addSubview:[codeTool getCodeView]];
    //获取线
    id<YWCodeScannerProtocol>lineTool = [_factory getCodeLineView:CGRectMake(0, 0, 280, 2)];
    
    [[codeTool getCodeView] addSubview:[lineTool getCodeView]];
////  方法一：  使用代理获取扫描值
//    _factory.delegate = self;
//    
    [_factory startQRCode:self.view];
    
//    方法二：block回调
    __weak typeof(self) weakSelf = self;

    _factory.returnCodeBlock = ^(NSString * code){
        
       [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    };
    
    
}
//方法一
//- (void)didmissViewValue:(NSString *)value{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end
